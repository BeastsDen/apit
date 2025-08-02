package com.swapswire.dealsinkexample;

import java.io.*;

public class InfiniteLoopCmd implements DealSinkCmd {

    public ErrorCode process( String[] argv, Session aSession ) {
        ErrorCode ret = new ErrorCode( 0 );
        do {
            ret = DealSinkWrapper.poll( 120, 60 );
            if ( !aSession.isValidClientSession() ) {
                aSession.disconnect();
                ret = aSession.connect();
            }
        } while( ret.isSuccess() || ret.isTimeout() );
        
        return ret;
    }
}
