package com.swapswire.dealerexample;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.StringTokenizer;
import com.swapswire.sw_api.SWAPILinkModule;

public abstract class DealerCmd {

    private String name;
    private String[] args;
    private String desc = null;

    public DealerCmd(String name, String args) 
    {
        this.name = name;
        this.args = args == null || args.equals("") ? new String[0] : args.split("\\s+");
    }

    public DealerCmd(String name, String args, String desc) {
        this(name, args);
        this.desc = desc;
    }

    public final String getCommandName() {
        return name;
    }

    public final int getArgumentCount() {
        return args.length;
    }

    public final void dumpHelp() 
    {
    	String argSpace = new String("                             ");
    	String argGap;
    	
        System.out.print(name);
        
        int nameLen = name.length();
        if( nameLen < argSpace.length())
        {
        	argGap = argSpace.substring(0, argSpace.length() - nameLen);
        	System.out.print( argGap );
        }
        
        for (String arg : args) 
        {
            System.out.print(" ");
            System.out.print(arg);
        }

        if (desc != null) 
        {
            System.out.println("( " + desc + " )" );
        }
        else
        {
        	System.out.println();
        	
        }
        
    }

    public abstract void process(String[] argv, Session session) throws ErrorCode;

    public final void processArg(String[] argv, Session session) throws ErrorCode {
        final int n = getArgumentCount();

        if (argv.length < 4 + n) {
            throw new ErrorCode(SWAPILinkModule.SWERR_BadParameter);
        }

        String[] args = new String[n];
        for (int i = 0; i < n; ++i) {
            args[i] = argv[i + 4];
        }

        process(args, session);
    }

    public final void processTok(StringTokenizer st, Session session) throws ErrorCode {
        final int n = getArgumentCount();

        if (st.countTokens() < n) {
            throw new ErrorCode(SWAPILinkModule.SWERR_BadParameter);
        }

        String[] args = new String[n];
        for (int i = 0; i < n; ++i) 
        {
            args[i] = st.nextToken();
        }

        process(args, session);
    }
    
    public final String getStringArg( String inArg )
    {
    	String result = null;
    	
    	if( inArg.charAt(0)=='@' )    		
    	{
    		String filename = inArg.substring(1); 		
    		result = FileHandler.load(filename);
    	}
    	else
    	{
    		result = inArg;
    		    
    	}
    	
    	return result;    	
    	    
    }
}
