package com.swapswire.dealerexample;

public class SendChatMessageCmd extends DealerCmd {

    public SendChatMessageCmd() {
        super("SendChatMessage", "oldDealVersionHandle messageText");
    }

    public static String run(Session session, String oldDealVersionHandle, String messageText) throws ErrorCode {
        System.out.println("SendChatMessage - " + oldDealVersionHandle);
        String[] newDealVersionHandle = {new String()};
        DealerAPIWrapper.sendChatMessage(session.getLoginHandle(), oldDealVersionHandle, messageText, newDealVersionHandle);
        System.out.println("OK");
        return newDealVersionHandle[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 2);
        String oldDealVersionHandle = argv[0];
        String messageText = argv[1];
        run(session, oldDealVersionHandle, messageText);
    }
}
