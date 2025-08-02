package com.swapswire.dealerexample;

public class GetAddressListCmd extends DealerCmd {

    public GetAddressListCmd() {
        super("GetAddressList", "addressListQueryXML");
    }

    public static void run(Session session, String addressListQueryXML) throws ErrorCode {
        System.out.println("GetAddressList");
        String[] resultXML = {new String()};
        DealerAPIWrapper.getAddressList(session.getLoginHandle(), addressListQueryXML, resultXML);
        System.out.println("OK");
        System.out.println("Address List - " + resultXML[0]);
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 1);
        String addressListQueryXML = argv[0];
        run(session, addressListQueryXML);
    }
}
