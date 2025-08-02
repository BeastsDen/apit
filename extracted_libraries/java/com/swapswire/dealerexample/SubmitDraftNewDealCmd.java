package com.swapswire.dealerexample;

public class SubmitDraftNewDealCmd extends DealerCmd {

    public SubmitDraftNewDealCmd() {
        super("SubmitDraftNewDeal", "SWDML privateDataXML recipientXML messageText");
    }

    public static String run(Session session, String swdml, String privateDataXML, String recipientXML, String messageText) throws ErrorCode {
        System.out.println("Submitting new Draft deal");
        String[] newDealVersionHandle = {new String()};
        DealerAPIWrapper.submitDraftNewDeal(session.getLoginHandle(), swdml, privateDataXML, recipientXML, messageText, newDealVersionHandle);
        System.out.println("Draft Deal Submitted OK");
        System.out.println("New deal version handle - " + newDealVersionHandle[0]);
        return newDealVersionHandle[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 4);
        String SWDML = argv[0];
        String privateDataXML = argv[1];
        String recipientXML = argv[2];
        String messageText = argv[3];
        run(session, SWDML, privateDataXML, recipientXML, messageText);
    }
}
