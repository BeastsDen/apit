package com.swapswire.dealerexample;

public class GetDealSWDMLCmd extends DealerCmd {

    public GetDealSWDMLCmd() {
        super("GetDealSWDML", "swdmlVersion dealVersionHandle");
    }

    public static String run(Session session, String swdmlVersion, String dealVersionHandle) throws ErrorCode {
        System.out.println("GetDealSWDMLCmd - ");
        String[] outputSWDML = {new String()};
        DealerAPIWrapper.getDealSWDML(session.getLoginHandle(), swdmlVersion, dealVersionHandle, outputSWDML);
        System.out.println("OK");
        System.out.println("SWDML - " + outputSWDML[0]);
        return outputSWDML[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 2);
        String swdmlVersion = argv[0];
        String dealVersionHandle = argv[1];
        run(session, swdmlVersion, dealVersionHandle);
    }
}
