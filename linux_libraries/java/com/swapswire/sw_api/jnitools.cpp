#include "sw_api.h"
#include "mw_swig_funcs.h"

#include <cstring>
#include <cstdlib>
#include <string.h>
#include <stdexcept>
#include <algorithm>
#include <ctype.h>
#include <memory>
#include <map>

namespace mw
{
    namespace JNI
    {
        namespace
        {
            static JavaVM* g_jvm;
            static jobject g_lock;
            static Callback g_sessionStateCallback;
            typedef std::map<SW_LoginID, SessionCallbacks*> Sessions;
            static Sessions g_sessionCallbackMap;
            static char const* const RBCIdent = "<ResultBatchCount>";

            // Returns true if a Java exception is pending in the JVM
            inline bool IsExceptionPending(JNIEnv* env)
            {
                return env->ExceptionCheck() == JNI_TRUE;
            }

            // RAII for Java local references
            template<class T> struct LocalRef
            {
                LocalRef(JNIEnv* env, T p)
                    : m_env(env),
                    m_ref(p)
                { }

                T get() const { return m_ref; }

                ~LocalRef()
                {
                    // Safe to call with an exception pending. No exceptions are raised.
                    if (m_env && m_ref)
                        m_env->DeleteLocalRef(m_ref);
                }

            private:
                JNIEnv* m_env;
                T m_ref;
                LocalRef(const LocalRef&);
                LocalRef& operator=(const LocalRef&);
            };

            typedef LocalRef<jobject> JObjectRef;
            typedef LocalRef<jstring> JStringRef;
            typedef LocalRef<jclass> JClassRef;

            // RAII For registering the JVM with native threads to provide a JNIEnv to execute on.
            class ScopedEnv
            {
            public:
                ScopedEnv()
                    : m_jvm(0),
                    m_env(0)
                {
                    // Attach the current thread to the JVM so we can call into Java
                    JavaVM* jvm = g_jvm;
                    if (!jvm)
                        return;  // No JVM was found - process is probably exiting

                    if (jvm->GetEnv((void**)&m_env, JNI_VERSION_1_2) == JNI_OK)
                        return;  // This thread is already attached to the jvm. Should never happen.

                    JNIEnv* env = 0;
                    if (jvm->AttachCurrentThread((void**)&env, 0) != JNI_OK)
                        return;             // Can't attach, leave our members null so dtor does nothing

                    m_jvm = jvm;            // Store VM pointer so we detach in the dtor

                    const int numRefs = 16; // Default number of refs allocated by the VM
                    if (env->PushLocalFrame(numRefs) != JNI_OK)
                        return;             // Can't push, leave m_env null so dtor only detaches

                    m_env = env;            // Store env so we pop stack frame in the dtor
                }

                bool IsOK() const { return m_env != 0; }
                JNIEnv* get() const { return m_env; }

                ~ScopedEnv()
                {
                    if (m_env)
                    {
                        if (IsExceptionPending(m_env))
                        {
                            // We can't return Java exceptions, we're in a native API thread.
                            // If there is one pending, dump it (which also clears it).
                            m_env->ExceptionDescribe();
                        }
                        m_env->PopLocalFrame(0);          // Pop the frame we previously pushed
                    }
                    if (m_jvm)
                        m_jvm->DetachCurrentThread();     // Detach our thread from the JVM
                }
            private:
                JavaVM* m_jvm;
                JNIEnv* m_env;
            };

            // Throws a deferred Java exception in the VM if there isn't already one pending
            static void ThrowJavaException(JNIEnv*     env,
                                           const char* type,
                                           const char* msg)
            {
                if (!IsExceptionPending(env))
                {
                    JClassRef exceptionClass(env, env->FindClass(type));
                    // If FindClass failed, it will have raised a pending exception for us.
                    if (exceptionClass.get())
                        env->ThrowNew(exceptionClass.get(), msg);
                }
            }

            static void ThrowOutOfMemoryException(JNIEnv* env)
            {
                ThrowJavaException(env, "java/lang/OutOfMemoryError", "Failed to allocate memory");
            }

            // Evaluate an expression that can throw bad_alloc; set Java exception and return false if it occurs
#define CATCH_BAD_ALLOC(env, expr)  try { expr; \
} catch (const std::exception&) { ThrowOutOfMemoryException(env); return 0; }

// RAII JNI mutex.
            class GlobalMonitorLock
            {
            public:
                GlobalMonitorLock(JNIEnv* env)
                    : m_env(env),
                    m_ok(m_env->MonitorEnter(g_lock) == 0)
                {
                }

                bool IsOK() const { return m_ok; }

                ~GlobalMonitorLock()
                {
                    if (m_ok)
                        m_env->MonitorExit(g_lock);
                }
            protected:
                JNIEnv* m_env;
                bool m_ok;
            };
        } // namespace

        extern "C"
        {
        static void OnUnload()
        {
            g_jvm = 0;
        }

        // called when Java goes System.loadLibrary(..)
#ifdef _WIN32
        JNIEXPORT jint JNICALL
#else
        jint
#endif
        JNI_OnLoad(JavaVM* jvm,
                   void*   reserved)
        {
            (void)reserved;
            if (atexit(&OnUnload))
                return JNI_ERR;

            g_jvm = jvm;
            ScopedEnv env;
            if (!env.IsOK())
                return JNI_ERR;

            // lock setup
            JClassRef objClass(env.get(), env.get()->FindClass("java/lang/Object"));
            if (!objClass.get())
                return JNI_ERR;
            jmethodID cid(env.get()->GetMethodID(objClass.get(), "<init>", "()V"));
            if (!cid)
                return JNI_ERR;
            JObjectRef lock(env.get(), env.get()->NewObject(objClass.get(), cid));
            if (!lock.get())
                return JNI_ERR;
            g_lock = env.get()->NewGlobalRef(lock.get());
            if (!g_lock)
                return JNI_ERR;
            return JNI_VERSION_1_4;
        }
        } // extern "C"

        bool consume(const char*& s,
                     const char*  m)
        {
            while (*m && *s == *m)
                ++s, ++m;
            return *m == 0;
        }

        bool iconsume(const char*& s,
                      const char*  m)
        {
            while (*m && tolower(*s) == *m)
                ++s, ++m;
            return *m == 0;
        }

        // Return true if the string looks like xml encoded in utf-8, nasty huristic
        // as we don't always know for sure if the field is xml or not
        bool LooksLikeUFT8XML(const char* s,
                              const char* e)
        {
            // While technically not allowed, we will skip leading whitespace
            while (isspace(*s))
                ++s;
            if (*s != '<')
                return false;
            ++s;
            const char* p = s;
            // Expect to find a close of the tag within 100 chars
            for (int j = 4096; *p != '>'; ++p, --j)
                if (j == 0 || !*p)
                    return false;
            // The start looks a bit like XML... lets see if the end looks like xml.
            // We don't check the tags match because comments, doctypes etc make it
            // too hard
            --e; // Move off the trailing zero
            while (e > p && isspace(*e))
                --e;
            if (*e != '>')
                return false;
            --e;
            for (int j = 100; *e != '<'; --e, --j)
                if (j == 0 || e == p)
                    return false;
            // Check to see if it is an xml declaration which may include the encoding
            if (!consume(s, "?xml"))
                return true; // Looks like xml, and has no encoding, defaults to utf-8
            // Skip whitespace after <?xml
            while (isspace(*s))
                ++s;
            // Should be version next - which is not optional
            if (!consume(s, "version"))
                return false;
            // Skip whitespace after version
            while (isspace(*s))
                ++s;
            if (*s != '=')
                return false;
            ++s;
            while (isspace(*s))
                ++s;
            // could be single or double quoted string
            if (*s != '"' && *s != '\'')
                return false;
            const char open = *s;
            ++s;
            while (*s && *s != open)
                ++s;
            if (*s != open)
                return false;
            ++s;
            // Skip whitespace after version
            while (isspace(*s))
                ++s;
            // If there is no encoding, then it defaults to utf-8
            if (!consume(s, "encoding"))
                return true;
            // There is an encoding, let's check what it is
            while (isspace(*s))
                ++s;
            if (*s != '=')
                return false;
            ++s;
            while (isspace(*s))
                ++s;
            if (*s != '"' && *s != '\'')
                return false;
            const char open2 = *s;
            ++s;
            return iconsume(s, "utf-8") && *s == open2;
        }

        static inline bool isNonAscii(char c)
        {
            return c < 0 || c > 126;
        }

        static char charCast(jchar c)
        {
            return c <= 0xff ? (char)c : '\xbf';
        }

        bool UTF8Ref::assign(jstring      str,
                             const char** dest)
        {
            // Convert the callers Java string to UTF8 and store it
            *dest = 0;
            if (!str)
                return true;
            m_ptr = m_env->GetStringUTFChars(str, 0);
            if (m_ptr)
                m_str = str;

            const size_t len = strlen(m_ptr);
            const char* end = m_ptr + len;
            if (LooksLikeUFT8XML(m_ptr, end) || std::find_if(m_ptr, end, isNonAscii) == end)
            {
                /* It is either utf-8 xml or just plain text, so just use the utf-8 buffer */
                *dest = m_ptr;
            }
            else
            {
                /* It is either latin-1 xml or just text with special chars, so we need */
                /* to convert from utf-8 to latin-1 */
                m_jptr = m_env->GetStringChars(str, 0);
                if (m_jptr && !m_str)
                    m_str = str;
                CATCH_BAD_ALLOC(m_env, m_latin1 = new char[len + 1]);
                std::transform(m_jptr, m_jptr + len + 1, m_latin1, &charCast);
                *dest = m_latin1;
            }

            // If m_ptr == 0, GetStringUTFChars will have raised an exception for us
            return m_ptr != 0;
        }

        UTF8Ref::~UTF8Ref()
        {
            delete[] m_latin1;
            // If we created a UTF8 string: release it so it can be GC'd
            if (m_ptr)
                m_env->ReleaseStringUTFChars(m_str, m_ptr);
            // If we created a jcar string: release it so it can be GC'd
            if (m_jptr)
                m_env->ReleaseStringChars(m_str, m_jptr);
        }

        MWString::~MWString()
        {
            if (c_str)
                SW_ReleaseString(c_str);
        }

        bool Callback::Set(JNIEnv*     env,
                           jobject     obj,
                           const char* method,
                           const char* signature)
        {
            Reset(env);
            if (!obj)
                return false;                                          // Shouldn't happen, checked by both SWIG and callers
            m_object = env->NewGlobalRef(obj);
            if (!m_object)
                return false;                                          // JNI has created a pending exception for us
            JClassRef objectClass(env, env->GetObjectClass(m_object)); // Note: can't fail
            m_method = env->GetMethodID(objectClass.get(), method, signature);
            if (m_method)
                return true;
            Reset(env);
            return false; // JNI has created a pending exception for us
        }

        bool Callback::CopyTo(JNIEnv*   env,
                              Callback& dest,
                              bool      resetSelfOnFailure)
        {
            if (!m_object)
            {
                dest.Reset(env);
                return true;
            }
            jobject obj = env->NewGlobalRef(m_object);
            if (!obj)
            {
                if (resetSelfOnFailure)
                    Reset(env);
                return false; // OOM, a pending exception has been raised
            }
            dest.Reset(env);
            dest.m_object = obj;
            dest.m_method = m_method;
            return true;
        }

        void Callback::Reset(JNIEnv* env)
        {
            if (m_object)
                env->DeleteGlobalRef(m_object);
            m_object = 0;
            m_method = 0;
        }

        bool Callback::ProcessResultBatch(char const* xml,
                                          JNIEnv*     env)
        {
            if (!xml)
                return false;

            bool complete = strstr(xml, "<ResultBatch>Complete</ResultBatch>") != 0;

            if (char const* count = strstr(xml, RBCIdent))
            {
                unsigned nbr = atoi(count + strlen(RBCIdent));
                GlobalMonitorLock lock(env);
                if (lock.IsOK())
                {
                    if (complete)
                        complete_ = nbr;
                    return complete_ == ProcessResultBatchCount(nbr) && complete_;
                }
            }
            return complete;
        }

        unsigned Callback::ProcessResultBatchCount(unsigned nbr)
        {
            // Callback must be locked!
            // Maintains a sequence of ranges of the 'nbr's supplied, returns the highest supplied 'nbr' when
            // a single contiguous range based at 1 has been supplied. If the 'nbr's supplied
            // do not form a contiguous single range or are not based at 1, 0 (zero) is returned

            if (rbctrack_.empty())
            {
                rbctrack_.push_back(RBCPair(nbr, nbr));
                return nbr == 1 ? nbr : 0;
            }

            for (RBCVec::reverse_iterator riter = rbctrack_.rbegin(); riter != rbctrack_.rend(); ++riter)
            {
                if (riter->second + 1 == nbr)
                {
                    // most likely case - next expected batch number in the sequence
                    riter->second = nbr;
                    return rbctrack_.size() == 1 && rbctrack_[0].first == 1 ? rbctrack_[0].second : 0;
                }
                else if (riter->first - 1 == nbr)
                {
                    riter->first = nbr;
                    // extended current pair downwards - check if it merges with pair below
                    RBCVec::reverse_iterator prev = riter + 1;
                    if (prev != rbctrack_.rend())
                    {
                        if (prev->second + 1 == nbr)
                        {
                            // merge - erase current pair, keeping pair below
                            prev->second = riter->second;
                            rbctrack_.erase(--riter.base());
                        }
                    }
                    return rbctrack_.size() == 1 && rbctrack_[0].first == 1 ? rbctrack_[0].second : 0;
                }
                else if (riter->second < nbr)
                {
                    // There's a gap in the batch numbering - add new sequence above current range
                    rbctrack_.insert(riter.base(), RBCPair(nbr, nbr));
                    return 0;
                }
            }
            // ran off the back of the ranges already receive, insert a new low range
            rbctrack_.insert(rbctrack_.begin(), RBCPair(nbr, nbr));
            return 0;
        }

        bool CheckStringOutputArray(JNIEnv* env,
                                    jarray  array)
        {
            if (!array)
            {
                ThrowJavaException(env, "java/lang/NullPointerException", "array null");
                return false;
            }
            if (!env->GetArrayLength(array))
            {
                ThrowJavaException(env, "java/lang/IndexOutOfBoundsException", "Array must contain at least 1 element");
                return false;
            }
            return true;
        }

        static jchar uniCast(char c)
        {
            return (unsigned char)c;
        }

        jstring MakeJString(JNIEnv*     env,
                            const char* str)
        {
            if (!str)
                return 0;

            const size_t len = strlen(str);
            const char* end = str + len;
            if (LooksLikeUFT8XML(str, end) || std::find_if(str, end, isNonAscii) == end)
            {
                /* The most common case: Treat ASCII strings as UTF8 */
                return env->NewStringUTF(str);
            }
            else
            {
                /* Less common case: We have accented characters, treat as latin-1 */
                jchar* stringBuff;
                CATCH_BAD_ALLOC(env, stringBuff = new jchar[len + 1]);
                std::transform(str, end, stringBuff, &uniCast);
                jstring rstr = env->NewString(stringBuff, static_cast<jsize>(len));
                delete[] stringBuff;
                return rstr;
            }
        }

        bool SetStringReturnValue(JNIEnv*      env,
                                  jobjectArray array,
                                  const char*  returnValue)
        {
            if (!returnValue)
                return true;

            jstring str = MakeJString(env, returnValue);
            if (!str)
                return false; // NewStringUTF/NewString already threw an exception

            env->SetObjectArrayElement(array, (jsize)0, str);
            env->DeleteLocalRef(str);
            return !IsExceptionPending(env);
        }

        static bool FindCallback(JNIEnv*          env,
                                 SW_LoginID       lh,
                                 ConnectionMember which,
                                 Callback&        dest)
        {
            GlobalMonitorLock lock(env);
            if (lock.IsOK())
            {
                const Sessions::iterator i = g_sessionCallbackMap.find(lh);
                if (i != g_sessionCallbackMap.end() && i->second)
                {
                    const bool resetSelfOnFailure = false; // Dont reset the existing callback if we fail
                    return (i->second->*which).CopyTo(env, dest, resetSelfOnFailure);
                }
            }
            return lock.IsOK();
        }

        bool SetCallback(JNIEnv*          env,
                         SW_LoginID       lh,
                         ConnectionMember which,
                         jobject          cbObject)
        {
            GlobalMonitorLock lock(env);
            if (!lock.IsOK())
                return false;

            Sessions::iterator i = g_sessionCallbackMap.find(lh);
            if (!cbObject)
            {
                // Setting the callback to null
                if (i != g_sessionCallbackMap.end())
                {
                    bool remove = false;
                    if (!i->second)
                        remove = true; // Previously failed while inserting: remove
                    else
                    {
                        (i->second->*which).Reset(env);
                        if (!i->second->dealCb.get() && !i->second->dealExCb.get() && !i->second->batchCb.get())
                        {
                            delete i->second;
                            remove = true; // No callbacks now registered: remove
                        }
                    }
                    if (remove)
                        g_sessionCallbackMap.erase(i);
                }
                return true;
            }

            // Make sure the session has an entry in the callbacks map
            if (i == g_sessionCallbackMap.end())
            {
                CATCH_BAD_ALLOC(env, i = g_sessionCallbackMap.insert(std::make_pair(lh, (SessionCallbacks*)0)).first);
            }
            if (!i->second)
            {
                CATCH_BAD_ALLOC(env, i->second = new SessionCallbacks);
            }

            // Determine which callback we are setting
            const char* method = "dealNotifyExCallback";
            const char* signature = "(Lcom/swapswire/sw_api/SW_DealNotifyData;)V";
            if (which == &SessionCallbacks::dealCb)
            {
                method = "dealNotifyCallback";
                signature = "(ILjava/lang/Object;Ljava/lang/String;JIIIILjava/lang/String;Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V";
            }
            else if (which == &SessionCallbacks::batchCb)
            {
                method = "batchCallback";
                signature = "(ILjava/lang/Object;Ljava/lang/String;)I";
            }

            Callback cb;
            if (!cb.Set(env, cbObject, method, signature))
                return false;
            const bool resetSelfOnFailure = true;
            return cb.CopyTo(env, i->second->*which, resetSelfOnFailure);
        }

        bool CreateQueryCallback(JNIEnv* env,
                                 jobject cbObject,
                                 void**  dest)
        {
            *dest = 0;
            if (!cbObject)
                return false; // Shouldn't happen, checked by SWIG
            std::unique_ptr<Callback> cp;
            try
            {
                cp.reset(new Callback);
            }
            catch (const std::exception&)
            {
                ThrowOutOfMemoryException(env);
                return false;
            }
            if (!cp->Set(env, cbObject, "queryCallback", "(ILjava/lang/Object;Ljava/lang/String;I)I"))
                return false;
            *dest = (void*)cp.release();
            return true;
        }

        static bool GetSessionStateCallback(JNIEnv*   env,
                                            Callback& dest)
        {
            GlobalMonitorLock lock(env);
            if (!lock.IsOK())
                return false;
            const bool resetSelfOnFailure = false; // Don't reset the SSCB if we can't copy it
            return g_sessionStateCallback.CopyTo(env, dest, resetSelfOnFailure);
        }

        bool SetSessionStateCallback(JNIEnv* env,
                                     jobject cbObject)
        {
            GlobalMonitorLock lock(env);
            if (!lock.IsOK())
                return false;
            Callback cb;
            if (!cb.Set(env, cbObject, "sessionCallback", "(ILjava/lang/Object;I)V"))
                return false;
            const bool resetSelfOnFailure = true;
            return cb.CopyTo(env, g_sessionStateCallback, resetSelfOnFailure);
        }
    }
}

using namespace mw::JNI;

extern "C"
{
void STDAPICALLTYPE sessionHandlerCallbackInterposer(SW_SessionID sh,
                                                     void*        tag,
                                                     SW_ErrCode   event)
{
    ScopedEnv env;
    if (!env.IsOK())
        return;

    Callback callback;
    if (!GetSessionStateCallback(env.get(), callback) || !callback.get())
        return;
    // Call the users session state callback
    env.get()->CallVoidMethod(callback.get(), callback.GetMethodID(), (jint)sh, (jobject)tag, (jint)event);
}

SW_ErrCode STDAPICALLTYPE queryHandlerCallbackInterposer(SW_LoginID lh,
                                                         void*      tag,
                                                         SW_XML     resXML,
                                                         SW_ErrCode retCode)
{
    Callback* callback = (Callback*)tag;

    if (!callback || !callback->get())
        return SWERR_Success;     // No callback, quit early

    ScopedEnv env;
    if (!env.IsOK())
        return SWERR_InternalError;

    std::unique_ptr<Callback> cleaner;

    if (callback->ProcessResultBatch(resXML, env.get()))
    {
        cleaner.reset(callback);         // This is the final result, delete callback on exit
    }

    // Call the users query callback
    JStringRef resXMLString(env.get(), MakeJString(env.get(), resXML ? resXML : ""));
    if (!resXMLString.get())
        return SWERR_InternalError;
    SW_ErrCode ret = env.get()->CallIntMethod(callback->get(), callback->GetMethodID(),
                                              (jint)lh, 0, resXMLString.get(), (jint)retCode);
    return IsExceptionPending(env.get()) ? SWERR_InternalError : ret;
}

void STDAPICALLTYPE dealHandlerCallbackInterposer(SW_LoginID            lh,
                                                  void*                 tag,
                                                  SW_BrokerDealID       brokerDealID,
                                                  SW_DealID             dealID,
                                                  SW_DealMajorVersion   majorVersion,
                                                  SW_DealMinorVersion   minorVersion,
                                                  SW_DealPrivateVersion privateVersion,
                                                  SW_DealSide           side,
                                                  SW_DealVersionHandle  prevDealVersionHandle,
                                                  SW_DealVersionHandle  dealVersionHandle,
                                                  enum SW_DealState     newState,
                                                  const char*           newStateStr,
                                                  const char*           contractStateStr,
                                                  const char*           productType)
{
    (void)tag;
    ScopedEnv env;
    if (!env.IsOK())
        return;

    Callback callback;
    if (!FindCallback(env.get(), lh, &SessionCallbacks::dealCb, callback))
        return;
    if (!callback.get())
        return;     // Nothing to call

    // Call the users notification callback
    JStringRef jbrokerDealID(env.get(), MakeJString(env.get(), brokerDealID));
    if (!jbrokerDealID.get())
        return;
    JStringRef jprevDealVersionHandle(env.get(), env.get()->NewStringUTF(prevDealVersionHandle));
    if (!jprevDealVersionHandle.get())
        return;
    JStringRef jdealVersionHandle(env.get(), env.get()->NewStringUTF(dealVersionHandle));
    if (!jdealVersionHandle.get())
        return;
    JStringRef jnewStateStr(env.get(), MakeJString(env.get(), newStateStr));
    if (!jnewStateStr.get())
        return;
    JStringRef jcontractStateStr(env.get(), env.get()->NewStringUTF(contractStateStr));
    if (!jcontractStateStr.get())
        return;
    JStringRef jproductType(env.get(), env.get()->NewStringUTF(productType));
    if (!jproductType.get())
        return;

    env.get()->CallVoidMethod(callback.get(), callback.GetMethodID(),
                              (jint)lh, 0, jbrokerDealID.get(),
                              (jlong)dealID, (jint)majorVersion, (jint)minorVersion,
                              (jint)privateVersion, (jint)side,
                              jprevDealVersionHandle.get(), jdealVersionHandle.get(), (jint)newState,
                              jnewStateStr.get(), jcontractStateStr.get(), jproductType.get());
}

void STDAPICALLTYPE dealHandlerExCallbackInterposer(const SW_DealNotifyData* data)
{
    ScopedEnv env;
    if (!env.IsOK())
        return;

    Callback callback;
    if (!FindCallback(env.get(), data->lh, &SessionCallbacks::dealExCb, callback))
        return;
    if (!callback.get())
        return;     // Nothing to call

    JClassRef classSW_DealNotifyData(env.get(), env.get()->FindClass("com/swapswire/sw_api/SW_DealNotifyData"));
    if (!classSW_DealNotifyData.get())
        return;

    // Call the users notification callback
    jmethodID method = env.get()->GetMethodID(classSW_DealNotifyData.get(), "<init>", "(JZ)V");
    if (!method)
        return;
    JObjectRef jdata(env.get(), env.get()->NewObject(classSW_DealNotifyData.get(), method, data, JNI_FALSE));
    if (!jdata.get())
        return;
    env.get()->CallVoidMethod(callback.get(), callback.GetMethodID(), jdata.get());
}

SW_ErrCode STDAPICALLTYPE batchHandlerCallbackInterposer(SW_LoginID  lh,
                                                         void*       tag,
                                                         const char* resultXML)
{
    (void)tag;
    ScopedEnv env;
    if (!env.IsOK())
        return SWERR_InternalError;

    Callback callback;
    if (!FindCallback(env.get(), lh, &SessionCallbacks::batchCb, callback))
        return SWERR_InternalError;
    if (!callback.get())
        return SWERR_Success;     // Nothing to call

    // Call the users batch callback
    JStringRef resXMLString(env.get(), MakeJString(env.get(), resultXML));
    if (!resXMLString.get())
        return SWERR_InternalError;
    SW_ErrCode ret = env.get()->CallIntMethod(callback.get(), callback.GetMethodID(), (jint)lh, 0, resXMLString.get());
    return IsExceptionPending(env.get()) ? SWERR_InternalError : ret;
}
} // extern "C"
