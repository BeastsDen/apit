package com.swapswire.dealsinkexample;

public class ValidateXMLCmd implements DealSinkCmd {

    public ErrorCode process( String[] argv, Session aSession ) {
        String  data = FileHandler.load( argv[4] );

        System.out.println( "Validating XML data - " + data );
        String[] result = { new String() };
        ErrorCode ret = DealSinkWrapper.validateXML( aSession.getLoginHandle(), data, result );
        if ( ret.isSuccess() ) {
            System.out.println( result[0] );
        }
        else {
            System.out.println( "Validation Command Failed" );
            ret.dump();
        }

        return ret;
    }
}
