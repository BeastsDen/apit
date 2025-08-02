package com.swapswire.dealerexample;

public class AffirmCmd extends DealerCmd {

    public AffirmCmd() {
        super("Affirm", "oldDealVersionHandle SWDML privateDataXML messageText");
    }

    public static String run(Session session, String oldDealVersionHandle, String swdml, String privateDataXML, String messageText) throws ErrorCode {
        System.out.println("AffirmCmd - " + oldDealVersionHandle);
        String[] newDealVersionHandle = {new String()};
        DealerAPIWrapper.affirm(session.getLoginHandle(), oldDealVersionHandle, swdml, privateDataXML, messageText, newDealVersionHandle);
        System.out.println("OK");
        System.out.println("New deal version handle - " + newDealVersionHandle[0]);
        return newDealVersionHandle[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 4);
        String oldDealVersionHandle = argv[0];
        String SWDML = argv[1];
        String privateDataXML = argv[2];
        String messageText = argv[3];
        run(session, oldDealVersionHandle, SWDML, privateDataXML, messageText);
    }
}
