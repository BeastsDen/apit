package com.swapswire.dealerexample;

public class GetDealInfoCmd extends DealerCmd {

    public GetDealInfoCmd() {
        super("GetDealInfo", "DealVersionHandle");
    }

    public static void run(Session session, String dealVersionHandle) throws ErrorCode {
        System.out.println("GetDealInfoCmd - ");
        String[] dealInfoXML = {new String()};
        DealerAPIWrapper.getDealInfo(session.getLoginHandle(), dealVersionHandle, dealInfoXML);
        System.out.println("OK");
        System.out.println("Info - " + dealInfoXML[0]);
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 1);
        String dealVersionHandle = argv[0];
        run(session, dealVersionHandle);
    }
}
