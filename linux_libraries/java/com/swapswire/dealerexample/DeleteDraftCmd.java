package com.swapswire.dealerexample;

public class DeleteDraftCmd extends DealerCmd {

    public DeleteDraftCmd() {
        super("DeleteDraft", "oldDealVersionHandle");
    }

    public static void run(Session session, String oldDealVersionHandle) throws ErrorCode {
        System.out.println("DeleteDraft - " + oldDealVersionHandle);
        String[] newDealVersionHandle = {new String()};
        DealerAPIWrapper.deleteDraft(session.getLoginHandle(), oldDealVersionHandle, newDealVersionHandle);
        System.out.println("OK");
        System.out.println("New deal version handle - " + newDealVersionHandle[0]);
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 1);
        String oldDealVersionHandle = argv[0];
        run(session, oldDealVersionHandle);
    }
}
