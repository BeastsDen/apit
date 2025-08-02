package com.swapswire.dealsinkexample;

import java.io.*;
import com.swapswire.sw_api.SWAPILinkModule;

public class QueryDealCmd implements DealSinkCmd {

    public ErrorCode process( String[] argv, Session aSession ) {
        String   queryXML   = FileHandler.load( argv[4] );
        String[] resultXML  = { new String() };
        System.out.println( "QueryDeals - " + queryXML );
        ErrorCode ret = DealSinkWrapper.queryDeals( aSession.getLoginHandle(), queryXML, resultXML, null );
        if ( !ret.isSuccess() ) {
            System.out.println( "Query Failed" );
            ret.dump();
        }
        else if ( resultXML[0].length() > 0 ) {
            System.out.println( resultXML[0] );
        }
        else {
            System.out.println( "NONE" );
        }        
        return ret;
    }
}
