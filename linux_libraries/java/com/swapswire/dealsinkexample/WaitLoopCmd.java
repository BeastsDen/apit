package com.swapswire.dealsinkexample;

import java.util.Date;

public class WaitLoopCmd implements DealSinkCmd {

    public ErrorCode process( String[] argv, Session aSession ) {
        ErrorCode ret = new ErrorCode( 0 );
    
        // Get Duration and convert to miliseconds
        int duration = Integer.parseInt(argv[4]) * 1000;

        Date startTime = new Date();
        Date currTime  = new Date();

        while ( (currTime.getTime() - startTime.getTime()) < duration && ret.isSuccess() ) {
            ret = DealSinkWrapper.poll( duration, duration );
            currTime = new Date();
        }

        return ret;
    }
}
