package com.swapswire.dealerexample;

public class PullCmd extends DealerCmd {

    public PullCmd() {
        super("Pull", "oldDealVersionHandle");
    }

    public static void run(Session session, String oldDealVersionHandle) throws ErrorCode {
        System.out.println("PullCmd - " + oldDealVersionHandle);
        String[] newDealVersionHandle = {new String()};
        DealerAPIWrapper.pull(session.getLoginHandle(), oldDealVersionHandle, newDealVersionHandle);
        System.out.println("OK");
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 1);
        String oldDealVersionHandle = argv[0];
        run(session, oldDealVersionHandle);
    }
}
