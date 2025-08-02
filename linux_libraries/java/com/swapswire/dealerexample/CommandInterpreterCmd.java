package com.swapswire.dealerexample;

import java.util.StringTokenizer;

public class CommandInterpreterCmd extends DealerCmd {

    public CommandInterpreterCmd() {
        super( "CommandInterpreter", "commandFile", 
               "file can contain a number of other commands and parameters to be processed separated by whitespace." );
    }

	public static void run( Session session, String fileName ) throws ErrorCode {
		String	file = FileHandler.load( fileName );
		StringTokenizer st = new StringTokenizer( file );

		while ( st.hasMoreTokens() ) {
			String  command = st.nextToken();
			DealerCmd	cmd = CommandFactory.getCommand( command );
			if ( cmd != null ) {
                try {
                    cmd.processTok( st, session );
                }
                catch ( ErrorCode error ) {
                    System.err.println( command + " failed - " + error );
                }
			}
            else {
                System.err.println( "Command " + command + " not found." );
            }
		}

		System.out.println( "CommandInterpreterCmd FINISHED" );
	}

	public void process( String[] argv, Session session ) throws ErrorCode {
		assert( argv.length >= 1 );
        String cmdFilename = argv[0];
		run( session, cmdFilename );
	}
}
