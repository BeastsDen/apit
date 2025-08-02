package com.swapswire.dealerexample;

public class QueryDealsCmd extends DealerCmd {

    public QueryDealsCmd() {
        super("QueryDeals", "queryXML");
    }

    public static String run(Session session, String queryXML) throws ErrorCode {
        System.out.println("QueryDeals");
        String[] resultXML = {new String()};
        DealerAPIWrapper.queryDeals(session.getLoginHandle(), queryXML, resultXML);
        System.out.println("OK");
        System.out.println("Result XML - " + resultXML[0]);
        return resultXML[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 1);
        String queryXML = argv[0];
        run(session, queryXML);
    }
}
