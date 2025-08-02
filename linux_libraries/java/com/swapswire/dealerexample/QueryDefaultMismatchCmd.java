package com.swapswire.dealerexample;

public class QueryDefaultMismatchCmd extends DealerCmd {

    public QueryDefaultMismatchCmd() {
        super("QueryDefaultMismatch", "dealVersionHandle");
    }

    public static String run(Session session, String dealVersionHandle) throws ErrorCode {
        System.out.println("QueryDefaultMismatch");
        String[] resultXML = {new String()};
        DealerAPIWrapper.queryDefaultMismatch(session.getLoginHandle(), dealVersionHandle, resultXML);
        System.out.println("OK");
        System.out.println("Result XML - " + resultXML[0]);
        return resultXML[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 1);
        String dealVersionHandle = argv[0];
        run(session, dealVersionHandle);
    }
}
