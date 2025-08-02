package com.swapswire.dealsinkexample;

public class GetDVHCmd implements DealSinkCmd  {

    public ErrorCode process(String[] argv, Session aSession) {
        long dealId = Long.parseLong(argv[4]);
        int cver = Integer.parseInt(argv[5]);
        int pver = Integer.parseInt(argv[6]);
        int side = Integer.parseInt(argv[7]);
        
        String dealVersionHandle[] = { new String() };
        ErrorCode ret = DealSinkWrapper.getDealVersionHandle(aSession.getLoginHandle(), dealId, cver, pver, side, dealVersionHandle);
        if(ret.isSuccess()) {
            System.out.println("Deal Version Handle is: " + dealVersionHandle[0]);
        }
        else {
            System.out.println("Get Deal Version Handle failed.");
            ret.dump();
        }
        
        return ret;
    }

}
