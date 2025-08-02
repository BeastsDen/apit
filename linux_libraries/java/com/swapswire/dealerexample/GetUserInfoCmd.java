package com.swapswire.dealerexample;

public class GetUserInfoCmd extends DealerCmd {

    public GetUserInfoCmd() {
        super("GetUserInfo", "");
    }

    public static String run(Session session) throws ErrorCode {
        System.out.println("GetUserInfo");
        String[] resultXML = {new String()};
        DealerAPIWrapper.getUserInfo(session.getLoginHandle(), resultXML);
        System.out.println("OK");
        System.out.println("User Info - " + resultXML[0]);
        return resultXML[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        run(session);
    }
}
