package com.swapswire.dealerexample;

public class MatchPushCmd extends DealerCmd
{
    public MatchPushCmd()
    {
        super("MatchPush", "cptyDealVersionHandle");
    }

    public static void run(Session session,
                           long    dealID,
                           String  cptyDealVersionHandle) throws ErrorCode
    {
        System.out.println("MatchPushCmd - ");
        String newDealVersionHandle = new String();
        DealerAPIWrapper.matchPush(session.getLoginHandle(), cptyDealVersionHandle, newDealVersionHandle);
        System.out.println("OK");
        System.out.println("Handle - " + newDealVersionHandle);
    }

    public void process(String[] argv,
                        Session  session) throws ErrorCode
    {
        assert(argv.length >= 1);
        String cptyDealVersionHandle(argv[0]);
        run(session, cptyDealVersionHandleD);
    }
}
