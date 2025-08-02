package com.swapswire.dealerexample;

import com.swapswire.sw_api.SWAPILinkModule;
import com.swapswire.sw_api.SW_DealState;
import com.swapswire.sw_api.SW_DealerDealState;
import com.swapswire.sw_api.SW_CallbackMode;

public class DealerAPIWrapper
{
    private static void Check(int code) throws ErrorCode
    {
        ErrorCode ec = new ErrorCode(code);
        if (!ec.isSuccess())
        {
            throw ec;
        }
    }

    public static void initialise(String iniFile) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_Initialise(iniFile, SWAPILinkModule.SW_API_VER));
    }

    public static void connect(String serverport,
                               int    timeout,
                               Object handler,
                               int[]  sessionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_Connect(serverport, timeout, handler, sessionHandle));
    }

    public static void disconnect(int sessionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_Disconnect(sessionHandle));
    }

    public static void setCallBackMode(SW_CallbackMode callbackMode) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SetCallbackMode(callbackMode));
    }

    public static void setApplicationInfo(int    sessionHandle,
                                          String info) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SetApplicationInfo(sessionHandle, info));
    }

    public static void login(int    sessionHandle,
                             String userID,
                             String password,
                             int[]  loginHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_Login(sessionHandle, userID, password, loginHandle));
    }

    public static void logout(int loginHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_Logout(loginHandle));
    }

    public static void changePassword(int    sessionHandle,
                                      String userName,
                                      String oldPassword,
                                      String newPassword) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_ChangePassword(sessionHandle, userName, oldPassword, newPassword));
    }

    public static void submitNewDeal(int      loginHandle,
                                     String   swdml,
                                     String   privateDataXML,
                                     String   recipientXML,
                                     String   messageText,
                                     String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SubmitNewDirectDeal(loginHandle, swdml, privateDataXML, recipientXML, messageText, newDealVersionHandle));
    }

    public static void submitBrokerDeal(int      loginHandle,
                                        String   swbml,
                                        String   recipient1XML,
                                        String   recipient2XML,
                                        String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SubmitNewBrokeredDealEx(loginHandle, recipient1XML + recipient2XML, swbml, newDealVersionHandle));
    }
    public static void submitNewPrimeBrokerDeal(int      loginHandle,
                                                String   swdml,
                                                String   privateDataXML,
                                                String   recipientXML,
                                                String   messageText,
                                                String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SubmitNewPrimeBrokerDeal(loginHandle, swdml, privateDataXML, recipientXML, messageText, newDealVersionHandle));
    }

    public static void submitBackload(int      loginHandle,
                                      String   swdml,
                                      String   privateDataXML,
                                      String   recipientXML,
                                      String   messageText,
                                      String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SubmitBackloadDeal(loginHandle, swdml, privateDataXML, recipientXML, messageText, newDealVersionHandle));
    }

    public static void submitDraftNewDeal(int      loginHandle,
                                          String   swdml,
                                          String   privateDataXML,
                                          String   recipientXML,
                                          String   messageText,
                                          String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SubmitDraftNewDeal(loginHandle, swdml, privateDataXML, recipientXML, messageText, newDealVersionHandle));
    }

    public static void submitDraftNewPrimeBrokerDeal(int      loginHandle,
                                                     String   swdml,
                                                     String   privateDataXML,
                                                     String   recipientXML,
                                                     String   messageText,
                                                     String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SubmitDraftNewPrimeBrokerDeal(loginHandle, swdml, privateDataXML, recipientXML, messageText, newDealVersionHandle));
    }

    public static void amendDraftPrimeBrokerDeal(int      loginHandle,
                                                 String   oldDealVersionHandle,
                                                 String   swdml,
                                                 String   privateDataXML,
                                                 String   recipientXML,
                                                 String   messageText,
                                                 String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealAmendDraftPrimeBroker(loginHandle, oldDealVersionHandle, swdml, privateDataXML, recipientXML, messageText, newDealVersionHandle));
    }

    public static void submitCancellation(int      loginHandle,
                                          String   oldDealVersionHandle,
                                          String   cancellationFeeXML,
                                          String   privateDataXML,
                                          String   recipientXML,
                                          String   messageText,
                                          String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SubmitCancellationEx(loginHandle, oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText, 0, newDealVersionHandle));
    }

    public static void submitCancellationEx(int      loginHandle,
                                            String   oldDealVersionHandle,
                                            String   cancellationFeeXML,
                                            String   privateDataXML,
                                            String   recipientXML,
                                            String   messageText,
                                            int      effectiveDate,
                                            String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SubmitCancellationEx(loginHandle, oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText, effectiveDate, newDealVersionHandle));
    }

    public static void submitDraftCancellation(int      loginHandle,
                                               String   oldDealVersionHandle,
                                               String   cancellationFeeXML,
                                               String   privateDataXML,
                                               String   recipientXML,
                                               String   messageText,
                                               int      effectiveDate,
                                               String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SubmitDraftCancellation(loginHandle, oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText, effectiveDate, newDealVersionHandle));
    }

    public static void submitDraftAmendment(int      loginHandle,
                                            String   oldDealVersionHandle,
                                            String   swdml,
                                            String   privateDataXML,
                                            String   recipientXML,
                                            String   messageText,
                                            String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SubmitDraftAmendment(loginHandle, oldDealVersionHandle, swdml, privateDataXML, recipientXML, messageText, newDealVersionHandle));
    }

    public static void submitPrimeBrokerAmendment(int      loginHandle,
                                                  String   oldDealVersionHandle,
                                                  String   swdml,
                                                  String   privateDataXML,
                                                  String   recipientXML,
                                                  String   messageText,
                                                  String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SubmitPrimeBrokerAmendment(loginHandle, oldDealVersionHandle, swdml, privateDataXML, recipientXML, messageText, newDealVersionHandle));
    }

    public static void submitNovation(int      loginHandle,
                                      String   oldDealVersionHandle,
                                      String   swdml,
                                      String   privateDataXML,
                                      String   recipientXML,
                                      String   messageText,
                                      String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_SubmitNovation(loginHandle, oldDealVersionHandle, swdml, privateDataXML, recipientXML, messageText, newDealVersionHandle));
    }

    public static void amendDraft(int      loginHandle,
                                  String   oldDealVersionHandle,
                                  String   swdml,
                                  String   privateDataXML,
                                  String   recipientXML,
                                  String   messageText,
                                  String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealAmendDraft(loginHandle, oldDealVersionHandle, swdml, privateDataXML, recipientXML, messageText, newDealVersionHandle));
    }

    public static void deleteDraft(int      loginHandle,
                                   String   oldDealVersionHandle,
                                   String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealDeleteDraft(loginHandle, oldDealVersionHandle, newDealVersionHandle));
    }

    public static void sendChatMessage(int      loginHandle,
                                       String   oldDealVersionHandle,
                                       String   messageText,
                                       String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealSendChatMessage(loginHandle, oldDealVersionHandle, messageText, newDealVersionHandle));
    }

    public static void pickup(int      loginHandle,
                              String   oldDealVersionHandle,
                              String   privateDataXML,
                              String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealPickup(loginHandle, oldDealVersionHandle, privateDataXML, newDealVersionHandle));
    }

    public static void accept(int      loginHandle,
                              String   oldDealVersionHandle,
                              String   privateDataXML,
                              String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealAccept(loginHandle, oldDealVersionHandle, privateDataXML, newDealVersionHandle));
    }

    public static void acceptAffirm(int      loginHandle,
                                    String   oldDealVersionHandle,
                                    String   privateDataXML,
                                    String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealAcceptAffirm(loginHandle, oldDealVersionHandle, privateDataXML, newDealVersionHandle));
    }

    public static void rejectDK(int      loginHandle,
                                String   oldDealVersionHandle,
                                String   messageText,
                                String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealRejectDK(loginHandle, oldDealVersionHandle, messageText, newDealVersionHandle));
    }

    public static void requestRevision(int      loginHandle,
                                       String   oldDealVersionHandle,
                                       String   messageText,
                                       String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealRequestRevision(loginHandle, oldDealVersionHandle, messageText, newDealVersionHandle));
    }

    public static void affirm(int      loginHandle,
                              String   oldDealVersionHandle,
                              String   swdml,
                              String   privateDataXML,
                              String   messageText,
                              String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealAffirm(loginHandle, oldDealVersionHandle, swdml, privateDataXML, messageText, newDealVersionHandle));
    }

    public static void transfer(int      loginHandle,
                                String   oldDealVersionHandle,
                                String   privateDataXML,
                                String   transferRecipientXML,
                                String   messageText,
                                String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealTransfer(loginHandle, oldDealVersionHandle, privateDataXML, transferRecipientXML, messageText, newDealVersionHandle));
    }

    public static void withdraw(int      loginHandle,
                                String   oldDealVersionHandle,
                                String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealWithdraw(loginHandle, oldDealVersionHandle, newDealVersionHandle));
    }

    public static void release(int      loginHandle,
                               String   oldDealVersionHandle,
                               String   privateDataXML,
                               String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealRelease(loginHandle, oldDealVersionHandle, privateDataXML, newDealVersionHandle));
    }

    public static void acknowledge(int      loginHandle,
                                   String   oldDealVersionHandle,
                                   String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealAcknowledge(loginHandle, oldDealVersionHandle, newDealVersionHandle));
    }

    public static void rejectDirectDeal(int      loginHandle,
                                        String   oldDealVersionHandle,
                                        String   messageText,
                                        String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealReject(loginHandle, oldDealVersionHandle, messageText, newDealVersionHandle));
    }

    public static void pull(int      loginHandle,
                            String   oldDealVersionHandle,
                            String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealPull(loginHandle, oldDealVersionHandle, newDealVersionHandle));
    }

    public static void validateXML(int      loginHandle,
                                   String   xml,
                                   String[] errorString) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_ValidateXML(loginHandle, xml, errorString));
    }

    /* dealer queries */

    public static void getDealSWML(int      loginHandle,
                                   String   swmlVersion,
                                   String   dealVersionHandle,
                                   String[] outputSWML) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealGetSWML(loginHandle, swmlVersion, dealVersionHandle, outputSWML));
    }

    public static void getDealSWDML(int      loginHandle,
                                    String   swmlVersion,
                                    String   dealVersionHandle,
                                    String[] outputLongFormSwdml) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealGetSWDML(loginHandle, swmlVersion, dealVersionHandle, outputLongFormSwdml));
    }

    public static void getSWDMLfromSWML(int      loginHandle,
                                        String   inputSWML,
                                        String[] outputSWML) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_GetSWDMLfromSWML(loginHandle, inputSWML, outputSWML));
    }

    public static void getLongSWDMLFromCSV(int      loginHandle,
                                           String   templateFamily,
                                           String   headerRow,
                                           String   dataRow,
                                           String   swdmlVersion,
                                           String[] outputLongFormSwdml) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_CSVToXML(loginHandle, SWAPILinkModule.SW_XMLTYPE_LONG_SWDML, swdmlVersion, templateFamily, headerRow, dataRow, outputLongFormSwdml));
    }

    public static void getPrivateDataXMLFromCSV(int      loginHandle,
                                                String   templateFamily,
                                                String   headerRow,
                                                String   dataRow,
                                                String[] outputPrivateDataXML) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_CSVToXML(loginHandle, SWAPILinkModule.SW_XMLTYPE_PRIVATE_DATA_XML, "", templateFamily, headerRow, dataRow, outputPrivateDataXML));
    }

    public static void getMessageTextFromCSV(int      loginHandle,
                                             String   templateFamily,
                                             String   headerRow,
                                             String   dataRow,
                                             String[] outputMessageText) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_CSVToXML(loginHandle, SWAPILinkModule.SW_XMLTYPE_MESSAGE_TEXT, "", templateFamily, headerRow, dataRow, outputMessageText));
    }

    public static void getDealInfo(int      loginHandle,
                                   String   dealVersionHandle,
                                   String[] dealInfoXML) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealGetXML(loginHandle, dealVersionHandle, SWAPILinkModule.SW_DEAL_STATE_INFO_1_0, SWAPILinkModule.SWX_DealStateInfo, dealInfoXML));
    }

    public static void getDealVersionHandle(int      loginHandle,
                                            long     dealID,
                                            int      contractVersion,
                                            int      privateVersion,
                                            int      side,
                                            String[] latestDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealGetVersionHandle(loginHandle, dealID, contractVersion, privateVersion, side, latestDealVersionHandle));
    }

    public static void getAllDealVersionHandles(int      loginHandle,
                                                long     dealID,
                                                int      contractVersion,
                                                int      side,
                                                String[] dealVersionHandles) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealGetAllVersionHandles(loginHandle, dealID, contractVersion, side, dealVersionHandles));
    }

    public static void getDealState(int            loginHandle,
                                    String         dealVersionHandle,
                                    SW_DealState[] dealState) throws ErrorCode
    {
        int[] dealStateOut = new int[1];
        Check(SWAPILinkModule.SW_DealGetDealState(loginHandle, dealVersionHandle, dealStateOut));
        dealState[0] = SW_DealState.swigToEnum(dealStateOut[0]);
    }

    public static void getActiveDealInfo(int      loginHandle,
                                         String[] activeDealInfo) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_GetActiveDealInfo(loginHandle, activeDealInfo));
    }

    public static void queryDeals(int      loginHandle,
                                  String   queryXML,
                                  String[] resultXML) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_QueryDeals(loginHandle, queryXML, resultXML, null));
    }

    public static void queryDefaultMismatch(int      loginHandle,
                                            String   dealVersionHandle,
                                            String[] misMatchResultXML) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_QueryDefaultMisMatch(loginHandle, dealVersionHandle, misMatchResultXML));
    }

    public static void getParticipants(int      loginHandle,
                                       String   participantQueryXML,
                                       String[] resultXML) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_GetParticipants(loginHandle, participantQueryXML, resultXML));
    }

    public static void getAddressList(int      loginHandle,
                                      String   addressListQueryXML,
                                      String[] resultXML) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_GetAddressList(loginHandle, addressListQueryXML, resultXML));
    }

    public static void getLegalEntityList(int      loginHandle,
                                          String   legalEntityListQueryXML,
                                          String[] resultXML) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_GetLegalEntities(loginHandle, legalEntityListQueryXML, resultXML));
    }

    public static void getUserInfo(int      loginHandle,
                                   String[] resultXML) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_GetMyUserInfo(loginHandle, resultXML));
    }

    public static void getBookList(int      loginHandle,
                                   String[] resultXML) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_GetMyBooks(loginHandle, resultXML));
    }

    public static void poll(int maxtime,
                            int timeout) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_Poll(maxtime, timeout));
    }

    public static void registerSessionStateCallback(Object handler) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_RegisterSessionStateCallback(handler));
    }

    public static void registerNotifyCallback(int    loginHandle,
                                              Object handler) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_RegisterDealNotifyCallback(loginHandle, handler));
    }

    public static void registerNotifyExCallback(int    loginHandle,
                                                Object handler) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_RegisterDealNotifyExCallback(loginHandle, handler));
    }

    public static String errorStr(int errorCode)
    {
        return SWAPILinkModule.SW_ErrorStr(errorCode);
    }

    public static String lastErrorSpecifics()
    {
        return SWAPILinkModule.SW_GetLastErrorSpecifics();
    }

    public static String dealStateStr(SW_DealerDealState dealStateCode)
    {
        return SWAPILinkModule.SW_DealerDealStateStr(dealStateCode);
    }

    public static int getLibraryVersion()
    {
        return SWAPILinkModule.SW_GetLibraryVersion();
    }

    public static int getLibraryVersionEx(String[] resultVersion)
    {
        return SWAPILinkModule.SW_GetLibraryVersionEx(resultVersion);
    }
    public static void suggestMatch(int      loginHandle,
                                    String   oldDealVersionHandle,
                                    String   cptyDealVersionHandle,
                                    String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealSuggestMatch(loginHandle,
                                                  oldDealVersionHandle,
                                                  cptyDealVersionHandle,
                                                  newDealVersionHandle));
    }
    public static void withdrawSuggestMatch(int      loginHandle,
                                            String   oldDealVersionHandle,
                                            String   cptyDealVersionHandle,
                                            String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_DealWithdrawSuggestMatch(loginHandle,
                                                          oldDealVersionHandle,
                                                          cptyDealVersionHandle,
                                                          newDealVersionHandle));
    }
    public static void matchPull(int      loginHandle,
                                 String   oldDealVersionHandle,
                                 String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_MatchPull(loginHandle, oldDealVersionHandle, newDealVersionHandle));
    }
    public static void matchPush(int      loginHandle,
                                 String   cptyDealVersionHandle,
                                 String[] newDealVersionHandle) throws ErrorCode
    {
        Check(SWAPILinkModule.SW_MatchPush(loginHandle, cptyDealVersionHandle, newDealVersionHandle));
    }
}
