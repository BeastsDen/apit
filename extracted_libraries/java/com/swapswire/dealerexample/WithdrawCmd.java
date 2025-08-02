package com.swapswire.dealerexample;

public class WithdrawCmd extends DealerCmd {

    public WithdrawCmd() {
        super("Withdraw", "OldDealVersionHandle");
    }

    public static String run(Session session, String oldDealVersionHandle) throws ErrorCode {
        String[] newDealVersionHandle = {new String()};
        System.out.println("WithdrawCmd - ");
        DealerAPIWrapper.withdraw(session.getLoginHandle(), oldDealVersionHandle, newDealVersionHandle);
        System.out.println("OK");
        System.out.println("New Deal Version Handle - " + newDealVersionHandle[0]);
        return newDealVersionHandle[0];
    }
    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 1);
        String oldDvh = argv[0];
        run(session, oldDvh);
    }

}
