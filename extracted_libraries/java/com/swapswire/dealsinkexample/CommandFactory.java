package com.swapswire.dealsinkexample;

import java.util.HashMap;

public class CommandFactory
{
    public static void dumpCommands() {
        System.out.println( "Commands" );
        System.out.println( "N n\t  - New password" );
        System.out.println( "I \t  - Infinite, just sits there listening for deal notifications" );
        System.out.println( "T d \t  - Waits for a period of time listening for deal notifications" );
        System.out.println( "C x \t  - Query Deal using callback" );
        System.out.println( "Q x \t  - Query Deal" );
        System.out.println( "H i v p s - Get the Deal Version Handle for a Deal" );
        System.out.println( "M i v \t  - Get My Side id for a Deal" );
        System.out.println( "G h m \t  - Get Deal XML" );
        System.out.println( "V x \t  - Validate XML" );
        System.out.println( "S h \t  - Get Deal Status" );
        System.out.println( "U h x \t  - Update Deal" );
        System.out.println( "Params" );
        System.out.println( "n - new password" );
        System.out.println( "d - Duration in seconds" );
        System.out.println( "t - The state to search for" );
        System.out.println( "m - XML version no e.g. 2.0 or 2.1" );
        System.out.println( "i - The pretty id of the trade" );
        System.out.println( "h - The deal version handle of the trade" );
        System.out.println( "v - The contract version" );
        System.out.println( "u - The unique version of the trade instance" );
        System.out.println( "p - The private version" );
        System.out.println( "s - The Side of the deal" );
        System.out.println( "x - filename of file containing XML" );
    }

    public static DealSinkCmd getCommand( String aCmd ) {
        System.out.println( "Getting Command - " + aCmd );
        return commands.get( aCmd );
    }

    private static HashMap<String, DealSinkCmd> commands = new HashMap<String, DealSinkCmd>();

    static {
        commands.put( "N",  new NewPasswordCmd() );
        commands.put( "I",  new InfiniteLoopCmd() );
        commands.put( "T",  new WaitLoopCmd() );
        commands.put( "C",  new QueryDealCBCmd() );
        commands.put( "Q",  new QueryDealCmd() );
        commands.put( "H",  new GetDVHCmd() );
        commands.put( "M",  new GetMySideCmd() );
        commands.put( "G",  new GetDealXMLCmd() );
        commands.put( "V",  new ValidateXMLCmd() );
        commands.put( "S",  new GetDealStatusCmd() );
        commands.put( "U",  new UpdateDealCmd() );
    }
}
