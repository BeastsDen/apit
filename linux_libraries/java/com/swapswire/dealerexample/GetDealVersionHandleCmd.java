package com.swapswire.dealerexample;

public class GetDealVersionHandleCmd extends DealerCmd {

    public GetDealVersionHandleCmd() {
        super( "GetDealVersionHandle", "dealID contractVersion privateVersion side" );
    }

	public static String run( Session session, long dealID, int contractVersion, int privateVersion, int side ) throws ErrorCode {
        System.out.println( "GetDealVersionHandleCmd - " );
		String[] dealVersionHandle = { new String() };
		DealerAPIWrapper.getDealVersionHandle( session.getLoginHandle(), dealID,
                                                     contractVersion, privateVersion,
                                                     side, dealVersionHandle );
        System.out.println( "OK" );
        System.out.println( "Handle - " + dealVersionHandle[0] );
        return dealVersionHandle[0];
    }

	public void process( String[] argv, Session session ) throws ErrorCode {
		assert( argv.length >= 4 );
		long dealID = Long.parseLong( argv[0] );
		int contractVersion = Integer.parseInt( argv[1] );
                int privateVersion = Integer.parseInt( argv[2] );
                int side = Integer.parseInt( argv[3] );
        run( session, dealID, contractVersion, privateVersion, side );
	}
}
