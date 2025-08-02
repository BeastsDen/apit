package com.swapswire.dealsinkexample;

public class UpdateDealCmd implements DealSinkCmd {

    public ErrorCode process( String[] argv, Session aSession ) {
        String dealVersionHandle  = argv[4];
        String modXML  = FileHandler.load(argv[5]);
        ErrorCode ret = DealSinkWrapper.updateDeal( aSession.getLoginHandle(), dealVersionHandle, modXML );
        if ( !ret.isSuccess() ) {
            System.out.println( "Update Failed" );
            ret.dump();
        }
        else {
            System.out.println( "Updated OK" );
        }

        return ret;
    }
}

