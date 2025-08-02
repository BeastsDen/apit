//
// This file describes the interface provided to SWIG generated code.
//
#ifndef MW_SWIG_FUNCS_H
#define MW_SWIG_FUNCS_H

#include <jni.h>
#include "sw_api.h"
#include <utility>
#include <vector>

namespace mw
{
    namespace JNI
    {
        /***
         * UTF8Ref is a class to convert Java strings into strings that the
         * API can use. It releases any locked string when control returns to Java.
         */
        class UTF8Ref
        {
        public:
            /// Ctor just holds the current JNI environment for cleaning up later.
            UTF8Ref(JNIEnv* jenv)
                : m_env(jenv),
                m_str(0),
                m_ptr(0),
                m_jptr(0),
                m_latin1(0)
            { }

            /// Take a Java string, convert it to UTF8 and store the result in dest.
            /// The string and locked characters are held for cleaning up later.
            bool assign(jstring      str,
                        const char** dest);

            bool assign(jstring str,
                        char**  dest)
            {
                return assign(str, const_cast<const char**>(dest));
            }

            /// On destruction we free any characters we locked back to the JVM.
            ~UTF8Ref();

        private:
            UTF8Ref(const UTF8Ref&);
            UTF8Ref& operator=(const UTF8Ref&);
            JNIEnv* m_env;
            jstring m_str;
            const char* m_ptr;
            const jchar* m_jptr;
            char* m_latin1;
        };

        /***
         * MWString holds strings that have been returned by the API.
         * It releases the string back to the API when control returns to Java.
         */
        struct MWString
        {
            /// Constructor sets our API string to NULL.
            MWString() : c_str(0) { }

            /// These operators pass the address of our API string to the variable
            /// that will be passed as the output parameter to the API call. When the
            /// API call is made, our c_str member will contain any returned string.
            operator char**() { return const_cast<char**>(&c_str); }
            operator const char**() { return &c_str; }

            /// On destruction we free any API string back to the API.
            ~MWString();

            const char* c_str;
        };

        /// Verify that a string output array is a) Non-Null and b) Has at least 1 element.
        bool CheckStringOutputArray(JNIEnv* env,
                                    jarray  array);

        /// Take a String from the API, convert it to a Java string and store it in the
        /// output string array given.
        bool SetStringReturnValue(JNIEnv*      env,
                                  jobjectArray array,
                                  const char*  value);

        /// Callback holds a global reference to the users Java callback object
        struct Callback
        {
            /// Ctor is for internal use only
            Callback()
                : m_object(0),
                m_method(0),
                complete_(0)
            { }

            bool Set(JNIEnv* env, jobject obj, const char* method, const char* signature);

            bool CopyTo(JNIEnv*   env,
                        Callback& dest,
                        bool      resetSelfOnFailure);

            void Reset(JNIEnv* env);

            jobject get() const { return m_object; }
            jmethodID GetMethodID() const { return m_method; }

            bool ProcessResultBatch(char const* xml, JNIEnv* env);
        private:
            unsigned ProcessResultBatchCount(unsigned nbr);

            Callback(const Callback& rhs);
            Callback& operator=(const Callback& rhs);
            jobject m_object;
            jmethodID m_method;

            typedef std::pair<unsigned, unsigned> RBCPair;
            typedef std::vector<RBCPair> RBCVec;
            RBCVec rbctrack_;
            unsigned complete_;
        };

        /// This struct holds the JVM references to each sessions callbacks
        struct SessionCallbacks
        {
            Callback dealCb;
            Callback dealExCb;
            Callback batchCb;
        };
        typedef Callback SessionCallbacks::* ConnectionMember;

        /// Set a callback for a session.
        bool SetCallback(JNIEnv*          jenv,
                         SW_LoginID       lh,
                         ConnectionMember which,
                         jobject          cbObject);

        /// Set the session state callback (there is only one of these).
        bool SetSessionStateCallback(JNIEnv* jenv,
                                     jobject cbObject);

        /// Create a query callback (these are created on demand whenever a query is executed).
        bool CreateQueryCallback(JNIEnv* env,
                                 jobject cbObj,
                                 void**  dest);
    } // namespace JNI
}     // namespace mw

// These are the signatures of the C functions the wrapper uses to call back to the users Java code.
extern "C"
{
void STDAPICALLTYPE
sessionHandlerCallbackInterposer(SW_SessionID sh, void* tag, SW_ErrCode event);

SW_ErrCode STDAPICALLTYPE
queryHandlerCallbackInterposer(SW_LoginID lh,
                               void*      tag,
                               SW_XML     resXML,
                               SW_ErrCode retCode);

void STDAPICALLTYPE
dealHandlerCallbackInterposer(SW_LoginID            lh,
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
                              const char*           productType);

void STDAPICALLTYPE
dealHandlerExCallbackInterposer(const SW_DealNotifyData* data);

SW_ErrCode STDAPICALLTYPE
batchHandlerCallbackInterposer(SW_LoginID lh, void* tag, const char* resultXML);
}

#endif // MW_SWIG_FUNCS_H
