package com.swapswire.dealerexample;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import com.swapswire.sw_api.SWAPILinkModule;

public class HelpCmd extends DealerCmd 
{

    public HelpCmd() 
    {
        super("Help", "", "Prints out these commands");
    }

    public static void run(Session session) throws ErrorCode 
    {
    	CommandFactory.dumpCommands();
    }

    public void process(String[] argv, Session session) throws ErrorCode 
    {
        run(session);
    }
}
