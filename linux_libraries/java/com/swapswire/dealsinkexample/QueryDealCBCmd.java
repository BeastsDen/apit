package com.swapswire.dealsinkexample;

public class QueryDealCBCmd implements DealSinkCmd {

    public static QueryCallback callback = new QueryCallback() {
            public int queryCallback( int aLoginHandle, Object aTag, String aResXML, int aRetCode ) {
                System.out.println( "*** QueryCallback ***" );
                System.out.println( "Login Handle = " + aLoginHandle );
                System.out.println( "Return Code = " + aRetCode );
                System.out.println( "Result XML = " + aResXML );
                return 0;
            }
        };

    public ErrorCode process( String[] argv, Session aSession ) {
        String   queryXML  = FileHandler.load( argv[4] );
        String[] resultXML = { new String() };
        System.out.println( "Query Deals CB - " + queryXML );
        ErrorCode ret = DealSinkWrapper.queryDeals( aSession.getLoginHandle(), queryXML, resultXML, callback );
        if ( ret.isSuccess() ) {
            // Poll for a bit to allow for callback
            String[] params = new String[5];
            params[4] = "120";
            WaitLoopCmd wlCmd = new WaitLoopCmd();
            wlCmd.process( params, aSession );
        }
        else {
            System.out.println( "Query Failed" );
            ret.dump();
        }
        return ret;
    }
}
