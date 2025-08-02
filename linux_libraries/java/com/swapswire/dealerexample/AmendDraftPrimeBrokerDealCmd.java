package com.swapswire.dealerexample;

public class AmendDraftPrimeBrokerDealCmd extends DealerCmd {

    public AmendDraftPrimeBrokerDealCmd() {
        super("AmendDraftPrimeBrokerDeal", "oldDealVersionHandle SWDML privateDataXML recipientXML messageText");
    }

    public static String run(Session session, String oldDealVersionHandle, String swdml, String privateDataXML, String recipientXML, String messageText) throws ErrorCode {
        System.out.println("Amending draft prime broker deal - " + oldDealVersionHandle);
        String[] newDealVersionHandle = {new String()};
        DealerAPIWrapper.amendDraftPrimeBrokerDeal(session.getLoginHandle(), oldDealVersionHandle, swdml, privateDataXML, recipientXML, messageText, newDealVersionHandle);
        System.out.println("Amended draft prime broker deal OK");
        System.out.println("New deal version handle - " + newDealVersionHandle[0]);
        return newDealVersionHandle[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 5);
        String oldDealVersionHandle = argv[0];
        String SWDML = argv[1];
        String privateDataXML = argv[2];
        String recipientXML = argv[3];
        String messageText = argv[4];
        run(session, oldDealVersionHandle, SWDML, privateDataXML, recipientXML, messageText);
    }
}
