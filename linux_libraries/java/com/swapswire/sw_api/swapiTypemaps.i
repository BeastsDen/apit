//
// place all your language specific typemaps into this file

%apply int *OUTPUT {SW_LoginID*}
%apply long long *OUTPUT {SW_DealID*}
%apply int *OUTPUT {SW_SessionID*}
%apply int *OUTPUT {SW_DealSide*}
%apply int *OUTPUT {SW_DealMajorVersion*}
%apply int *OUTPUT {SW_DealPrivateVersion*}
%apply int *OUTPUT { enum SW_DealerDealState* };
%apply int* OUTPUT { enum SW_DealState* };

// use our scoped wrapper to free input strings if an error occurs
%typemap(in) char *
%{
    UTF8Ref cleanup_$1(jenv);
    if (!cleanup_$1 .assign($input, & $1)) return $null;
%}
%typemap(freearg) char * ""

// typemaps for handling result buffers (char **)
%typemap(jtype) const char ** "String[]"
%typemap(jstype) const char** "String[]"
%typemap(javain) const char** "$javainput"
%typemap(jni) const char ** "jobjectArray"
%typemap(in) const char ** (MWString resultWrapper)
%{
    if (!CheckStringOutputArray(jenv, $input))
        return $null;
    $1 = resultWrapper;
%}

%typemap(argout) const char**
%{
    if (!SetStringReturnValue(jenv, $input, resultWrapper$argnum.c_str))
        return $null;
%}

// typemaps for handling result buffers (SW_XML*)
%typemap(jtype) SW_XML* "String[]"
%typemap(jstype) SW_XML* "String[]"
%typemap(javain) SW_XML* "$javainput"
%typemap(jni) SW_XML* "jobjectArray"
%typemap(in) SW_XML *queryResultXML_out (MWString resultWrapper)
%{
    if (jarg4 != $null)
    {
        $1 = $null;
    }
    else if (!CheckStringOutputArray(jenv, $input))
    {
        return $null;
    }
    else
    {
        $1 = resultWrapper;
    }
%}

%typemap(argout) SW_XML *queryResultXML_out (jstring returnedStatusString, jthrowable exc)
%{
    if (!jarg4 && result == SWERR_Success &&
        !SetStringReturnValue(jenv, $input, resultWrapper$argnum.c_str))
        return $null;
%}

%typemap(jtype) void *clientData "long"
%nodefaultctor SW_DealNotifyData;
%nodefaultdtor SW_DealNotifyData;

//
// typemaps for handling tag objects that can but shouldn't be used as the callback agent in Java
// this code is called on connect
%typemap(jtype) void *tag "Object"
%typemap(jstype) void *tag "Object"
%typemap(javain) void *tag "$javainput"
%typemap(jni) void *tag "jobject"
%typemap(in) void *tag
{
    // For and old bug and compatibility with clients code we must
    // continue to accept the sessionCallback via the tag passed on
    // connect If $null, we won't reset the C callback to null to allow
    // $null tags The tag/userdata is still going to be passed back to
    // the user as callbacks arrive.
    if ($input != $null)
    {
        if (!SetSessionStateCallback(jenv, $input))
            return $null;
        SW_RegisterSessionStateCallback(sessionHandlerCallbackInterposer);
    }
}
%typemap(in) (void *tag, SW_DealNotifyCallbackPtr cfunc )
{
    if (!SetCallback(jenv, jarg1, &SessionCallbacks::dealCb, $input))
        return $null;
    if ($input != $null)
        $2 = dealHandlerCallbackInterposer;
}

%typemap(in) (void *tag, SW_DealNotifyExCallbackPtr cfunc )
{
    if (!SetCallback(jenv, jarg1, &SessionCallbacks::dealExCb, $input))
        return $null;
    if ($input != $null)
        $2 = dealHandlerExCallbackInterposer;
}

%typemap(in) (void *tag, SW_BatchCallbackPtr cb )
{
    if (!SetCallback(jenv, jarg1, &SessionCallbacks::batchCb, $input))
        return $null;
    if ($input != $null)
        $2 = batchHandlerCallbackInterposer;
}

%typemap(in) (void *tag, PDSQUERYHANDLER cb)
{
    if ($input == $null)
    {
        $2 = $null;
        $1 = $null;
    }
    else
    {
        if (!CreateQueryCallback(jenv, $input, &$1))
            return $null;
        $2 = queryHandlerCallbackInterposer;
    }
}

%typemap(jtype)  SW_SessionStateCallbackPtr "Object"
%typemap(jstype) SW_SessionStateCallbackPtr "Object"
%typemap(javain) SW_SessionStateCallbackPtr "$javainput"
%typemap(jni)    SW_SessionStateCallbackPtr "jobject"
%typemap(in) SW_SessionStateCallbackPtr cfunc
{
    if (!SetSessionStateCallback(jenv, $input))
        return $null;
    $1 = sessionHandlerCallbackInterposer;
}
