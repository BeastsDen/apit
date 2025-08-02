package com.swapswire.dealerexample;

public class SuggestDealMatchCmd extends DealerCmd
{
    public SuggestDealMatchCmd()
    {
        super("SuggestDealMatch", "oldDealVersionHandle cptyDealVersionHandle");
    }

    public static void run(Session session,
                           long    dealID,
                           String  oldDealVersionHandle,
                           String  cptyDealVersionHandle) throws ErrorCode
    {
        System.out.println("SuggestDealMatchCmd - ");
        String newDealVersionHandle = new String();
        DealerAPIWrapper.suggestMatch(session.getLoginHandle(), oldDealVersionHandle, cptyDealVersionHandle, newDealVersionHandle);
        System.out.println("OK");
        System.out.println("Handle - " + newDealVersionHandle);
    }

    public void process(String[] argv,
                        Session  session) throws ErrorCode
    {
        assert(argv.length >= 2);
        String oldDealVersionHandle(argv[0]);
        String cptyDealVersionHandle(argv[1]);
        run(session, oldDealVersionHandle, cptyDealVersionHandleD);
    }
}
