package com.swapswire.dealsinkexample;

import com.swapswire.sw_api.SWAPILinkModule;

// helper class for the error code
public class ErrorCode {

    public ErrorCode( int aErrCode ) {
        errorCode   = aErrCode;
        if ( errorCode < SWAPILinkModule.SWERR_Success )
        {
            errorString = DealSinkWrapper.errorStr( errorCode ) + ": " + DealSinkWrapper.lastErrorSpecifics();
        }
        else
        {
            errorString = "";
        }
    }
    
    public void dump() {
        System.out.println( toString() );
    }

    @Override
    public String toString() {
        return String.valueOf(errorCode) + ": " + errorString;
    }
        
    public boolean isSuccess() {
        return errorCode >= 0;
    }

    public boolean isTimeout() {
        return errorCode == SWAPILinkModule.SWERR_Timeout;
    }

    public final int    errorCode;
    public final String errorString;
}
