package com.swapswire.util;

import java.util.logging.Logger;
/*
 ***
 *** GENERATED FROM sw_api_inc/sw_api.h - DO NOT EDIT  ***
 ***
 */
public interface APISessionInterface {

    public interface SessionCallback {
        void sessionCallback(int sessionHandle, Object tag, int code);
    }

    public interface QueryCallback {
        int queryCallback(int loginHandle, Object tag, String result, int code);
    }

    public interface BatchCallback {
        int queryCallback(int loginHandle, Object tag, String result);
    }

    public interface DealNotifyCallback {
        void dealNotifyCallback(int lh,
            Object clientData,
            String brokerId,
            long dealId,
            int majorVer,
            int minorVer,
            int privateVer,
            int side,
            String prevDVH,
            String dvh,
            int newState,
            String newStateStr,
            String contractState,
            String productType);
    }

    
    public static class DealNotifyDataHolder {
        int lh;
        Object clientData;
        String brokerId;
        long dealId;
        int majorVer;
        int minorVer;
        int privateVer;
        int side;
        String prevDVH;
        String dvh;
        int newState;
        String newStateStr;
        String contractState;
        String productType;
        long tradeAttrFlags;
        
        public DealNotifyDataHolder(
                int lh,
                Object clientData,
                String brokerId,
                long dealId,
                int majorVer,
                int minorVer,
                int privateVer,
                int side,
                String prevDVH,
                String dvh,
                int newState,
                String newStateStr,
                String contractState,
                String productType,
                long tradeAttrFlags) {
            this.lh = lh;
            this.clientData = clientData;
            this.brokerId = brokerId;
            this.dealId = dealId;
            this.majorVer = majorVer;
            this.minorVer = minorVer;
            this.privateVer = privateVer;
            this.side = side;
            this.prevDVH = prevDVH;
            this.dvh = dvh;
            this.newState = newState;
            this.newStateStr = newStateStr;
            this.contractState = contractState;
            this.productType = productType;
            this.tradeAttrFlags = tradeAttrFlags;
        }
        
        
        public int getLh() {
            return lh;
        }
        
        public Object getClientData() {
            return clientData;
        }
        
        public String getBrokerId() {
            return brokerId;
        }
        
        public long getDealId() {
            return dealId;
        }
        
        public int getMajorVer() {
            return majorVer;
        }
        
        public int getMinorVer() {
            return minorVer;
        }
        
        public int getPrivateVer() {
            return privateVer;
        }
        
        public int getSide() {
            return side;
        }
        
        public String getPrevDVH() {
            return prevDVH;
        }
        
        public String getDvh() {
            return dvh;
        }
        
        public int getNewState() {
            return newState;
        }
        
        public String getNewStateStr() {
            return newStateStr;
        }
        
        public String getContractState() {
            return contractState;
        }
        
        public String getProductType() {
            return productType;
        }
        
        public long getTradeAttrFlags() {
            return tradeAttrFlags;
        }
        
    }


    public interface DealNotifyExCallback {
        void dealNotifyExCallback(DealNotifyDataHolder data);
    }

    // SW_RegisterDealNotifyExCallback
    public void registerDealNotifyExCallback(final DealNotifyExCallback cfunc) throws APIException;

    public static class APIException extends Exception {

        public static final long serialVersionUID = 0L;

        public final Object[] args;
        public final String errorMsg;
        public final int errorCode;

        public APIException(final int errorCode, final String errorMsg, final Object... args) {
            this.args = args;
            this.errorCode = errorCode;
            this.errorMsg = errorMsg;
        }

        public int getErrorCode() {
            return this.errorCode;
        }

        public String getErrorMsg() {
            return errorMsg;
        }

        public Object[] getArgs() {
            return args;
        }

        @Override
        public String getMessage() {
            final StringBuilder sb = new StringBuilder();
            sb.append("Failed with errorCode " + errorCode + " \n");
            sb.append("Error specifics: " + errorMsg + " \n");
            for (final Object o: args) {
                sb.append("Args ->" + o + "\n");
            }
            return sb.toString();
        }
    }

    public static class DealVersionsAndSide {
        public final long dealID;
        public final int majorVersion;
        public final int privateVersion;
        public final int side;
        public DealVersionsAndSide(final long dealID, final int majorVersion, final int privateVersion, final int side) {
            this.dealID = dealID;
            this.majorVersion = majorVersion;
            this.privateVersion = privateVersion;
            this.side = side;
        }
    }

    public static class ExtractResult {
        public final String csvResult;
        public final String failures;
        public ExtractResult(final String csvResult, final String failures) {
            this.csvResult = csvResult;
            this.failures = failures;
        }
    }

    // SW_Initialise
    public void initialise(final String iniFile, final int apiVersion) throws APIException ;
    // SW_Connect
    public void connect(final String server, final int timeout, final Object tag) throws APIException ;
    // SW_Disconnect
    public void disconnect() throws APIException ;
    // SW_SetApplicationInfo
    public void setApplicationInfo(final String infoString) throws APIException ;
    // SW_Login
    public void login(final String userID, final String password) throws APIException ;
    // SW_LoginOnBehalf
    public void loginOnBehalf(final String adminID, final String password, final String userID) throws APIException ;
    // SW_Logout
    public void logout() throws APIException ;
    // SW_SetCapability
    public void setCapability(final String capability, final int enable) throws APIException ;
    // SW_GetCapabilities
    public String getCapabilities() throws APIException ;
    // SW_ChangePassword
    public void changePassword(final String userID, final String password, final String newPassword) throws APIException ;
    // SW_SetCallbackMode
    public void setCallbackMode(final int callbackMode_int) throws APIException ;
    // SW_RegisterSessionStateCallback
    public void registerSessionStateCallback(final SessionCallback cfunc) throws APIException ;
    // SW_RegisterDealNotifyCallback
    public void registerDealNotifyCallback(final DealNotifyCallback cfunc) throws APIException ;
    // SW_RegisterBatchCallback
    public void registerBatchCallback(final BatchCallback cb) throws APIException ;
    // SW_Poll
    public void poll(final int maxtime, final int timeout) throws APIException ;
    // SW_GetErrorDescription
    public String getErrorDescription(final int errorCode) throws APIException ;
    // SW_ErrorStr
    public String errorStr(final int errorCode) ;
    // SW_GetLastErrorSpecificsEx
    public String getLastErrorSpecificsEx() throws APIException ;
    // SW_GetLastErrorSpecifics
    public String getLastErrorSpecifics() ;
    // SW_GetAddressList
    public String getAddressList(final String addressListQueryXML) throws APIException ;
    // SW_GetMyUserInfo
    public String getMyUserInfo() throws APIException ;
    // SW_GetStaticData
    public String getStaticData(final String dataCategory, final String dataType) throws APIException ;
    // SW_DealerDealStateStr
    public String dealerDealStateStr(final int dealerDealStateCode_int) ;
    // SW_GetBrokerIDfromSwapsWireID
    public String getBrokerIDfromSwapsWireID(final long dealID) throws APIException ;
    // SW_BrokeredDealGetInfo
    public String brokeredDealGetInfo(final String brokerDealID) throws APIException ;
    // SW_GetBrokerClearingStatus
    public String getBrokerClearingStatus(final String queryXML) throws APIException ;
    // SW_BrokeredDealGetXML
    public String brokeredDealGetXML(final String brokerDealID, final int revisionNumber, final int contractVersion) throws APIException ;
    // SW_BrokeredDealGetRecipientXML
    public String brokeredDealGetRecipientXML(final String brokerDealID, final int revisionNumber, final int contractVersion, final String recipientID) throws APIException ;
    // SW_BrokeredDealGetPickupIdentityByRecipient
    public String brokeredDealGetPickupIdentityByRecipient(final String brokerDealID, final int revisionNumber, final int contractVersion, final String recipientID) throws APIException ;
    // SW_BrokeredDealGetRejectReasonByRecipient
    public String brokeredDealGetRejectReasonByRecipient(final String brokerDealID, final int revisionNumber, final int contractVersion, final String recipientID) throws APIException ;
    // SW_GetEndedDealInfo
    public String getEndedDealInfo(final int endedTimeStartSpan, final int endedTimeCloseSpan) throws APIException ;
    // SW_GetEndedDealInfoEx
    public String getEndedDealInfoEx(final String queryXML) throws APIException ;
    // SW_DealTerminate
    public String dealTerminate(final String brokerDealID) throws APIException ;
    // SW_SubmitNewBackloadAndNovateDeal
    public String submitNewBackloadAndNovateDeal(final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException ;
    // SW_SubmitNewBrokeredDealEx
    public String submitNewBrokeredDealEx(final String recipientsXML, final String dealXML) throws APIException ;
    // SW_ReSubmitNewBrokeredDealEx
    public String reSubmitNewBrokeredDealEx(final String recipientsXML, final String dealXML) throws APIException ;
    // SW_SubmitNewDirectDeal
    public String submitNewDirectDeal(final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException ;
    // SW_SubmitNewPrimeBrokerDeal
    public String submitNewPrimeBrokerDeal(final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException ;
    // SW_SubmitDraftNewDeal
    public String submitDraftNewDeal(final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException ;
    // SW_SubmitDraftNewPrimeBrokerDeal
    public String submitDraftNewPrimeBrokerDeal(final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException ;
    // SW_SubmitBackloadDeal
    public String submitBackloadDeal(final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException ;
    // SW_SubmitNewMatchDeal
    public String submitNewMatchDeal(final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException ;
    // SW_SubmitNewDirectDealEx
    public String submitNewDirectDealEx(final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException ;
    // SW_SubmitCancellationEx
    public String submitCancellationEx(final String oldDealVersionHandle, final String cancellationFeeXML, final String privateDataXML, final String recipientXML, final String messageText, final int effectiveDate) throws APIException ;
    // SW_SubmitCancellation
    public String submitCancellation(final String oldDealVersionHandle, final String cancellationFeeXML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException ;
    // SW_SubmitDraftCancellation
    public String submitDraftCancellation(final String oldDealVersionHandle, final String cancellationFeeXML, final String privateDataXML, final String recipientXML, final String messageText, final int effectiveDate) throws APIException ;
    // SW_SubmitMatchCancellationEx
    public String submitMatchCancellationEx(final String oldDealVersionHandle, final String cancellationFeeXML, final String privateDataXML, final String recipientXML, final String messageText, final int effectiveDate) throws APIException ;
    // SW_SubmitMatchCancellation
    public String submitMatchCancellation(final String oldDealVersionHandle, final String cancellationFeeXML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException ;
    // SW_SubmitNettingInstruction
    public String submitNettingInstruction(final String nettingInstructionXML) throws APIException ;
    // SW_SubmitPostTradeEvent
    public String submitPostTradeEvent(final String oldDealVersionHandle, final String postTradeXML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException ;
    // SW_SubmitExit
    public String submitExit(final String oldDealVersionHandle, final String exitReason, final String privateDataXML, final String recipientXML, final String messageText) throws APIException ;
    // SW_SubmitDraftAmendment
    public String submitDraftAmendment(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException ;
    // SW_SubmitUnderlying
    public String submitUnderlying(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException ;
    // SW_SubmitPrimeBrokerAmendment
    public String submitPrimeBrokerAmendment(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException ;
    // SW_SubmitNovation
    public String submitNovation(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException ;
    // SW_SubmitDraftNovation
    public String submitDraftNovation(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException ;
    // SW_DealAmendDraft
    public String dealAmendDraft(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException ;
    // SW_DealAmendDraftPrimeBroker
    public String dealAmendDraftPrimeBroker(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException ;
    // SW_DealDispute
    public String dealDispute(final String oldDealVersionHandle, final String disputeXML) throws APIException ;
    // SW_DealSendChatMessage
    public String dealSendChatMessage(final String oldDealVersionHandle, final String messageText) throws APIException ;
    // SW_DealPickup
    public String dealPickup(final String oldDealVersionHandle, final String privateDataXML) throws APIException ;
    // SW_DealAccept
    public String dealAccept(final String oldDealVersionHandle, final String privateDataXML) throws APIException ;
    // SW_DealAcceptAffirm
    public String dealAcceptAffirm(final String oldDealVersionHandle, final String privateDataXML) throws APIException ;
    // SW_DealRelease
    public String dealRelease(final String oldDealVersionHandle, final String privateDataXML) throws APIException ;
    // SW_DealRejectDK
    public String dealRejectDK(final String oldDealVersionHandle, final String messageText) throws APIException ;
    // SW_DealRequestRevision
    public String dealRequestRevision(final String oldDealVersionHandle, final String messageText) throws APIException ;
    // SW_DealReject
    public String dealReject(final String oldDealVersionHandle, final String messageText) throws APIException ;
    // SW_DealTransfer
    public String dealTransfer(final String oldDealVersionHandle, final String privateDataXML, final String transferRecipientXML, final String messageText) throws APIException ;
    // SW_DealWithdraw
    public String dealWithdraw(final String oldDealVersionHandle) throws APIException ;
    // SW_DealAcknowledge
    public String dealAcknowledge(final String oldDealVersionHandle) throws APIException ;
    // SW_DealPull
    public String dealPull(final String oldDealVersionHandle) throws APIException ;
    // SW_DealContinueWithNoPrimeBroker
    public String dealContinueWithNoPrimeBroker(final String oldDealVersionHandle) throws APIException ;
    // SW_DealDeleteDraft
    public String dealDeleteDraft(final String oldDealVersionHandle) throws APIException ;
    // SW_MatchDelete
    public String matchDelete(final String oldDealVersionHandle) throws APIException ;
    // SW_DealStateStr
    public String dealStateStr(final int dealStateCode_int) ;
    // SW_QueryDefaultMisMatch
    public String queryDefaultMisMatch(final String dealVersionHandle) throws APIException ;
    // SW_DealGetSWML
    public String dealGetSWML(final String swmlVersion, final String dealVersionHandle) throws APIException ;
    // SW_DealGetSWDML
    public String dealGetSWDML(final String swdmlVersion, final String dealVersionHandle) throws APIException ;
    // SW_DealGetUnderlyingDealSWDML
    public String dealGetUnderlyingDealSWDML(final String swdmlVersion, final String dealVersionHandle) throws APIException ;
    // SW_GetSWDMLfromSWML
    public String getSWDMLfromSWML(final String inputSWML) throws APIException ;
    // SW_GetLongFromShortSWDMLEx
    public String getLongFromShortSWDMLEx(final String inputShortFormSWDML, final String recipientXML, final String swdmlVersion) throws APIException ;
    // SW_CSVToXML
    public String CSVToXML(final String xmlType, final String xmlVersion, final String csvFamily, final String headerRow, final String dataRow) throws APIException ;
    // SW_CSVGetColumn
    public String CSVGetColumn(final String csvFamily, final String columnName, final String headerRow, final String dataRow) throws APIException ;
    // SW_CSVSetColumn
    public String CSVSetColumn(final String csvFamily, final String columnName, final String newValue, final String headerRow, final String dataRow) throws APIException ;
    // SW_DealGetVersionHandle
    public String dealGetVersionHandle(final long dealID, final int majorVersion, final int privateVersion, final int side) throws APIException ;
    // SW_DealGetAllVersionHandles
    public String dealGetAllVersionHandles(final long dealID, final int majorVersion, final int sides) throws APIException ;
    // SW_DealGetMySide
    public int dealGetMySide(final long dealID, final int majorVersion) throws APIException ;
    // SW_DealGetDealState
    public int dealGetDealState(final String dealVersionHandle) throws APIException ;
    // SW_GetActiveDealInfo
    public String getActiveDealInfo() throws APIException ;
    // SW_GetParticipants
    public String getParticipants(final String participantQueryXML) throws APIException ;
    // SW_GetLegalEntities
    public String getLegalEntities(final String legalEntityListQueryXML) throws APIException ;
    // SW_GetMyInterestGroups
    public String getMyInterestGroups() throws APIException ;
    // SW_SetMyInterestGroups
    public void setMyInterestGroups(final String interestGroupXML) throws APIException ;
    // SW_GetMyBooks
    public String getMyBooks() throws APIException ;
    // SW_DealAffirm
    public String dealAffirm(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String messageText) throws APIException ;
    // SW_MatchUpdate
    public String matchUpdate(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String messageText) throws APIException ;
    // SW_SubmitValuationReport
    public void submitValuationReport(final String inputCSV) throws APIException ;
    // SW_RequestValuationReport
    public String requestValuationReport(final int reportDate) throws APIException ;
    // SW_DealGetPrivateBookingState
    public String dealGetPrivateBookingState(final long dealID, final int majorVersion, final int side) throws APIException ;
    // SW_DealGetXML
    public String dealGetXML(final String dealVersionHandle, final String xmlVersion, final String xmlType) throws APIException ;
    // SW_DealUpdate
    public String dealUpdate(final String dealIdentifier, final String inputXML) throws APIException ;
    // SW_DealCheckEligibility
    public String dealCheckEligibility(final String dealVersionHandle, final String eligibilityType) throws APIException ;
    // SW_BatchGetOutstanding
    public String batchGetOutstanding(final String batchName) throws APIException ;
    // SW_BatchGetDetails
    public String batchGetDetails(final int batchId) throws APIException ;
    // SW_BatchAck
    public void batchAck(final int batchId) throws APIException ;
    // SW_BatchUpdate
    public String batchUpdate(final String batchStatusXML) throws APIException ;
    // SW_DealSinkGetSWML
    public String dealSinkGetSWML(final String swmlVersion, final long dealID, final int majorVersion, final int side) throws APIException ;
    // SW_DealSinkDVHGetSWML
    public String dealSinkDVHGetSWML(final String swmlVersion, final String dealVersionHandle) throws APIException ;
    // SW_ExtractGetColumns
    public String extractGetColumns() throws APIException ;
    // SW_DealGetReportingStatus
    public String dealGetReportingStatus(final String queryXML, final long reserved) throws APIException ;
    // SW_DealSetReportingStatus
    public String dealSetReportingStatus(final String reportingStatusUpdateXML, final long reserved) throws APIException ;
    // SW_DealAllowDeClearingEx
    public String dealAllowDeClearingEx(final String dealListXML) throws APIException ;
    // SW_GetLibraryVersion
    public int getLibraryVersion() throws APIException ;
    // SW_GetLibraryVersionEx
    public String getLibraryVersionEx() throws APIException ;
    // SW_ValidateXML
    public String validateXML(final String inputXML) throws APIException ;
    // SW_TransformXML
    public String transformXML(final String xsltPath, final String xsltKey, final String inputXML) throws APIException ;
    // SW_SendTelemetry
    public String sendTelemetry(final String commandXML) throws APIException ;
    // SW_DealTransferAffirm
    public String dealTransferAffirm(final String oldDealVersionHandle) throws APIException ;
    // SW_DealCompare
    public String dealCompare(final String dealVersionHandle, final String dealVersionHandle2) throws APIException ;
    // SW_DealCompareClosestMatch
    public String dealCompareClosestMatch(final String dealVersionHandle) throws APIException ;
    // SW_DealGetMatchInfo
    public String dealGetMatchInfo(final String oldDealVersionHandle) throws APIException ;
    // SW_GetMatchInfo
    public String getMatchInfo() throws APIException ;
    // SW_DealSuggestMatch
    public String dealSuggestMatch(final String oldDealVersionHandle, final String cptyDealVersionHandle) throws APIException ;
    // SW_DealWithdrawSuggestMatch
    public String dealWithdrawSuggestMatch(final String oldDealVersionHandle, final String cptyDealVersionHandle) throws APIException ;
    // SW_MatchPush
    public String matchPush(final String cptyDealVersionHandle) throws APIException ;
    // SW_MatchPull
    public String matchPull(final String oldDealVersionHandle) throws APIException ;
    // SW_GateCheckDispute
    public String gateCheckDispute(final String oldDealVersionHandle, final String recipientXML, final String messageText) throws APIException ;


    // SW_DealGetIDVersionsAndSide
    public DealVersionsAndSide dealGetIDVersionsAndSide(final String dealVersionHandle) throws APIException;

    // SW_QueryDeals
    public String queryDeals(final String queryXML, final QueryCallback qc) throws APIException;

    public void check(final int errorCode, final Object...args) throws APIException;
    public int getLoginHandle();
    public int getSessionHandle();
    public Logger getLogger();
}


