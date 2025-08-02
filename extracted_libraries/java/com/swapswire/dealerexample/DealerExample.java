package com.swapswire.dealerexample;

import java.util. *;

public class DealerExample
{
    static
    {
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
        DealerAPIWrapper.getLibraryVersionEx(libraryVersion);
        System.out.println("SW_API_DLL Version = " + libraryVersion[0]);

        try
        {
            DealerAPIWrapper.initialise("dealer_java_example");
        }
        catch (ErrorCode ec)
        {
            // Ignore initialisation errors, the ini file is optional.
        }
        System.out.println("Loaded INI file settings");

        // Command line must have at least the Host:Port, Username, Password & Command
        if (argv.length < 4)
        {
            System.out.println("DEALER API TEST APP");
            System.out.println("Host:Port Username Password Command Params");
            CommandFactory.dumpCommands();
            System.exit(0);
        }

        // Create a new client connection
        Session session = new Session(argv[0], argv[1], argv[2], Session.TESTTIMEOUT);

        try
        {
            session.connect();
        }
        catch (ErrorCode ec)
        {
            ec.dump();
            session.disconnect();
            System.exit(1);
        }

        // Get the command
        DealerCmd cmd = CommandFactory.getCommand(argv[3]);
        // activate the comand
        if (cmd != null)
        {
            try
            {
                cmd.processArg(argv, session);
            }
            catch (ErrorCode ec)
            {
                System.err.println(cmd.getCommandName() + " failed - " + ec);
            }
        }
        else
        {
            System.err.println("Unknown command " + argv[3]);
        }
        System.out.println("EXITING");
    }
}
