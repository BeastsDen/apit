package com.swapswire.dealerexample;

import java.text.SimpleDateFormat;
import java.util.Calendar;

public class SubmitBrokerDealCmd extends DealerCmd 
{

    public SubmitBrokerDealCmd() 
    {
        super("SubmitBrokerDeal", "SWBML recipientXML recipientXML", "SWBML must contain \'BROKERCODE\' as the broker code");
    }

   	// -------------------------------------------------------------------
   	
    public static String nowstr( )
   	{
   	   Calendar cal = Calendar.getInstance();
       SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
       return sdf.format(cal.getTime());
   		
   	
   	}    
    
    public static String run(Session session, 
    		                 String swbml, 
    		                 String recipient1XML, 
    		                 String recipient2XML) throws ErrorCode 
    {
    	
		int initalLen = swbml.length();
		String brokerreplace = new String( "BROKERCODE");
		String brokercode = nowstr();
		
		int index = swbml.indexOf(brokerreplace);
		String frontStr = swbml.substring(0, index);
		String backStr = swbml.substring(index+brokerreplace.length(), initalLen);
		swbml = frontStr + brokercode + backStr;    	
    	
        System.out.println("Submitting Broker deal");
        String[] newDealVersionHandle = {new String()};
        DealerAPIWrapper.submitBrokerDeal(session.getLoginHandle(), 
        		                          swbml, 
        		                          recipient1XML, 
        		                          recipient2XML, 
        		                          newDealVersionHandle);
        
        System.out.println("Broker Code = " + brokercode);
        System.out.println("Deal Submitted OK");
        System.out.println("New deal version handle - " + newDealVersionHandle[0]);
        return newDealVersionHandle[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode 
    {
        assert (argv.length >= 3);
        
        String SWBML = getStringArg(argv[0]);
        String recipient1XML = getStringArg(argv[1]);
        String recipient2XML = getStringArg(argv[2]);
 
        run(session, SWBML, recipient1XML, recipient2XML );
    }
}
