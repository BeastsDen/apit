package com.swapswire.dealsinkexample;

import java.util. *;
import com.swapswire.sw_api.SWAPILinkModule;

public class DealSinkExample
{
    static {
        try
        {
            System.loadLibrary("SWAPILink");
        }
        catch (UnsatisfiedLinkError e)
        {
            System.err.println("Native code library failed to load. See the chapter on Dynamic Linking Problems in the SWIG Java documentation for help.\n" + e);
            System.exit(1);
        }
    }

    public static void main(String[] argv)
    {
        String[] libraryVersion = { new String() };
        DealSinkWrapper.getLibraryVersionEx(libraryVersion);
        System.out.println("SW_API_DLL Version = " + libraryVersion[0]);
        DealSinkWrapper.initialise("dealsink_java_example"); // Ignore any error, the ini is optional
        System.out.println("Loaded INI file settings");

        // Command line must have at least the Server, Username,Password, & a Command
        if (argv.length < 4)
        {
            System.out.println("DEALSINK API TEST APP");
            System.out.println("Host:Port Username Password Command Params");

            CommandFactory.dumpCommands();

            System.exit(0);
        }

        // Create a new client connection
        Session lclSession = new Session(argv[0], argv[1], argv[2], Session.TESTTIMEOUT);
        lclSession.connect();
        try
        {
            if (!lclSession.isValidClientSession())
            {
                System.exit(3);
            }

            // Get the command
            DealSinkCmd cmd = CommandFactory.getCommand(argv[3]);

            // activate the comand
            if (cmd != null)
            {
                cmd.process(argv, lclSession);
            }
            else
            {
                System.out.println("Unknown command " + argv[3]);
            }
        }
        finally {
            lclSession.disconnect();
        }

        System.out.println("EXITING");
    }
}
