package com.swapswire.dealsinkexample;
import com.swapswire.sw_api.SWAPILinkModule;
import com.swapswire.sw_api.SW_DealNotifyData;


public class Session {

    public static ConnectionStateCallback m_ConnStateCB = new ConnectionStateCallback() {
            public void sessionCallback( int aSessionHandle, Object aTag, int aEvent ) {
                System.out.println( "*** Connection State Callback for session " + aSessionHandle + ":\n- Event - "  + SWAPILinkModule.SW_ErrorStr(aEvent) );
                return;
            }
        };
        
    public static DealStatusNotifyExCallback m_DealStatusNotifyExCB = new DealStatusNotifyExCallback() {
        public void dealNotifyExCallback(SW_DealNotifyData dnData) {
                System.out.println( "*** Deal status change notification ***" );
                System.out.println( "LH - " + dnData.getLh() );
                System.out.println( "Broker Deal ID - " + dnData.getBrokerId() );
                System.out.println( "Deal ID - " + dnData.getDealId() );
                System.out.println( "Major Version - " + dnData.getMajorVer() );
                System.out.println( "Minor Version - " + dnData.getMinorVer() );
                System.out.println( "Private Version - " + dnData.getPrivateVer() );
                System.out.println( "Side - " + dnData.getSide() );
                System.out.println( "Previous DVH - " + dnData.getPrevDVH() );
                System.out.println( "New DVH - " + dnData.getDvh() );
                System.out.println( "New State - " + dnData.getNewState() );
                System.out.println( "New State String - " + dnData.getNewStateStr() );
                System.out.println( "Contract State String - " + dnData.getContractState() );
                System.out.println( "Product Type - " + dnData.getProductType() );
                System.out.println( "Trade Attr Flags - " + dnData.getTradeAttrFlags() );
                return;
            }
        };

    public static final String  DEFAULTSERVER = "DeaLSink";
    public static final int     DEFAULTPORT   = 9009;
    public static final int     TESTDURATION  = 120;
    public static final int     TESTTIMEOUT   = 60;

    public Session( String aServer, String aUsername, String aPassword, int aTimeout ) {
        serverport = aServer; 
        username = aUsername;
        password = aPassword;
        timeout = aTimeout;
        event = SWAPILinkModule.SWERR_LostConnection;
        sessionHandle = 0;
        loginHandle = 0;
    }

    public ErrorCode connect() {
        ErrorCode ret;

        // connect to the DealSink
        System.out.println( "Connecting to " + serverport );
        
        int[]   tmpSessionHandle = new int[1];
        ret = DealSinkWrapper.connect( tmpSessionHandle, serverport, timeout, m_ConnStateCB );
        if ( !ret.isSuccess() ) {
            System.out.println( "Failed to connect to Dealsink Server" );
            ret.dump();
            return ret;
        }
        sessionHandle = tmpSessionHandle[0];
        System.out.println( "Connected to Dealsink Server" );
        ret = DealSinkWrapper.registerSessionStateCallback(m_ConnStateCB);
        if ( !ret.isSuccess() ) {
            System.out.println( "Failed to register session state callback" );
            ret.dump();
            disconnect();
            return ret;
        }

        // Login
        int[]  tmpLoginHandle = new int[1];
        ret = DealSinkWrapper.login( tmpLoginHandle, sessionHandle, username, password );
        if ( !ret.isSuccess() ) {
            System.out.println( "Failed to login" );
            ret.dump();
            disconnect();
            return ret;
        }
        loginHandle = tmpLoginHandle[0];
        System.out.println( "Logged in to Dealsink Server" );

        // Register for deal status notifications
        ret = DealSinkWrapper.registerNotifyExCallback( loginHandle, m_DealStatusNotifyExCB );
        if ( !ret.isSuccess() ) {
            System.out.println( "Failed to register for deal status change notifications" );
            ret.dump();
            disconnect();
            return ret;
        }

        // store this instance against the session & login handles so we can look them up in callbacks
        setSessionStatus( ret.errorCode );

        return ret;
    }

    public void disconnect() {
        if ( loginHandle != 0 ) {
            // de-register notification callback
            DealSinkWrapper.deregisterNotifyCallback( loginHandle );
            
            // Logout
            ErrorCode ret = DealSinkWrapper.logout( loginHandle );
            if ( !ret.isSuccess() ) {
                System.out.println( "Failed to logout from DealSink server" );
                ret.dump();
            }
            loginHandle = 0;
        }

        if ( sessionHandle != 0 ) {
            // disconnect the session
            ErrorCode ret = DealSinkWrapper.disconnect( sessionHandle );
            if ( !ret.isSuccess() ) {
                System.out.println( "Failed to disconnect from DealSink server" );
                ret.dump();
            }
            sessionHandle = 0;
        }

        setSessionStatus( SWAPILinkModule.SWERR_LostConnection );
    }

    public boolean isValidClientSession() { 
        return event >= 0;
    }

    public void setSessionStatus( int aEvent ) { 
        event = aEvent; 
    }
    
    // accessors
    public String getUsername() { 
        return username; 
    }
    public String getPassword() { 
        return password; 
    }
    public int getSessionHandle() { 
        return sessionHandle; 
    }
    public int getLoginHandle() { 
        return loginHandle; 
    }

    private String  serverport;
    private String  username;
    private String  password;
    private int     timeout;
    private int     event;
    private int     sessionHandle;
    private int     loginHandle;
}
