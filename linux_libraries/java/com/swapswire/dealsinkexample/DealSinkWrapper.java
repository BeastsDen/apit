package com.swapswire.dealsinkexample;

import com.swapswire.sw_api.SWAPILinkModule;
import com.swapswire.sw_api.SW_DealState;

public class DealSinkWrapper
{
    public static ErrorCode initialise(String aIniFile)
    {
        return new ErrorCode(SWAPILinkModule.SW_Initialise(aIniFile, SWAPILinkModule.SW_API_VER));
    }

    public static ErrorCode connect(int[]  aSessionHandle,
                                    String aHost,
                                    int    aTimeout,
                                    Object aHandler)
    {
        return new ErrorCode(SWAPILinkModule.SW_Connect(aHost, aTimeout, aHandler, aSessionHandle));
    }

    public static ErrorCode disconnect(int aSessionHandle)
    {
        return new ErrorCode(SWAPILinkModule.SW_Disconnect(aSessionHandle));
    }

    public static ErrorCode setApplicationInfo(int    aSessionHandle,
                                               String aInfo)
    {
        return new ErrorCode(SWAPILinkModule.SW_SetApplicationInfo(aSessionHandle, aInfo));
    }

    public static ErrorCode login(int[]  aLoginHandle,
                                  int    aSessionHandle,
                                  String aUsername,
                                  String aPassword)
    {
        return new ErrorCode(SWAPILinkModule.SW_Login(aSessionHandle, aUsername, aPassword, aLoginHandle));
    }

    public static ErrorCode logout(int aLoginHandle)
    {
        return new ErrorCode(SWAPILinkModule.SW_Logout(aLoginHandle));
    }

    public static ErrorCode changePassword(int    aSessionHandle,
                                           String aUserName,
                                           String aOldPassword,
                                           String aNewPassword)
    {
        return new ErrorCode(SWAPILinkModule.SW_ChangePassword(aSessionHandle, aUserName, aOldPassword, aNewPassword));
    }

    public static ErrorCode poll(int aMaxtimems,
                                 int aTimeoutms)
    {
        return new ErrorCode(SWAPILinkModule.SW_Poll(aMaxtimems, aTimeoutms));
    }

    public static ErrorCode registerSessionStateCallback(Object aHandler)
    {
        return new ErrorCode(SWAPILinkModule.SW_RegisterSessionStateCallback(aHandler));
    }
    public static ErrorCode registerNotifyCallback(int    aLoginHandle,
                                                   Object aHandler)
    {
        return new ErrorCode(SWAPILinkModule.SW_RegisterDealNotifyCallback(aLoginHandle, aHandler));
    }
    public static ErrorCode registerNotifyExCallback(int    aLoginHandle,
                                                     Object aHandler)
    {
        return new ErrorCode(SWAPILinkModule.SW_RegisterDealNotifyExCallback(aLoginHandle, aHandler));
    }

    public static void deregisterNotifyCallback(int aLoginHandle)
    {
        SWAPILinkModule.SW_RegisterDealNotifyCallback(aLoginHandle, null);
    }
    public static void deregisterNotifyExCallback(int aLoginHandle)
    {
        SWAPILinkModule.SW_RegisterDealNotifyExCallback(aLoginHandle, null);
    }

    public static ErrorCode getDealVersionHandle(int      lh,
                                                 long     dealID,
                                                 int      contractVersion,
                                                 int      privateVersion,
                                                 int      side,
                                                 String[] dealVersionHandle)
    {
        return new ErrorCode(SWAPILinkModule.SW_DealGetVersionHandle(lh, dealID, contractVersion, privateVersion, side, dealVersionHandle));
    }

    public static ErrorCode getMySideId(int   lh,
                                        long  dealID,
                                        int   contractVersion,
                                        int[] side)
    {
        return new ErrorCode(SWAPILinkModule.SW_DealGetMySide(lh, dealID, contractVersion, side));
    }

    public static ErrorCode getDealState(int            aLoginHandle,
                                         String         aDealVersionHandle,
                                         SW_DealState[] aDealState)
    {
        int[] pDealState = { 0 };
        ErrorCode ec = new ErrorCode(SWAPILinkModule.SW_DealGetDealState(aLoginHandle, aDealVersionHandle, pDealState));
        aDealState[0] = SW_DealState.swigToEnum(pDealState[0]);
        return ec;
    }

    public static ErrorCode getDealXML(int      aLoginHandle,
                                       String   aDealVersionHandle,
                                       String   aSwmlVersion,
                                       String[] aReturnBuffer)
    {
        return new ErrorCode(SWAPILinkModule.SW_DealGetSWML(aLoginHandle, aSwmlVersion, aDealVersionHandle, aReturnBuffer));
    }

    public static ErrorCode queryDeals(int      aLoginHandle,
                                       String   aQueryXml,
                                       String[] aReturnBuffer,
                                       Object   aCallback)
    {
        return new ErrorCode(SWAPILinkModule.SW_QueryDeals(aLoginHandle, aQueryXml, aReturnBuffer, aCallback));
    }

    public static ErrorCode updateDeal(int    aLoginHandle,
                                       String aDealVersionHandle,
                                       String aModXml)
    {
        String[] newDealVersionHandle = {new String()};
        return new ErrorCode(SWAPILinkModule.SW_DealUpdate(aLoginHandle, aDealVersionHandle, aModXml, newDealVersionHandle));
    }

    public static ErrorCode updateDealEx(int      aLoginHandle,
                                         String   aDealVersionHandle,
                                         String   aModXml,
                                         String[] aNewDealVersionHandleOut)
    {
        return new ErrorCode(SWAPILinkModule.SW_DealUpdate(aLoginHandle, aDealVersionHandle, aModXml, aNewDealVersionHandleOut));
    }

    public static ErrorCode validateXML(int      aLoginHandle,
                                        String   aModXml,
                                        String[] aReturnBuffer)
    {
        return new ErrorCode(SWAPILinkModule.SW_ValidateXML(aLoginHandle, aModXml, aReturnBuffer));
    }

    public static String errorStr(int aErrorCode)
    {
        return SWAPILinkModule.SW_ErrorStr(aErrorCode);
    }

    public static String lastErrorSpecifics()
    {
        return SWAPILinkModule.SW_GetLastErrorSpecifics();
    }

    public static int getLibraryVersion()
    {
        return SWAPILinkModule.SW_GetLibraryVersion();
    }

    public static int getLibraryVersionEx(String[] aReturnBuffer)
    {
        return SWAPILinkModule.SW_GetLibraryVersionEx(aReturnBuffer);
    }
}
