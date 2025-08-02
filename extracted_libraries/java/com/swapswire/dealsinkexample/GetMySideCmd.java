package com.swapswire.dealsinkexample;

public class GetMySideCmd implements DealSinkCmd {

    public ErrorCode process(String[] argv, Session aSession) {
        long dealId = Long.parseLong(argv[4]);
        int cver = Integer.parseInt(argv[5]);
        
        int side[] = {0};
        ErrorCode ret = DealSinkWrapper.getMySideId(aSession.getLoginHandle(), dealId, cver, side);
        if(ret.isSuccess()) {
            System.out.println("Side id: " + side[0]);
        }
        else {
            System.out.println("Get My Side Id failed.");
            ret.dump();
        }
        
        return ret;
    }

}
