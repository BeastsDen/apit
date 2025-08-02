package com.swapswire.dealerexample;

public class GetDealSWMLCmd extends DealerCmd {

    public GetDealSWMLCmd() {
        super("GetDealSWML", "swmlVersion dealVersionHandle");
    }

    public static String run(Session session, String swmlVersion, String dealVersionHandle) throws ErrorCode {
        System.out.println("GetDealSWMLCmd - ");
        String[] outputSWML = {new String()};
        DealerAPIWrapper.getDealSWML(session.getLoginHandle(), swmlVersion, dealVersionHandle, outputSWML);
        System.out.println("OK");
        System.out.println("SWML - " + outputSWML[0]);
        return outputSWML[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 2);
        String swmlVersion = argv[0];
        String dealVersionHandle = argv[1];
        run(session, swmlVersion, dealVersionHandle);
    }
}
