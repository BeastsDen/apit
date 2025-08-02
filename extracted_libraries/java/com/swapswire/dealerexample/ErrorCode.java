package com.swapswire.dealerexample;

import com.swapswire.sw_api.SWAPILinkModule;

// helper class for the error code
public class ErrorCode extends java.lang.Throwable {

    public ErrorCode( int errCode ) {
        this.errorCode   = errCode;
        if ( errCode < SWAPILinkModule.SWERR_Success )
        {
            this.errorString = DealerAPIWrapper.errorStr( errorCode ) + 
                   ": " + DealerAPIWrapper.lastErrorSpecifics();
        }
        else
        {
            this.errorString = "";
        }
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

    public void dump() {
        System.out.println( toString() );
    }
    
    public final int    errorCode;
    public final String errorString;
}
