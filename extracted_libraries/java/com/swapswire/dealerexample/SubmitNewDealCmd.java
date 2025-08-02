package com.swapswire.dealerexample;

public class SubmitNewDealCmd extends DealerCmd {

    public SubmitNewDealCmd() {
        super("SubmitNewDeal", "SWDML privateDataXML recipientXML messageText");
    }

    public static String run(Session session, String swdml, String privateDataXML, String recipientXML, String messageText) throws ErrorCode {
        System.out.println("Submitting new deal");
        String[] newDealVersionHandle = {new String()};
        DealerAPIWrapper.submitNewDeal(session.getLoginHandle(), swdml, privateDataXML, recipientXML, messageText, newDealVersionHandle);
        System.out.println("Deal Submitted OK");
        System.out.println("New deal version handle - " + newDealVersionHandle[0]);
        return newDealVersionHandle[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode 
    {
        assert (argv.length >= 4);
        
        String parameter = null;
        String SWDML = getStringArg(argv[0]);
        String privateDataXML = getStringArg(argv[1]);
        String recipientXML = getStringArg(argv[2]);
        String messageText = getStringArg(argv[3]);
        run(session, SWDML, privateDataXML, recipientXML, messageText);
    }
}
