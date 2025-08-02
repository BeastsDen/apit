package com.swapswire.dealsinkexample;

import java.io.*;

public class GetDealXMLCmd implements DealSinkCmd {

    public ErrorCode process( String[] argv, Session aSession ) {
        String dealVersionHandle  = argv[4];
        String xmlVer = argv[5];
        
        System.out.println( "Get Deal XML for - " + dealVersionHandle );
        String[] resultXML = { new String() };
        ErrorCode ret = DealSinkWrapper.getDealXML( aSession.getLoginHandle(), dealVersionHandle, xmlVer, resultXML );
        if ( ret.isSuccess() ) {
            System.out.println( resultXML[0] );
        }
        else {
            System.out.println( "GetDealXML Failed" );
            ret.dump();
        }

        return ret;
    }
}

