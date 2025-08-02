package com.swapswire.dealerexample;

public class GetBookListCmd extends DealerCmd {

    public GetBookListCmd() {
        super("GetBookList", "");
    }

    public static void run(Session session) throws ErrorCode {
        System.out.println("GetBookList");
        String[] resultXML = {new String()};
        DealerAPIWrapper.getBookList(session.getLoginHandle(), resultXML);
        System.out.println("OK");
        System.out.println("Book List - " + resultXML[0]);
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        run(session);
    }
}
