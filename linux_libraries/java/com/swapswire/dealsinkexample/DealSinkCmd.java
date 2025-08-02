package com.swapswire.dealsinkexample;

public interface DealSinkCmd {
    public ErrorCode process( String[] argv, Session aSession );
}

