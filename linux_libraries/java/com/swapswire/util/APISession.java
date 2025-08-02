package com.swapswire.util;

import java.util.logging.Logger;
import java.util.logging.Level;
import com.swapswire.sw_api.SW_DealNotifyData;
import static com.swapswire.sw_api.SWAPILinkModule.*;
import static com.swapswire.sw_api.SWAPILinkModuleConstants.*;
/*
 ***
 *** GENERATED FROM sw_api_inc/sw_api.h - DO NOT EDIT  ***
 ***
 */
public class APISession implements APISessionInterface {

    protected static final Logger logger = Logger.getLogger(APISession.class.getName());
    protected static IllegalStateException ex = null;

    protected int lh;
    protected int sh;


    // SW_Initialise
    public void initialise(final String iniFile, final int apiVersion) throws APIException {
        final int ret = SW_Initialise(iniFile, apiVersion);
        check(ret, "SW_Initialise", iniFile, apiVersion);
    }

    // SW_Connect
    public void connect(final String server, final int timeout, final Object tag) throws APIException {
        final int[] out = new int[1];
        final int ret = SW_Connect(server, timeout, tag, out);
        check(ret, "SW_Connect", server, timeout, tag);
        sh = out[0];
    }

    // SW_Disconnect
    public void disconnect() throws APIException {
        final int ret = SW_Disconnect(sh);
        check(ret, "SW_Disconnect");
        sh = -1;
    }

    // SW_SetApplicationInfo
    public void setApplicationInfo(final String infoString) throws APIException {
        final int ret = SW_SetApplicationInfo(sh, infoString);
        check(ret, "SW_SetApplicationInfo", infoString);
    }

    // SW_Login
    public void login(final String userID, final String password) throws APIException {
        final int[] out = new int[1];
        final int ret = SW_Login(sh, userID, password, out);
        check(ret, "SW_Login", userID, password);
        lh = out[0];
    }

    // SW_LoginOnBehalf
    public void loginOnBehalf(final String adminID, final String password, final String userID) throws APIException {
        final int[] out = new int[1];
        final int ret = SW_LoginOnBehalf(sh, adminID, password, userID, out);
        check(ret, "SW_LoginOnBehalf", adminID, password, userID);
        lh = out[0];
    }

    // SW_Logout
    public void logout() throws APIException {
        final int ret = SW_Logout(lh);
        check(ret, "SW_Logout");
    }

    // SW_SetCapability
    public void setCapability(final String capability, final int enable) throws APIException {
        final int ret = SW_SetCapability(lh, capability, enable);
        check(ret, "SW_SetCapability", capability, enable);
    }

    // SW_GetCapabilities
    public String getCapabilities() throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetCapabilities(lh, out);
        check(ret, "SW_GetCapabilities");
        return out[0];
    }

    // SW_ChangePassword
    public void changePassword(final String userID, final String password, final String newPassword) throws APIException {
        final int ret = SW_ChangePassword(sh, userID, password, newPassword);
        check(ret, "SW_ChangePassword", userID, password, newPassword);
    }

    // SW_SetCallbackMode
    public void setCallbackMode(final com.swapswire.sw_api.SW_CallbackMode callbackMode) throws APIException {
        final int ret = SW_SetCallbackMode(callbackMode);
        check(ret, "SW_SetCallbackMode", callbackMode);
    }

    // SW_SetCallbackMode
    public void setCallbackMode(final int callbackMode_int) throws APIException {
        com.swapswire.sw_api.SW_CallbackMode callbackMode = com.swapswire.sw_api.SW_CallbackMode.swigToEnum(callbackMode_int);
        final int ret = SW_SetCallbackMode(callbackMode);
        check(ret, "SW_SetCallbackMode", callbackMode);
    }

    // SW_RegisterSessionStateCallback
    public void registerSessionStateCallback(final SessionCallback cfunc) throws APIException {
        final int ret = SW_RegisterSessionStateCallback(cfunc);
        check(ret, "SW_RegisterSessionStateCallback", cfunc);
    }

    // SW_RegisterDealNotifyCallback
    public void registerDealNotifyCallback(final DealNotifyCallback cfunc) throws APIException {
        final int ret = SW_RegisterDealNotifyCallback(lh, cfunc);
        check(ret, "SW_RegisterDealNotifyCallback", cfunc);
    }

    // SW_RegisterBatchCallback
    public void registerBatchCallback(final BatchCallback cb) throws APIException {
        final int ret = SW_RegisterBatchCallback(lh, cb);
        check(ret, "SW_RegisterBatchCallback", cb);
    }

    // SW_Poll
    public void poll(final int maxtime, final int timeout) throws APIException {
        final int ret = SW_Poll(maxtime, timeout);
        check(ret, "SW_Poll", maxtime, timeout);
    }

    // SW_GetErrorDescription
    public String getErrorDescription(final int errorCode) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetErrorDescription(errorCode, out);
        check(ret, "SW_GetErrorDescription", errorCode);
        return out[0];
    }

    // SW_ErrorStr
    public String errorStr(final int errorCode) {
        final String ret = SW_ErrorStr(errorCode);
        return ret;
    }

    // SW_GetLastErrorSpecificsEx
    public String getLastErrorSpecificsEx() throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetLastErrorSpecificsEx(out);
        check(ret, "SW_GetLastErrorSpecificsEx");
        return out[0];
    }

    // SW_GetLastErrorSpecifics
    public String getLastErrorSpecifics() {
        final String ret = SW_GetLastErrorSpecifics();
        return ret;
    }

    // SW_GetAddressList
    public String getAddressList(final String addressListQueryXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetAddressList(lh, addressListQueryXML, out);
        check(ret, "SW_GetAddressList", addressListQueryXML);
        return out[0];
    }

    // SW_GetMyUserInfo
    public String getMyUserInfo() throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetMyUserInfo(lh, out);
        check(ret, "SW_GetMyUserInfo");
        return out[0];
    }

    // SW_GetStaticData
    public String getStaticData(final String dataCategory, final String dataType) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetStaticData(lh, dataCategory, dataType, out);
        check(ret, "SW_GetStaticData", dataCategory, dataType);
        return out[0];
    }

    // SW_DealerDealStateStr
    public String dealerDealStateStr(final com.swapswire.sw_api.SW_DealerDealState dealerDealStateCode) {
        final String ret = SW_DealerDealStateStr(dealerDealStateCode);
        return ret;
    }

    // SW_DealerDealStateStr
    public String dealerDealStateStr(final int dealerDealStateCode_int) {
        com.swapswire.sw_api.SW_DealerDealState dealerDealStateCode = com.swapswire.sw_api.SW_DealerDealState.swigToEnum(dealerDealStateCode_int);
        final String ret = SW_DealerDealStateStr(dealerDealStateCode);
        return ret;
    }

    // SW_GetBrokerIDfromSwapsWireID
    public String getBrokerIDfromSwapsWireID(final long dealID) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetBrokerIDfromSwapsWireID(lh, dealID, out);
        check(ret, "SW_GetBrokerIDfromSwapsWireID", dealID);
        return out[0];
    }

    // SW_BrokeredDealGetInfo
    public String brokeredDealGetInfo(final String brokerDealID) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_BrokeredDealGetInfo(lh, brokerDealID, out);
        check(ret, "SW_BrokeredDealGetInfo", brokerDealID);
        return out[0];
    }

    // SW_GetBrokerClearingStatus
    public String getBrokerClearingStatus(final String queryXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetBrokerClearingStatus(lh, queryXML, out);
        check(ret, "SW_GetBrokerClearingStatus", queryXML);
        return out[0];
    }

    // SW_BrokeredDealGetXML
    public String brokeredDealGetXML(final String brokerDealID, final int revisionNumber, final int contractVersion) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_BrokeredDealGetXML(lh, brokerDealID, revisionNumber, contractVersion, out);
        check(ret, "SW_BrokeredDealGetXML", brokerDealID, revisionNumber, contractVersion);
        return out[0];
    }

    // SW_BrokeredDealGetRecipientXML
    public String brokeredDealGetRecipientXML(final String brokerDealID, final int revisionNumber, final int contractVersion, final String recipientID) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_BrokeredDealGetRecipientXML(lh, brokerDealID, revisionNumber, contractVersion, recipientID, out);
        check(ret, "SW_BrokeredDealGetRecipientXML", brokerDealID, revisionNumber, contractVersion, recipientID);
        return out[0];
    }

    // SW_BrokeredDealGetPickupIdentityByRecipient
    public String brokeredDealGetPickupIdentityByRecipient(final String brokerDealID, final int revisionNumber, final int contractVersion, final String recipientID) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_BrokeredDealGetPickupIdentityByRecipient(lh, brokerDealID, revisionNumber, contractVersion, recipientID, out);
        check(ret, "SW_BrokeredDealGetPickupIdentityByRecipient", brokerDealID, revisionNumber, contractVersion, recipientID);
        return out[0];
    }

    // SW_BrokeredDealGetRejectReasonByRecipient
    public String brokeredDealGetRejectReasonByRecipient(final String brokerDealID, final int revisionNumber, final int contractVersion, final String recipientID) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_BrokeredDealGetRejectReasonByRecipient(lh, brokerDealID, revisionNumber, contractVersion, recipientID, out);
        check(ret, "SW_BrokeredDealGetRejectReasonByRecipient", brokerDealID, revisionNumber, contractVersion, recipientID);
        return out[0];
    }

    // SW_GetEndedDealInfo
    public String getEndedDealInfo(final int endedTimeStartSpan, final int endedTimeCloseSpan) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetEndedDealInfo(lh, endedTimeStartSpan, endedTimeCloseSpan, out);
        check(ret, "SW_GetEndedDealInfo", endedTimeStartSpan, endedTimeCloseSpan);
        return out[0];
    }

    // SW_GetEndedDealInfoEx
    public String getEndedDealInfoEx(final String queryXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetEndedDealInfoEx(lh, queryXML, out);
        check(ret, "SW_GetEndedDealInfoEx", queryXML);
        return out[0];
    }

    // SW_DealTerminate
    public String dealTerminate(final String brokerDealID) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealTerminate(lh, brokerDealID, out);
        check(ret, "SW_DealTerminate", brokerDealID);
        return out[0];
    }

    // SW_SubmitNewBackloadAndNovateDeal
    public String submitNewBackloadAndNovateDeal(final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitNewBackloadAndNovateDeal(lh, SWDML, privateDataXML, recipientsXML, messageText, out);
        check(ret, "SW_SubmitNewBackloadAndNovateDeal", SWDML, privateDataXML, recipientsXML, messageText);
        return out[0];
    }

    // SW_SubmitNewBrokeredDealEx
    public String submitNewBrokeredDealEx(final String recipientsXML, final String dealXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitNewBrokeredDealEx(lh, recipientsXML, dealXML, out);
        check(ret, "SW_SubmitNewBrokeredDealEx", recipientsXML, dealXML);
        return out[0];
    }

    // SW_ReSubmitNewBrokeredDealEx
    public String reSubmitNewBrokeredDealEx(final String recipientsXML, final String dealXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_ReSubmitNewBrokeredDealEx(lh, recipientsXML, dealXML, out);
        check(ret, "SW_ReSubmitNewBrokeredDealEx", recipientsXML, dealXML);
        return out[0];
    }

    // SW_SubmitNewDirectDeal
    public String submitNewDirectDeal(final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitNewDirectDeal(lh, SWDML, privateDataXML, recipientXML, messageText, out);
        check(ret, "SW_SubmitNewDirectDeal", SWDML, privateDataXML, recipientXML, messageText);
        return out[0];
    }

    // SW_SubmitNewPrimeBrokerDeal
    public String submitNewPrimeBrokerDeal(final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitNewPrimeBrokerDeal(lh, SWDML, privateDataXML, recipientsXML, messageText, out);
        check(ret, "SW_SubmitNewPrimeBrokerDeal", SWDML, privateDataXML, recipientsXML, messageText);
        return out[0];
    }

    // SW_SubmitDraftNewDeal
    public String submitDraftNewDeal(final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitDraftNewDeal(lh, SWDML, privateDataXML, recipientXML, messageText, out);
        check(ret, "SW_SubmitDraftNewDeal", SWDML, privateDataXML, recipientXML, messageText);
        return out[0];
    }

    // SW_SubmitDraftNewPrimeBrokerDeal
    public String submitDraftNewPrimeBrokerDeal(final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitDraftNewPrimeBrokerDeal(lh, SWDML, privateDataXML, recipientsXML, messageText, out);
        check(ret, "SW_SubmitDraftNewPrimeBrokerDeal", SWDML, privateDataXML, recipientsXML, messageText);
        return out[0];
    }

    // SW_SubmitBackloadDeal
    public String submitBackloadDeal(final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitBackloadDeal(lh, SWDML, privateDataXML, recipientXML, messageText, out);
        check(ret, "SW_SubmitBackloadDeal", SWDML, privateDataXML, recipientXML, messageText);
        return out[0];
    }

    // SW_SubmitNewMatchDeal
    public String submitNewMatchDeal(final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitNewMatchDeal(lh, SWDML, privateDataXML, recipientXML, messageText, out);
        check(ret, "SW_SubmitNewMatchDeal", SWDML, privateDataXML, recipientXML, messageText);
        return out[0];
    }

    // SW_SubmitNewDirectDealEx
    public String submitNewDirectDealEx(final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitNewDirectDealEx(lh, SWDML, privateDataXML, recipientXML, messageText, out);
        check(ret, "SW_SubmitNewDirectDealEx", SWDML, privateDataXML, recipientXML, messageText);
        return out[0];
    }

    // SW_SubmitCancellationEx
    public String submitCancellationEx(final String oldDealVersionHandle, final String cancellationFeeXML, final String privateDataXML, final String recipientXML, final String messageText, final int effectiveDate) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitCancellationEx(lh, oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText, effectiveDate, out);
        check(ret, "SW_SubmitCancellationEx", oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText, effectiveDate);
        return out[0];
    }

    // SW_SubmitCancellation
    public String submitCancellation(final String oldDealVersionHandle, final String cancellationFeeXML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitCancellation(lh, oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText, out);
        check(ret, "SW_SubmitCancellation", oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText);
        return out[0];
    }

    // SW_SubmitDraftCancellation
    public String submitDraftCancellation(final String oldDealVersionHandle, final String cancellationFeeXML, final String privateDataXML, final String recipientXML, final String messageText, final int effectiveDate) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitDraftCancellation(lh, oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText, effectiveDate, out);
        check(ret, "SW_SubmitDraftCancellation", oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText, effectiveDate);
        return out[0];
    }

    // SW_SubmitMatchCancellationEx
    public String submitMatchCancellationEx(final String oldDealVersionHandle, final String cancellationFeeXML, final String privateDataXML, final String recipientXML, final String messageText, final int effectiveDate) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitMatchCancellationEx(lh, oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText, effectiveDate, out);
        check(ret, "SW_SubmitMatchCancellationEx", oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText, effectiveDate);
        return out[0];
    }

    // SW_SubmitMatchCancellation
    public String submitMatchCancellation(final String oldDealVersionHandle, final String cancellationFeeXML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitMatchCancellation(lh, oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText, out);
        check(ret, "SW_SubmitMatchCancellation", oldDealVersionHandle, cancellationFeeXML, privateDataXML, recipientXML, messageText);
        return out[0];
    }

    // SW_SubmitNettingInstruction
    public String submitNettingInstruction(final String nettingInstructionXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitNettingInstruction(lh, nettingInstructionXML, out);
        check(ret, "SW_SubmitNettingInstruction", nettingInstructionXML);
        return out[0];
    }

    // SW_SubmitPostTradeEvent
    public String submitPostTradeEvent(final String oldDealVersionHandle, final String postTradeXML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitPostTradeEvent(lh, oldDealVersionHandle, postTradeXML, privateDataXML, recipientXML, messageText, out);
        check(ret, "SW_SubmitPostTradeEvent", oldDealVersionHandle, postTradeXML, privateDataXML, recipientXML, messageText);
        return out[0];
    }

    // SW_SubmitExit
    public String submitExit(final String oldDealVersionHandle, final String exitReason, final String privateDataXML, final String recipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitExit(lh, oldDealVersionHandle, exitReason, privateDataXML, recipientXML, messageText, out);
        check(ret, "SW_SubmitExit", oldDealVersionHandle, exitReason, privateDataXML, recipientXML, messageText);
        return out[0];
    }

    // SW_SubmitDraftAmendment
    public String submitDraftAmendment(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitDraftAmendment(lh, oldDealVersionHandle, SWDML, privateDataXML, recipientXML, messageText, out);
        check(ret, "SW_SubmitDraftAmendment", oldDealVersionHandle, SWDML, privateDataXML, recipientXML, messageText);
        return out[0];
    }

    // SW_SubmitUnderlying
    public String submitUnderlying(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitUnderlying(lh, oldDealVersionHandle, SWDML, privateDataXML, recipientXML, messageText, out);
        check(ret, "SW_SubmitUnderlying", oldDealVersionHandle, SWDML, privateDataXML, recipientXML, messageText);
        return out[0];
    }

    // SW_SubmitPrimeBrokerAmendment
    public String submitPrimeBrokerAmendment(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitPrimeBrokerAmendment(lh, oldDealVersionHandle, SWDML, privateDataXML, recipientsXML, messageText, out);
        check(ret, "SW_SubmitPrimeBrokerAmendment", oldDealVersionHandle, SWDML, privateDataXML, recipientsXML, messageText);
        return out[0];
    }

    // SW_SubmitNovation
    public String submitNovation(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitNovation(lh, oldDealVersionHandle, SWDML, privateDataXML, recipientsXML, messageText, out);
        check(ret, "SW_SubmitNovation", oldDealVersionHandle, SWDML, privateDataXML, recipientsXML, messageText);
        return out[0];
    }

    // SW_SubmitDraftNovation
    public String submitDraftNovation(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SubmitDraftNovation(lh, oldDealVersionHandle, SWDML, privateDataXML, recipientsXML, messageText, out);
        check(ret, "SW_SubmitDraftNovation", oldDealVersionHandle, SWDML, privateDataXML, recipientsXML, messageText);
        return out[0];
    }

    // SW_DealAmendDraft
    public String dealAmendDraft(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealAmendDraft(lh, oldDealVersionHandle, SWDML, privateDataXML, recipientXML, messageText, out);
        check(ret, "SW_DealAmendDraft", oldDealVersionHandle, SWDML, privateDataXML, recipientXML, messageText);
        return out[0];
    }

    // SW_DealAmendDraftPrimeBroker
    public String dealAmendDraftPrimeBroker(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String recipientsXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealAmendDraftPrimeBroker(lh, oldDealVersionHandle, SWDML, privateDataXML, recipientsXML, messageText, out);
        check(ret, "SW_DealAmendDraftPrimeBroker", oldDealVersionHandle, SWDML, privateDataXML, recipientsXML, messageText);
        return out[0];
    }

    // SW_DealDispute
    public String dealDispute(final String oldDealVersionHandle, final String disputeXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealDispute(lh, oldDealVersionHandle, disputeXML, out);
        check(ret, "SW_DealDispute", oldDealVersionHandle, disputeXML);
        return out[0];
    }

    // SW_DealSendChatMessage
    public String dealSendChatMessage(final String oldDealVersionHandle, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealSendChatMessage(lh, oldDealVersionHandle, messageText, out);
        check(ret, "SW_DealSendChatMessage", oldDealVersionHandle, messageText);
        return out[0];
    }

    // SW_DealPickup
    public String dealPickup(final String oldDealVersionHandle, final String privateDataXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealPickup(lh, oldDealVersionHandle, privateDataXML, out);
        check(ret, "SW_DealPickup", oldDealVersionHandle, privateDataXML);
        return out[0];
    }

    // SW_DealAccept
    public String dealAccept(final String oldDealVersionHandle, final String privateDataXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealAccept(lh, oldDealVersionHandle, privateDataXML, out);
        check(ret, "SW_DealAccept", oldDealVersionHandle, privateDataXML);
        return out[0];
    }

    // SW_DealAcceptAffirm
    public String dealAcceptAffirm(final String oldDealVersionHandle, final String privateDataXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealAcceptAffirm(lh, oldDealVersionHandle, privateDataXML, out);
        check(ret, "SW_DealAcceptAffirm", oldDealVersionHandle, privateDataXML);
        return out[0];
    }

    // SW_DealRelease
    public String dealRelease(final String oldDealVersionHandle, final String privateDataXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealRelease(lh, oldDealVersionHandle, privateDataXML, out);
        check(ret, "SW_DealRelease", oldDealVersionHandle, privateDataXML);
        return out[0];
    }

    // SW_DealRejectDK
    public String dealRejectDK(final String oldDealVersionHandle, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealRejectDK(lh, oldDealVersionHandle, messageText, out);
        check(ret, "SW_DealRejectDK", oldDealVersionHandle, messageText);
        return out[0];
    }

    // SW_DealRequestRevision
    public String dealRequestRevision(final String oldDealVersionHandle, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealRequestRevision(lh, oldDealVersionHandle, messageText, out);
        check(ret, "SW_DealRequestRevision", oldDealVersionHandle, messageText);
        return out[0];
    }

    // SW_DealReject
    public String dealReject(final String oldDealVersionHandle, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealReject(lh, oldDealVersionHandle, messageText, out);
        check(ret, "SW_DealReject", oldDealVersionHandle, messageText);
        return out[0];
    }

    // SW_DealTransfer
    public String dealTransfer(final String oldDealVersionHandle, final String privateDataXML, final String transferRecipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealTransfer(lh, oldDealVersionHandle, privateDataXML, transferRecipientXML, messageText, out);
        check(ret, "SW_DealTransfer", oldDealVersionHandle, privateDataXML, transferRecipientXML, messageText);
        return out[0];
    }

    // SW_DealWithdraw
    public String dealWithdraw(final String oldDealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealWithdraw(lh, oldDealVersionHandle, out);
        check(ret, "SW_DealWithdraw", oldDealVersionHandle);
        return out[0];
    }

    // SW_DealAcknowledge
    public String dealAcknowledge(final String oldDealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealAcknowledge(lh, oldDealVersionHandle, out);
        check(ret, "SW_DealAcknowledge", oldDealVersionHandle);
        return out[0];
    }

    // SW_DealPull
    public String dealPull(final String oldDealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealPull(lh, oldDealVersionHandle, out);
        check(ret, "SW_DealPull", oldDealVersionHandle);
        return out[0];
    }

    // SW_DealContinueWithNoPrimeBroker
    public String dealContinueWithNoPrimeBroker(final String oldDealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealContinueWithNoPrimeBroker(lh, oldDealVersionHandle, out);
        check(ret, "SW_DealContinueWithNoPrimeBroker", oldDealVersionHandle);
        return out[0];
    }

    // SW_DealDeleteDraft
    public String dealDeleteDraft(final String oldDealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealDeleteDraft(lh, oldDealVersionHandle, out);
        check(ret, "SW_DealDeleteDraft", oldDealVersionHandle);
        return out[0];
    }

    // SW_MatchDelete
    public String matchDelete(final String oldDealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_MatchDelete(lh, oldDealVersionHandle, out);
        check(ret, "SW_MatchDelete", oldDealVersionHandle);
        return out[0];
    }

    // SW_DealStateStr
    public String dealStateStr(final com.swapswire.sw_api.SW_DealState dealStateCode) {
        final String ret = SW_DealStateStr(dealStateCode);
        return ret;
    }

    // SW_DealStateStr
    public String dealStateStr(final int dealStateCode_int) {
        com.swapswire.sw_api.SW_DealState dealStateCode = com.swapswire.sw_api.SW_DealState.swigToEnum(dealStateCode_int);
        final String ret = SW_DealStateStr(dealStateCode);
        return ret;
    }

    // SW_QueryDefaultMisMatch
    public String queryDefaultMisMatch(final String dealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_QueryDefaultMisMatch(lh, dealVersionHandle, out);
        check(ret, "SW_QueryDefaultMisMatch", dealVersionHandle);
        return out[0];
    }

    // SW_DealGetSWML
    public String dealGetSWML(final String swmlVersion, final String dealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealGetSWML(lh, swmlVersion, dealVersionHandle, out);
        check(ret, "SW_DealGetSWML", swmlVersion, dealVersionHandle);
        return out[0];
    }

    // SW_DealGetSWDML
    public String dealGetSWDML(final String swdmlVersion, final String dealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealGetSWDML(lh, swdmlVersion, dealVersionHandle, out);
        check(ret, "SW_DealGetSWDML", swdmlVersion, dealVersionHandle);
        return out[0];
    }

    // SW_DealGetUnderlyingDealSWDML
    public String dealGetUnderlyingDealSWDML(final String swdmlVersion, final String dealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealGetUnderlyingDealSWDML(lh, swdmlVersion, dealVersionHandle, out);
        check(ret, "SW_DealGetUnderlyingDealSWDML", swdmlVersion, dealVersionHandle);
        return out[0];
    }

    // SW_GetSWDMLfromSWML
    public String getSWDMLfromSWML(final String inputSWML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetSWDMLfromSWML(lh, inputSWML, out);
        check(ret, "SW_GetSWDMLfromSWML", inputSWML);
        return out[0];
    }

    // SW_GetLongFromShortSWDMLEx
    public String getLongFromShortSWDMLEx(final String inputShortFormSWDML, final String recipientXML, final String swdmlVersion) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetLongFromShortSWDMLEx(lh, inputShortFormSWDML, recipientXML, swdmlVersion, out);
        check(ret, "SW_GetLongFromShortSWDMLEx", inputShortFormSWDML, recipientXML, swdmlVersion);
        return out[0];
    }

    // SW_CSVToXML
    public String CSVToXML(final String xmlType, final String xmlVersion, final String csvFamily, final String headerRow, final String dataRow) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_CSVToXML(lh, xmlType, xmlVersion, csvFamily, headerRow, dataRow, out);
        check(ret, "SW_CSVToXML", xmlType, xmlVersion, csvFamily, headerRow, dataRow);
        return out[0];
    }

    // SW_CSVGetColumn
    public String CSVGetColumn(final String csvFamily, final String columnName, final String headerRow, final String dataRow) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_CSVGetColumn(lh, csvFamily, columnName, headerRow, dataRow, out);
        check(ret, "SW_CSVGetColumn", csvFamily, columnName, headerRow, dataRow);
        return out[0];
    }

    // SW_CSVSetColumn
    public String CSVSetColumn(final String csvFamily, final String columnName, final String newValue, final String headerRow, final String dataRow) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_CSVSetColumn(lh, csvFamily, columnName, newValue, headerRow, dataRow, out);
        check(ret, "SW_CSVSetColumn", csvFamily, columnName, newValue, headerRow, dataRow);
        return out[0];
    }

    // SW_DealGetVersionHandle
    public String dealGetVersionHandle(final long dealID, final int majorVersion, final int privateVersion, final int side) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealGetVersionHandle(lh, dealID, majorVersion, privateVersion, side, out);
        check(ret, "SW_DealGetVersionHandle", dealID, majorVersion, privateVersion, side);
        return out[0];
    }

    // SW_DealGetAllVersionHandles
    public String dealGetAllVersionHandles(final long dealID, final int majorVersion, final int sides) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealGetAllVersionHandles(lh, dealID, majorVersion, sides, out);
        check(ret, "SW_DealGetAllVersionHandles", dealID, majorVersion, sides);
        return out[0];
    }

    // SW_DealGetMySide
    public int dealGetMySide(final long dealID, final int majorVersion) throws APIException {
        final int[] out = new int[1];
        final int ret = SW_DealGetMySide(lh, dealID, majorVersion, out);
        check(ret, "SW_DealGetMySide", dealID, majorVersion);
        return out[0];
    }

    // SW_DealGetDealState
    public int dealGetDealState(final String dealVersionHandle) throws APIException {
        final int[] out = new int[1];
        final int ret = SW_DealGetDealState(lh, dealVersionHandle, out);
        check(ret, "SW_DealGetDealState", dealVersionHandle);
        return out[0];
    }

    // SW_GetActiveDealInfo
    public String getActiveDealInfo() throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetActiveDealInfo(lh, out);
        check(ret, "SW_GetActiveDealInfo");
        return out[0];
    }

    // SW_GetParticipants
    public String getParticipants(final String participantQueryXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetParticipants(lh, participantQueryXML, out);
        check(ret, "SW_GetParticipants", participantQueryXML);
        return out[0];
    }

    // SW_GetLegalEntities
    public String getLegalEntities(final String legalEntityListQueryXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetLegalEntities(lh, legalEntityListQueryXML, out);
        check(ret, "SW_GetLegalEntities", legalEntityListQueryXML);
        return out[0];
    }

    // SW_GetMyInterestGroups
    public String getMyInterestGroups() throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetMyInterestGroups(lh, out);
        check(ret, "SW_GetMyInterestGroups");
        return out[0];
    }

    // SW_SetMyInterestGroups
    public void setMyInterestGroups(final String interestGroupXML) throws APIException {
        final int ret = SW_SetMyInterestGroups(lh, interestGroupXML);
        check(ret, "SW_SetMyInterestGroups", interestGroupXML);
    }

    // SW_GetMyBooks
    public String getMyBooks() throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetMyBooks(lh, out);
        check(ret, "SW_GetMyBooks");
        return out[0];
    }

    // SW_DealAffirm
    public String dealAffirm(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealAffirm(lh, oldDealVersionHandle, SWDML, privateDataXML, messageText, out);
        check(ret, "SW_DealAffirm", oldDealVersionHandle, SWDML, privateDataXML, messageText);
        return out[0];
    }

    // SW_MatchUpdate
    public String matchUpdate(final String oldDealVersionHandle, final String SWDML, final String privateDataXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_MatchUpdate(lh, oldDealVersionHandle, SWDML, privateDataXML, messageText, out);
        check(ret, "SW_MatchUpdate", oldDealVersionHandle, SWDML, privateDataXML, messageText);
        return out[0];
    }

    // SW_SubmitValuationReport
    public void submitValuationReport(final String inputCSV) throws APIException {
        final int ret = SW_SubmitValuationReport(lh, inputCSV);
        check(ret, "SW_SubmitValuationReport", inputCSV);
    }

    // SW_RequestValuationReport
    public String requestValuationReport(final int reportDate) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_RequestValuationReport(lh, reportDate, out);
        check(ret, "SW_RequestValuationReport", reportDate);
        return out[0];
    }

    // SW_DealGetPrivateBookingState
    public String dealGetPrivateBookingState(final long dealID, final int majorVersion, final int side) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealGetPrivateBookingState(lh, dealID, majorVersion, side, out);
        check(ret, "SW_DealGetPrivateBookingState", dealID, majorVersion, side);
        return out[0];
    }

    // SW_DealGetXML
    public String dealGetXML(final String dealVersionHandle, final String xmlVersion, final String xmlType) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealGetXML(lh, dealVersionHandle, xmlVersion, xmlType, out);
        check(ret, "SW_DealGetXML", dealVersionHandle, xmlVersion, xmlType);
        return out[0];
    }

    // SW_DealUpdate
    public String dealUpdate(final String dealIdentifier, final String inputXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealUpdate(lh, dealIdentifier, inputXML, out);
        check(ret, "SW_DealUpdate", dealIdentifier, inputXML);
        return out[0];
    }

    // SW_DealCheckEligibility
    public String dealCheckEligibility(final String dealVersionHandle, final String eligibilityType) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealCheckEligibility(lh, dealVersionHandle, eligibilityType, out);
        check(ret, "SW_DealCheckEligibility", dealVersionHandle, eligibilityType);
        return out[0];
    }

    // SW_BatchGetOutstanding
    public String batchGetOutstanding(final String batchName) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_BatchGetOutstanding(lh, batchName, out);
        check(ret, "SW_BatchGetOutstanding", batchName);
        return out[0];
    }

    // SW_BatchGetDetails
    public String batchGetDetails(final int batchId) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_BatchGetDetails(lh, batchId, out);
        check(ret, "SW_BatchGetDetails", batchId);
        return out[0];
    }

    // SW_BatchAck
    public void batchAck(final int batchId) throws APIException {
        final int ret = SW_BatchAck(lh, batchId);
        check(ret, "SW_BatchAck", batchId);
    }

    // SW_BatchUpdate
    public String batchUpdate(final String batchStatusXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_BatchUpdate(lh, batchStatusXML, out);
        check(ret, "SW_BatchUpdate", batchStatusXML);
        return out[0];
    }

    // SW_DealSinkGetSWML
    public String dealSinkGetSWML(final String swmlVersion, final long dealID, final int majorVersion, final int side) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealSinkGetSWML(lh, swmlVersion, dealID, majorVersion, side, out);
        check(ret, "SW_DealSinkGetSWML", swmlVersion, dealID, majorVersion, side);
        return out[0];
    }

    // SW_DealSinkDVHGetSWML
    public String dealSinkDVHGetSWML(final String swmlVersion, final String dealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealSinkDVHGetSWML(lh, swmlVersion, dealVersionHandle, out);
        check(ret, "SW_DealSinkDVHGetSWML", swmlVersion, dealVersionHandle);
        return out[0];
    }

    // SW_ExtractGetColumns
    public String extractGetColumns() throws APIException {
        final String[] out = new String[1];
        final int ret = SW_ExtractGetColumns(lh, out);
        check(ret, "SW_ExtractGetColumns");
        return out[0];
    }

    // SW_DealGetReportingStatus
    public String dealGetReportingStatus(final String queryXML, final long reserved) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealGetReportingStatus(lh, queryXML, reserved, out);
        check(ret, "SW_DealGetReportingStatus", queryXML, reserved);
        return out[0];
    }

    // SW_DealSetReportingStatus
    public String dealSetReportingStatus(final String reportingStatusUpdateXML, final long reserved) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealSetReportingStatus(lh, reportingStatusUpdateXML, reserved, out);
        check(ret, "SW_DealSetReportingStatus", reportingStatusUpdateXML, reserved);
        return out[0];
    }

    // SW_DealAllowDeClearingEx
    public String dealAllowDeClearingEx(final String dealListXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealAllowDeClearingEx(lh, dealListXML, out);
        check(ret, "SW_DealAllowDeClearingEx", dealListXML);
        return out[0];
    }

    // SW_GetLibraryVersion
    public int getLibraryVersion() throws APIException {
        final int ret = SW_GetLibraryVersion();
        check(ret, "SW_GetLibraryVersion");
        return ret;
    }

    // SW_GetLibraryVersionEx
    public String getLibraryVersionEx() throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetLibraryVersionEx(out);
        check(ret, "SW_GetLibraryVersionEx");
        return out[0];
    }

    // SW_ValidateXML
    public String validateXML(final String inputXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_ValidateXML(lh, inputXML, out);
        check(ret, "SW_ValidateXML", inputXML);
        return out[0];
    }

    // SW_TransformXML
    public String transformXML(final String xsltPath, final String xsltKey, final String inputXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_TransformXML(lh, xsltPath, xsltKey, inputXML, out);
        check(ret, "SW_TransformXML", xsltPath, xsltKey, inputXML);
        return out[0];
    }

    // SW_SendTelemetry
    public String sendTelemetry(final String commandXML) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_SendTelemetry(lh, commandXML, out);
        check(ret, "SW_SendTelemetry", commandXML);
        return out[0];
    }

    // SW_DealTransferAffirm
    public String dealTransferAffirm(final String oldDealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealTransferAffirm(lh, oldDealVersionHandle, out);
        check(ret, "SW_DealTransferAffirm", oldDealVersionHandle);
        return out[0];
    }

    // SW_DealCompare
    public String dealCompare(final String dealVersionHandle, final String dealVersionHandle2) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealCompare(lh, dealVersionHandle, dealVersionHandle2, out);
        check(ret, "SW_DealCompare", dealVersionHandle, dealVersionHandle2);
        return out[0];
    }

    // SW_DealCompareClosestMatch
    public String dealCompareClosestMatch(final String dealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealCompareClosestMatch(lh, dealVersionHandle, out);
        check(ret, "SW_DealCompareClosestMatch", dealVersionHandle);
        return out[0];
    }

    // SW_DealGetMatchInfo
    public String dealGetMatchInfo(final String oldDealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealGetMatchInfo(lh, oldDealVersionHandle, out);
        check(ret, "SW_DealGetMatchInfo", oldDealVersionHandle);
        return out[0];
    }

    // SW_GetMatchInfo
    public String getMatchInfo() throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GetMatchInfo(lh, out);
        check(ret, "SW_GetMatchInfo");
        return out[0];
    }

    // SW_DealSuggestMatch
    public String dealSuggestMatch(final String oldDealVersionHandle, final String cptyDealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealSuggestMatch(lh, oldDealVersionHandle, cptyDealVersionHandle, out);
        check(ret, "SW_DealSuggestMatch", oldDealVersionHandle, cptyDealVersionHandle);
        return out[0];
    }

    // SW_DealWithdrawSuggestMatch
    public String dealWithdrawSuggestMatch(final String oldDealVersionHandle, final String cptyDealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_DealWithdrawSuggestMatch(lh, oldDealVersionHandle, cptyDealVersionHandle, out);
        check(ret, "SW_DealWithdrawSuggestMatch", oldDealVersionHandle, cptyDealVersionHandle);
        return out[0];
    }

    // SW_MatchPush
    public String matchPush(final String cptyDealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_MatchPush(lh, cptyDealVersionHandle, out);
        check(ret, "SW_MatchPush", cptyDealVersionHandle);
        return out[0];
    }

    // SW_MatchPull
    public String matchPull(final String oldDealVersionHandle) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_MatchPull(lh, oldDealVersionHandle, out);
        check(ret, "SW_MatchPull", oldDealVersionHandle);
        return out[0];
    }

    // SW_GateCheckDispute
    public String gateCheckDispute(final String oldDealVersionHandle, final String recipientXML, final String messageText) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_GateCheckDispute(lh, oldDealVersionHandle, recipientXML, messageText, out);
        check(ret, "SW_GateCheckDispute", oldDealVersionHandle, recipientXML, messageText);
        return out[0];
    }


    static {
        logger.info("Loading MW API shared library");
        try {
            logger.fine("Loading MWAPI shared library");
            System.loadLibrary("SWAPILink");
            logger.fine("MWAPI shared library successfully loaded");
        } catch (final UnsatisfiedLinkError ex) {
            logger.severe("Failed to load MWAPI shared library: \n" + ex.toString() );
            APISession.ex = new IllegalStateException(ex);
        }
    }

    public APISession() {
        if (ex != null) {
            logger.severe("Previously failed to load MWAPI shared library: \n" + ex.toString() );
            throw ex;
        }
    }

    public void check(final int errorCode, final Object...args) throws APIException {
        logger.log(Level.FINE, "MW function called returned " + errorCode, args);
        if (errorCode < SWERR_Success) {
            final String[] errorMsg = new String[1];
            SW_GetLastErrorSpecificsEx(errorMsg);
            throw new APIException(errorCode, errorMsg[0], args);
        }
    }

    public Logger getLogger() {
        return logger;
    }

    public int getLoginHandle() {
        return lh;
    }

    public int getSessionHandle() {
        return sh;
    }

    public interface SW_DealNotifyExCallback {
        public void dealNotifyExCallback(SW_DealNotifyData data);
    }

    // SW_RegisterDealNotifyExCallback
    public void registerDealNotifyExCallback(final DealNotifyExCallback cfunc) throws APIException {
        final int ret = SW_RegisterDealNotifyExCallback(lh,
                new SW_DealNotifyExCallback() {
                    public void dealNotifyExCallback(SW_DealNotifyData data) {
                        cfunc.dealNotifyExCallback(
                            new DealNotifyDataHolder(
                                    data.getLh(),
                                    data.getClientData(),
                                    data.getBrokerId(),
                                    data.getDealId(),
                                    data.getMajorVer(),
                                    data.getMinorVer(),
                                    data.getPrivateVer(),
                                    data.getSide(),
                                    data.getPrevDVH(),
                                    data.getDvh(),
                                    data.getNewState().swigValue(),
                                    data.getNewStateStr(),
                                    data.getContractState(),
                                    data.getProductType(),
                                    data.getTradeAttrFlags()
                            )
                        );
                    }
                }
            );
        check(ret, "SW_RegisterDealNotifyExCallback", cfunc);
    }

    // SW_DealGetIDVersionsAndSide
    public DealVersionsAndSide dealGetIDVersionsAndSide(final String dealVersionHandle) throws APIException {
        final long[] dealID = new long[1];
        final int[] majorVersion = new int[1];
        final int[] privateVersion = new int[1];
        final int[] side = new int[1];
        final int ret = SW_DealGetIDVersionsAndSide(lh, dealVersionHandle, dealID, majorVersion, privateVersion, side);
        check(ret, "SW_DealGetIDVersionsAndSide", dealVersionHandle);
        return new DealVersionsAndSide(dealID[0], majorVersion[0], privateVersion[0], side[0]);
    }

    // SW_QueryDeals
    public String queryDeals(final String queryXML, final QueryCallback qc) throws APIException {
        final String[] out = new String[1];
        final int ret = SW_QueryDeals(lh, queryXML, out, qc);
        check(ret, "SW_QueryDeals", qc);
        return out[0];
    }

}

