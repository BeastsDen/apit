package com.swapswire.dealerexample;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import com.swapswire.sw_api.SWAPILinkModule;

public class QuitCmd extends DealerCmd 
{

    public QuitCmd() 
    {
        super("Quit", "", "Exit");
    }

    public static void run(Session session) throws ErrorCode 
    {
    	System.exit(0);
    }

    public void process(String[] argv, Session session) throws ErrorCode 
    {
        run(session);
    }
}
