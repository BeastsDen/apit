package com.swapswire.dealerexample;

public class GetAllDealVersionHandlesCmd extends DealerCmd {

    public GetAllDealVersionHandlesCmd() {
        super("GetAllDealVersionHandles", "dealID contractVersion side");
    }

    public static void run(Session session, long dealID, int contractVersion, int side) throws ErrorCode {
        System.out.println("GetAllDealVersionHandlesCmd - ");
        String[] dealVersionHandles = {new String()};
        DealerAPIWrapper.getAllDealVersionHandles(session.getLoginHandle(), dealID, contractVersion, side, dealVersionHandles);
        System.out.println("OK");
        System.out.println("Handles - " + dealVersionHandles[0]);
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 2);
        long dealID = Long.parseLong(argv[0]);
        int contractVersion = Integer.parseInt(argv[1]);
        int side = Integer.parseInt(argv[2]);
        run(session, dealID, contractVersion, side);
    }
}
