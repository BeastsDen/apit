package com.swapswire.dealsinkexample;

public interface ConnectionStateCallback {
    public void sessionCallback( int sessionHandle, Object tag, int event );
}

