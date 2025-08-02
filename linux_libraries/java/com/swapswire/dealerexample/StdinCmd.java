package com.swapswire.dealerexample;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import com.swapswire.sw_api.SWAPILinkModule;

public class StdinCmd extends DealerCmd 
{

    public StdinCmd() 
    {
        super("Stdin", "", "Stay logged and enter multiple commands");
    }

    public static void run(Session session) throws ErrorCode 
    {
        ErrorCode ret = new ErrorCode(SWAPILinkModule.SWERR_Success);
        
       	String inCommand = null;
    	BufferedReader br = new BufferedReader(new InputStreamReader(System.in));         
        do 
        {

            try 
            {
            	System.out.print("-> " );
            	inCommand = br.readLine();
            	
            	String[] argv =  inCommand.split("\\s+");
            	DealerCmd cmd = CommandFactory.getCommand( argv[0] );
                if ( cmd != null ) 
                {
                	int argn = argv.length;
                	String[] args = new String[ argn-1 ];
                	for( int loop = 1; loop < argn ; loop++)
                	{
                		args[loop-1] = argv[loop];
                	}
                	                	
                    try 
                    {
                    	cmd.process(args, session);

                    }
                    catch ( ErrorCode ec ) 
                    {
                        System.err.println( cmd.getCommandName() + " failed - " + ec );
                    }
                }           	
                DealerAPIWrapper.poll(120, 60);
            } 
            catch (ErrorCode err) 
            {
                ret = err;
            } 
            catch (IOException e) 
            {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            if (!session.isValidClientSession()) 
            {
                session.deregisterCallbacks();
                session.disconnect();
                session.connect();
                /*if (session.isValidClientSession()) {
                    session.registerCallbacks();
                }*/
            }
        } while (ret.isSuccess() || ret.isTimeout());
    }

    public void process(String[] argv, Session session) throws ErrorCode 
    {
        run(session);
    }
}
