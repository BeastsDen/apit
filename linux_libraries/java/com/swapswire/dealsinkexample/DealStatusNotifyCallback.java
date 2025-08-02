package com.swapswire.dealsinkexample;

public interface DealStatusNotifyCallback {
    public void dealNotifyCallback( int aLoginHandle, 
                                    Object aTag, 
                                    String aBrokerDealID, 
                                    long aDealID, 
                                    int aMajorVersion, 
                                    int aMinorVersion,
                                    int aPrivateVersion,
                                    int aSide,
                                    String aPrevDealVersionHandle, 
                                    String aDealVersionHandle,
                                    int aNewState,
                                    String aNewStateStr,
                                    String aContractStateStr,
                                    String aProductType);
}
