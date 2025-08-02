package com.swapswire.dealerexample;

public class RejectDKCmd extends DealerCmd {

    public RejectDKCmd() {
        super("RejectDK", "oldDealVersionHandle messageText");
    }

    public static String run(Session session, String oldDealVersionHandle, String messageText) throws ErrorCode {
        System.out.println("RejectDK - " + oldDealVersionHandle);
        String[] newDealVersionHandle = {new String()};
        DealerAPIWrapper.rejectDK(session.getLoginHandle(), oldDealVersionHandle, messageText, newDealVersionHandle);
        System.out.println("OK");
        System.out.println("New deal version handle - " + newDealVersionHandle[0]);
        return newDealVersionHandle[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 2);
        String oldDealVersionHandle = argv[0];
        String messageText = argv[1];
        run(session, oldDealVersionHandle, messageText);
    }
}
