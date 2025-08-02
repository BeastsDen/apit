package com.swapswire.dealerexample;


public interface NotifyCallback {
	public void dealNotifyCallback( int loginHandle, Object tag, String brokerDealID,
                                    long dealID, int majorVersion, int minorVersion,
                                    int privateVersion, int side, String prevDealVersionHandle,
                                    String dealVersionHandle, int newState,
                                    String newStateStr, String contractStateStr, String productType);
}
