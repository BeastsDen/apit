package com.swapswire.dealerexample;

public class GetLongSWDMLFromCSVCmd extends DealerCmd {

    public GetLongSWDMLFromCSVCmd() {
        super("GetLongSWDMLFromCSV", "templateFamily headerRow dataRow swdmlVersion");
    }

    public static String run(Session session, String templateFamily, String headerRow, String dataRow, String swdmlVersion) throws ErrorCode {
        System.out.println("GetLongSWDMLFromCSVCmd - ");
        String[] outputLongFormSWDML = {new String()};
        DealerAPIWrapper.getLongSWDMLFromCSV(session.getLoginHandle(), templateFamily, headerRow, dataRow, swdmlVersion, outputLongFormSWDML);
        System.out.println("OK");
        System.out.println("Long Form SWDWML - " + outputLongFormSWDML[0]);
        return outputLongFormSWDML[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 4);
        String templateFamily = argv[0];
        String headerRow = argv[1];
        String dataRow = argv[2];
        String swdmlVersion = argv[3];
        run(session, templateFamily, headerRow, dataRow, swdmlVersion);
    }
}
