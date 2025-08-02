package com.swapswire.dealerexample;

public class GetLegalEntityListCmd extends DealerCmd {

    public GetLegalEntityListCmd() {
        super("GetLegalEntityList", "legalEntityListQueryXML");
    }

    public static String run(Session session, String legalEntityListQueryXML) throws ErrorCode {
        System.out.println("GetLegalEntityList");
        String[] resultXML = {new String()};
        DealerAPIWrapper.getLegalEntityList(session.getLoginHandle(), legalEntityListQueryXML, resultXML);
        System.out.println("OK");
        System.out.println("Legal Entity List - " + resultXML[0]);
        return resultXML[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 1);
        String legalEntityListQueryXML = argv[0];
        run(session, legalEntityListQueryXML);
    }
}
