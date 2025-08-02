package com.swapswire.dealerexample;

public class PickupCmd extends DealerCmd {

    public PickupCmd() {
        super("Pickup", "oldDealVersionHandle privateDataXML");
    }

    public static String run(Session session, String oldDealVersionHandle, String privateDataXML) throws ErrorCode {
        System.out.println("Pickup - " + oldDealVersionHandle);
        String[] newDealVersionHandle = {new String()};
        DealerAPIWrapper.pickup(session.getLoginHandle(), oldDealVersionHandle, privateDataXML, newDealVersionHandle);
        System.out.println("OK");
        System.out.println("New deal version handle - " + newDealVersionHandle[0]);
        return newDealVersionHandle[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 2);
        String oldDealVersionHandle = argv[0];
        String privateDataXML = argv[1];
        run(session, oldDealVersionHandle, privateDataXML);
    }
}
