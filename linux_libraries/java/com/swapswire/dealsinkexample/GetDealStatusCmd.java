package com.swapswire.dealsinkexample;

import java.io.*;
import java.util.*;
import com.swapswire.sw_api.SW_DealState;

public class GetDealStatusCmd implements DealSinkCmd {

    public ErrorCode process(String[] argv, Session aSession) {
        String dealVersionHandle = argv[4];

        System.out.println("Get deal status for " + dealVersionHandle);
        
        SW_DealState[] status = {SW_DealState.SWDS_Err};
        ErrorCode ret = DealSinkWrapper.getDealState(aSession.getLoginHandle(), dealVersionHandle, status);
        if (ret.isSuccess()) {
            System.out.println("Deal status = " + status[0]);
        } else {
            System.out.println("Get Deal Status command failed");
            ret.dump();
        }


        return ret;
    }
}
