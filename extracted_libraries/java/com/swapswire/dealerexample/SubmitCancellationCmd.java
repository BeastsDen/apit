package com.swapswire.dealerexample;

public class SubmitCancellationCmd extends DealerCmd {

    public SubmitCancellationCmd() {
        super("SubmitCancellation", "oldDealVersionHandle cancellationFeeXML privateDataXML recipientXML messageText");
    }

    public static String run(Session session, String oldDealVersionHandle, String cancellationFeeXML, String privateDataXML, String recipientXML, String messageText) throws ErrorCode {
        System.out.println("Submitting cancellation - " + oldDealVersionHandle);
        String[] newDealVersionHandle = {new String()};
        DealerAPIWrapper.submitCancellationEx(session.getLoginHandle(), oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText, 0, newDealVersionHandle);
        System.out.println("Cancellation OK");
        System.out.println("New deal version handle - " + newDealVersionHandle[0]);
        return newDealVersionHandle[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 5);
        String oldDealVersionHandle = argv[0];
        String cancellationFeeXML = argv[1];
        String privateDataXML = argv[2];
        String recipientXML = argv[3];
        String messageText = argv[4];
        run(session, oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText);
    }
}
