package com.swapswire.dealerexample;

import com.swapswire.sw_api.SWAPILinkModule;
import com.swapswire.sw_api.SW_CallbackMode;
import com.swapswire.sw_api.SW_DealNotifyData;

public class Session {

    public static SessionStateCallback m_SessionStateCB = new SessionStateCallback() {

        public void sessionCallback(int sessionHandle, Object tag, int errorCode) {
            ErrorCode ec = new ErrorCode(errorCode);
            System.out.println("Event - " + ec.toString());
            return;
        }
    };

    public static NotifyExCallback m_NotifyExCB = new NotifyExCallback() {

        public void dealNotifyExCallback(SW_DealNotifyData dnData) {
            System.out.println("*** Notification ***");
            System.out.println("LH - " + dnData.getLh());
            System.out.println("Broker Deal Id - " + dnData.getBrokerId());
            System.out.println("Deal ID - " + dnData.getDealId());
            System.out.println("Major Version - " + dnData.getMajorVer());
            System.out.println("Minor Version - " + dnData.getMinorVer());
            System.out.println("Private Version - " + dnData.getPrivateVer());
            System.out.println("Side - " + dnData.getSide());
            System.out.println("Previous DVH - " + dnData.getPrevDVH());
            System.out.println("DVH - " + dnData.getDvh());
            System.out.println("New State - " + dnData.getNewState());
            System.out.println("New State String - " + dnData.getNewStateStr());
            System.out.println("Contract State - " + dnData.getContractState());
            System.out.println("Product Type - " + dnData.getProductType());
            System.out.println("Trade Attr Flags - " + dnData.getTradeAttrFlags());
        }
    };

    public static final String DEFAULTSERVER = "localhost";
    public static final int DEFAULTPORT = 9009;
    public static final int TESTDURATION = 120;
    public static final int TESTTIMEOUT = 60;

    public Session(String serverport, String username, String password, int timeout) {
        this.serverport = serverport;
        this.username = username;
        this.password = password;
        this.timeout = timeout;
        this.event = SWAPILinkModule.SWERR_LostConnection;
        this.sessionHandle = 0;
    }

    public void connect() throws ErrorCode {
        try {
            // Connect
            int[] tmpSessionHandle = new int[1];
            System.out.println("Connecting to " + serverport);
            DealerAPIWrapper.connect(serverport, timeout, m_SessionStateCB, tmpSessionHandle);
            sessionHandle = tmpSessionHandle[0];
            System.out.println("Connected to Server");
            
            DealerAPIWrapper.setCallBackMode(SW_CallbackMode.SWCM_Synchronous);
            // Register for session state callbacks
            DealerAPIWrapper.registerSessionStateCallback(m_SessionStateCB);

            // Login
            int[] tmpLoginHandle = new int[1];
            DealerAPIWrapper.login(sessionHandle, username, password, tmpLoginHandle);
            loginHandle = tmpLoginHandle[0];
            System.out.println("Logged in to Server");
            // Register for deal status notifications
            DealerAPIWrapper.registerNotifyExCallback(loginHandle, m_NotifyExCB);
        } catch (ErrorCode ec) {
            switch (ec.errorCode) {
                case SWAPILinkModule.SWERR_LostConnection:
                    System.out.println("Failed to connect to Server.");
                    break;
                case SWAPILinkModule.SWERR_InvalidHandle:
                    System.out.println("Failed to register callback.");
                    break;
                case SWAPILinkModule.SWERR_WrongUsernameOrPassword:
                case SWAPILinkModule.SWERR_PasswordExpired:
                case SWAPILinkModule.SWERR_LoginLimitReached:
                    System.out.println("Failed to login");
                    break;
                default:
                    break;
            }
            setSessionStatus(ec.errorCode);
            disconnect();
            throw ec;
        }
        // store this instance against the session & login handles so we can look them up in callbacks
        setSessionStatus(SWAPILinkModule.SWERR_Success);
    }

    public void deregisterCallbacks() {
        try {
            DealerAPIWrapper.registerNotifyCallback(loginHandle, null);
            DealerAPIWrapper.registerSessionStateCallback(null);
        } catch (ErrorCode ec) {
            System.out.println("Failed to de-register callback handlers");
            ec.dump();
            return;
        }
    }

    public void disconnect() {
        if (loginHandle != 0) {
            deregisterCallbacks();
            try {
                DealerAPIWrapper.logout(loginHandle);
            } catch (ErrorCode ec) {
                System.out.println("Failed to logout from server");
                ec.dump();
                setSessionStatus(ec.errorCode);
                return;
            }
        }
        if (sessionHandle != 0) {
            // disconnect the session
            try {
                DealerAPIWrapper.disconnect(sessionHandle);
            } catch (ErrorCode ec) {
                System.err.println("Failed to disconnect from server");
                ec.dump();
                return;
            }
        }
        sessionHandle = 0;
        setSessionStatus(SWAPILinkModule.SWERR_LostConnection);
    }

    public boolean isValidClientSession() {
        return sessionHandle > 0 && event >= SWAPILinkModule.SWERR_Success;
    }

    public void setSessionStatus(int event) {
        this.event = event;
    }

    // accessors
    public String getServerAndPort() {
        return serverport;
    }

    public int getTimeout() {
        return timeout;
    }

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

    private String serverport;
    private String username;
    private String password;
    private int timeout;
    private int event;
    private int sessionHandle;
    private int loginHandle;
}
