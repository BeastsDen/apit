package com.swapswire.dealerexample;

import com.swapswire.sw_api.SW_DealState;

public class GetDealStateCmd extends DealerCmd {

    public GetDealStateCmd() {
        super("GetDealState", "dealID dealVersionHandle");
    }

    public static SW_DealState run(Session session, String dealVersionHandle) throws ErrorCode {
        SW_DealState[] dealStateOut = new SW_DealState[1];
        System.out.println("GetDealStateCmd - ");
        DealerAPIWrapper.getDealState(session.getLoginHandle(), dealVersionHandle, dealStateOut);
        System.out.println("OK");
        System.out.println("DealState - " + dealStateOut[0]);
        return dealStateOut[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 1);
        String dealVersionHandle = argv[0];
        run(session, dealVersionHandle);
    }
}
