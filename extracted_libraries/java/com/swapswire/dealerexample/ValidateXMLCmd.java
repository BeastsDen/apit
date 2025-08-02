package com.swapswire.dealerexample;

public class ValidateXMLCmd extends DealerCmd {

    public ValidateXMLCmd() {
        super("ValidateXML", "XML");
    }

    public static void run(Session session, String XML) throws ErrorCode {
        System.out.println("ValidateXMLCmd - ");
        String[] errorString = {new String()};
        try {
            DealerAPIWrapper.validateXML(session.getLoginHandle(), XML, errorString);
        } catch (ErrorCode ec) {
            System.out.println("Validation Failed - Error String: " + errorString);
            throw ec;
        }
        System.out.println("OK");
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 1);
        String XML = argv[0];
        run(session, XML);
    }
}
