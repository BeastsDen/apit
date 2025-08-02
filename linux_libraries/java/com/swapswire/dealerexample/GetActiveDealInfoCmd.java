package com.swapswire.dealerexample;

public class GetActiveDealInfoCmd extends DealerCmd {

    public GetActiveDealInfoCmd() {
        super("GetActiveDealInfo", "");
    }

    public static void run(Session session) throws ErrorCode {
        System.out.println("GetActiveDealInfo");
        String[] activeDealInfo = {new String()};
        DealerAPIWrapper.getActiveDealInfo(session.getLoginHandle(), activeDealInfo);
        System.out.println("OK");
        System.out.println("Active Deal Info - " + activeDealInfo[0]);
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        run(session);
    }
}
