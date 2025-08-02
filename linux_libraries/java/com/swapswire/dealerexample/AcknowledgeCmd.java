package com.swapswire.dealerexample;

public class AcknowledgeCmd extends DealerCmd {

    public AcknowledgeCmd() {
        super( "Acknowledge", "oldDealVersionHandle" );
    }

	public static String run( Session session, String oldDealVersionHandle ) throws ErrorCode {
            System.out.println( "AcknowledgeCmd - " + oldDealVersionHandle );
            String[] newDealVersionHandle = { new String() };
            DealerAPIWrapper.acknowledge( session.getLoginHandle(), oldDealVersionHandle, newDealVersionHandle );
            System.out.println( "OK" );
            System.out.println( "New deal version handle - " + newDealVersionHandle[0] );
            return newDealVersionHandle[0];
    }
		
	public void process( String[] argv, Session session ) throws ErrorCode {
		assert( argv.length >= 1 );
		String oldDealVersionHandle = argv[0];
		run( session, oldDealVersionHandle );
	}
}
