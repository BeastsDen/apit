package com.swapswire.dealerexample;

public class MatchPullCmd extends DealerCmd
{
    public MatchPullCmd()
    {
        super("MatchPull", "oldDealVersionHandle");
    }

    public static void run(Session session,
                           long    dealID,
                           String  oldDealVersionHandle) throws ErrorCode
    {
        System.out.println("MatchPullCmd - ");
        String newDealVersionHandle = new String();
        DealerAPIWrapper.matchPull(session.getLoginHandle(), oldDealVersionHandle, newDealVersionHandle);
        System.out.println("OK");
        System.out.println("Handle - " + newDealVersionHandle);
    }

    public void process(String[] argv,
                        Session  session) throws ErrorCode
    {
        assert(argv.length >= 1);
        String oldDealVersionHandle(argv[0]);
        run(session, oldDealVersionHandle);
    }
}
