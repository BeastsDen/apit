package com.swapswire.dealsinkexample;

import java.io.*;

public class FileHandler {
    public static String load( String aFileName ) {
        try {
            File file = new File( aFileName );
            StringBuffer data = new StringBuffer( (int)file.length() );
            FileReader fr = new FileReader( file );
            BufferedReader br = new BufferedReader( fr );
            String record = null;
            while( (record = br.readLine()) != null ) {
                data.append( record );
            }
            return data.toString();
        }
        catch( FileNotFoundException Ex ) {
            System.out.println( "File Not Found " + Ex );
            return "";
        }
        catch( IOException ioEx ) {
            System.out.println( "IO Exception " + ioEx );
            return "";
        }
    }
}
