package com.swapswire.dealerexample;

public class GetMessageTextFromCSVCmd extends DealerCmd {

    public GetMessageTextFromCSVCmd() {
        super("GetMessageTextFromCSV", "templateFamily headerRow dataRow");
    }

    public static String run(Session session, String templateFamily, String headerRow, String dataRow) throws ErrorCode {
        System.out.println("GetMessageTextFromCSVCmd - ");
        String[] outputPrivateDataXML = {new String()};
        DealerAPIWrapper.getMessageTextFromCSV(session.getLoginHandle(), templateFamily, headerRow, dataRow, outputPrivateDataXML);
        System.out.println("OK");
        System.out.println("Message Text - " + outputPrivateDataXML[0]);
        return outputPrivateDataXML[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 3);
        String templateFamily = argv[0];
        String headerRow = argv[1];
        String dataRow = argv[2];
        run(session, templateFamily, headerRow, dataRow);
    }
}
