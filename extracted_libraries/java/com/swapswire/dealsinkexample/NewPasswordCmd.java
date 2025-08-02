package com.swapswire.dealsinkexample;

import java.io.*;

public class NewPasswordCmd implements DealSinkCmd {

    public ErrorCode process( String[] argv, Session aSession ) {
        String newPassword = argv[4];
        ErrorCode ret = DealSinkWrapper.changePassword( aSession.getSessionHandle(), aSession.getUsername(), aSession.getPassword(), newPassword );
        if ( ret.isSuccess() ) {
            System.out.println( "Successfully changed password" );
        }
        else {
            System.out.println( "Password change failed" );
            ret.dump();
        }

        return ret;
    }
}

