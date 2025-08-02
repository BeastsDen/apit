package com.swapswire.dealerexample;

public class GetSWDMLfromSWMLCmd extends DealerCmd {

    public GetSWDMLfromSWMLCmd() {
        super("GetSWDMLfromSWML", "inputSWML");
    }

    public static String run(Session session, String inputSWML) throws ErrorCode {
        System.out.println("GetSWDMLfromSWMLCmd - ");
        String[] outputSWDML = {new String()};
        DealerAPIWrapper.getSWDMLfromSWML(session.getLoginHandle(), inputSWML, outputSWDML);
        System.out.println("OK");
        System.out.println("SWDML - " + outputSWDML[0]);
        return outputSWDML[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 1);
        String inputSWML = argv[0];
        run(session, inputSWML);
    }
}
