package com.swapswire.dealerexample;

public class TransferCmd extends DealerCmd {

    public TransferCmd() {
        super("Transfer", "oldDealVersionHandle SWDML privateDataXML messageText");
    }

    public static String run(Session session, String oldDealVersionHandle, String privateDataXML, String transferRecipientXML, String messageText) throws ErrorCode {
        System.out.println("TransferCmd - " + oldDealVersionHandle);
        String[] newDealVersionHandle = {new String()};
        DealerAPIWrapper.transfer(session.getLoginHandle(), oldDealVersionHandle, privateDataXML, transferRecipientXML, messageText, newDealVersionHandle);
        System.out.println("OK");
        System.out.println("New deal version handle - " + newDealVersionHandle[0]);
        return newDealVersionHandle[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 4);
        String oldDealVersionHandle = argv[0];
        String privateDataXML = argv[1];
        String transferRecipientXML = argv[2];
        String messageText = argv[3];
        run(session, oldDealVersionHandle, privateDataXML, transferRecipientXML, messageText);
    }
}
