#if defined (_MSC_VER) && _MSC_VER > 1000
#pragma once
#endif

#ifndef SW_API_ERRORCODES_H
#define SW_API_ERRORCODES_H

/** @file sw_api_errorcodes.h */

/**
 * @defgroup ErrorCodes API Error Codes
 * All API calls return one of the following values.
 */
/** @{ */

/**
 * The operation completed successfully.
 */
#define SWERR_Success                           (0)

/**
 * A connection to the server was successfully established.
 * See SW_Connect().
 * @note This code is not returned by SW_Connect, but is used
 *       in the session state callback to indicate the connection
 *       has now been made.
 */
#define SWERR_Connected                         (3)

/**
 * The system was unable to load the deal specified.  Check that the
 * deal identifier (dvh or deal id, side and version) is correct
 * and that you are permitted to access the deal.
 */
#define SWERR_UnknownDeal                       (-80)

/**
 * The trade id specified in the @c MatchingServiceTradeReference
 * element of the Clearing XML does not match the deal id of the
 * deal specified.
 */
#define SWERR_InconsistentDealIDs               (-104)

/**
 * The @c LchMatchedTradeReference element of the Clearing XML is missing
 * and is required when Accepting trades.
 */
#define SWERR_MissingClearingDealID             (-105)

/**
 * The deal has already been registered for clearing.
 *
 * In a recovery scenario, this can be considered success
 * if the intent was to register the deal for clearing.
 */
#define SWERR_AlreadyRegisteredForClearing      (-106)

/**
 * The deal has already been rejected for clearing.
 *
 * In a recovery scenario, this can be considered success
 * if the intent was to reject the deal for clearing.
 */
#define SWERR_AlreadyRejectedForClearing        (-107)

/**
 * The deal has already been decleared.
 *
 * In a recovery scenario, this can be considered success if the intent was to
 * declear the deal.
 */
#define SWERR_AlreadyDeCleared                  (-108)

/**
 * The deal is not eligible for clearing. The returned clearing status
 * XML contains details about why.
 */
#define SWERR_DealNotEligibleToClear            (-115)

/**
 * The deal version specified is not cleared, so the requested action is not available.
 */
#define SWERR_TradeIsNotCleared                 (-116)

/**
 * The specified side id is incorrect.  The side must exist and be a side
 * belonging to your participant.  See SW_DealGetMySide().
 */
#define SWERR_InvalidSide                       (-120)

/**
 * The specified private version is incorrect.  The private version must exist
 * within the given major version.
 */
#define SWERR_InvalidPrivateVersion             (-121)

/**
 * There is something wrong with the given XML.
 */
#define SWERR_InvalidXML                        (-184)

/**
 * You do not have permission to update batch id's.
 */
#define SWERR_NoUpdateBatchIDPermission         (-186)

/**
 * An unexpected internal error occurred.
 *
 * In the event that this error is returned, please contact
 * Customer Services for advice on resolving the problem.
 * Please ensure you have the output from @ref SW_GetLastErrorSpecificsEx
 * available.
 */
#define SWERR_InternalError                     (-300)

/**
 * Connection to service lost.
 *
 * It was either not possible to connect to the service, or
 * the existing connection to the service was lost.  See SW_Connect().
 * This can occur as a result of a network issue or service outage.
 */
#define SWERR_LostConnection                    (-301)

/**
 * The user has been logged out.
 * A user may be logged out either by logging in elsewhere or calling SW_Logout().
 */
#define SWERR_UserLoggedOut                     (-306)

/**
 * The session or login handle passed to the API function is invalid.
 *
 * The handle refers to a session that does not exist, this may be because
 * the session has been disconnected.
 */
#define SWERR_InvalidHandle                     (-350)

/**
 * The first recipient is invalid.
 *
 * The first recipient in the broker trade resubmission does not match
 * any of the recipients in the initial trade submission.  Brokers
 * must resubmit amended trades to the original parties, although the
 * parties may be reversed.
 */
#define SWERR_BadRecip1                         (-355)

/**
 * The second recipient is invalid.
 *
 * The second recipient in the broker trade resubmission does not match
 * any of the recipients in the initial trade submission.  Brokers
 * must resubmit amended trades to the original parties, although the
 * parties may be reversed.
 */

#define SWERR_BadDirection                      (-361)
#define SWERR_BadRecip2                         (-356)

/**
 * The recipient id of both recipients cannot be the same.  Ensure that
 * recipient ids are unique.
 */
#define SWERR_BadRecipCombination               (-357)

/**
 * An error occurred accessing, updating or creating temporary files.
 *
 * Details of the error can be found by calling @ref SW_GetLastErrorSpecificsEx.
 * Check that sufficient space and rights exist for the process to create
 * the temporary files it needs.
 * @note This error is only returned by @ref SW_LoginOnBehalf and @ref SW_Login.
 */
#define SWERR_TempDirFail                       (-400)

/**
 * One of the parameters specified on the API call was invalid.
 */
#define SWERR_BadParameter                      (-401)

/**
 * The recipient ids in the trade XML must match the recipient ids
 * in the recipient(s) XML.
 */
#define SWERR_RecipIDMismatch                   (-403)

/**
 * The client API version is no longer supported by the current MarkitWire system.
 *
 * This error may occur if you fail to upgrade your client software in
 * accordance with the notices from MarkitWire customer services. Alternately
 * you may have a feature enabled that requires a later client version
 * (for example, partial novations or new product types). See the output
 * of @ref SW_GetLastErrorSpecificsEx for details.
 */
#define SWERR_SoftwareMismatch                  (-500)

/**
 * The username or password is wrong. The call may be retried with corrected
 * logon details.
 * @note This error is only returned by @ref SW_LoginOnBehalf, @ref SW_Login
 * and @ref SW_ChangePassword.
 */
#define SWERR_WrongUsernameOrPassword           (-502)

/**
 * A user is already logged in to the given session.
 *
 * The API supports multiple sessions, however only one user may be logged
 * into a given session any any time.  You may log out and log in a different
 * user, or open another session and log the user into that session.
 */
#define SWERR_AlreadyLoggedIn                   (-503)

/**
 * The users password has expired and must be changed.
 * @note This error is only returned by @ref SW_LoginOnBehalf and @ref SW_Login.
 */
#define SWERR_PasswordExpired                   (-505)

/**
 * The user is not allowed to access the service from this location.
 *
 * Access to the service is limited to particular sites or location
 * by IP (Internet) address.  Contact Customer Services to have a new
 * location added, or access the service from an allowed location.
 * @note This error is only returned by @ref SW_LoginOnBehalf and @ref SW_Login.
 */
#define SWERR_InvalidLocation                   (-506)

/**
 * The maximum number of concurrent logins has been reached.
 *
 * Currently it is only possible to log in to the system once. This limit may
 * be raised in a future version of the API.
 * @note This error is only returned by @ref SW_LoginOnBehalf and @ref SW_Login.
 */
#define SWERR_LoginLimitReached                 (-507)

/**
 * The users account has been locked out.
 *
 * An account is usually locked after a certain number if failed login
 * attempts (e.g. invalid passwords), or may have been locked out by a
 * system administrator. Contact customer services to reenable access to
 * your account.
 * @note This error is only returned by @ref SW_LoginOnBehalf and @ref SW_Login.
 */
#define SWERR_AccountLocked                     (-508)

/**
 * The server has failed to respond within the timeout.
 *
 * You may need to increase the timeout specificed in SW_Connect(),
 * or there may be a problem with the system or the network connection.
 */
#define SWERR_Timeout                           (-509)
/**
 * The broker deal id given is unknown to the system.
 */
#define SWERR_UnknownID                         (-513)
/**
 * The deal id given is not unique.
 *
 * Some trade ids (eg, Broker deal ids, USIs) must be unique. This error is returned if
 * an id that has already been used is given when submitting, affirming or updating a deal.
 */
#define SWERR_DuplicateID                       (-514)
#define SWERR_UnknownRecipID                    (-516)
/**
 * The specified userID or groupID was not recognised as a valid user/group
 * identifier in the specified participant.
 *
 * This error is returned when an unknown user or group is given in
 * deal XML, or one of the various addressing XML formats
 * (such as <a href="./xmlref.html#Recipient">Recipient XML</a>).
 * You may also receive this error if the user or group is correct,
 * but you have placed a user in a @c GroupId element or a group
 * in a @c UserId element incorrectly. Re-address the deal or correct
 * the addressing XML and try the action again.
 */
#define SWERR_UnknownUserOrGroup                (-518)
/**
 * An invalid Legal Entity was specified for a Participant.
 */
#define SWERR_InvalidLegalEntity                (-520)
#define SWERR_DupUserOrGroup                    (-521)
#define SWERR_SubmitResubmitFail                (-522)
#define SWERR_ChangedParticipant                (-529)
#define SWERR_InvalidBrokerCode                 (-534)
#define SWERR_UnknownDealOrRecipID              (-535)
#define SWERR_NoLegalEntityPerm                 (-540)
#define SWERR_EmptyGroup                        (-541)
#define SWERR_AllDeactivated                    (-542)
/**
 * Brokers must have a non-blank description.
 * This error is currently only returned when submitting brokered deals.
 */
#define SWERR_NoDescription                     (-543)
#define SWERR_CannotSubmitToLegalEntity         (-544)
#define SWERR_SingleSidedParticipants           (-545)
#define SWERR_RecipientsNotPermissioned         (-546)

/**
 * Broker has no legal entities configured.
 *
 * The system requires that brokers are configured for a single legal entity only.
 * Contact Customer Services to have this rectified.
 */
#define SWERR_BrokerHasNoPermittedLegalEntity   (-547)

/**
 * Broker has multiple legal entities configured.
 *
 * The system requires that brokers are configured for a single legal entity only.
 * Contact Customer Services to have this rectified.
 */
#define SWERR_BrokerHasTooManyPermittedLegalEntity (-548)

/**
 * The current session is no longer logged in.
 *
 * Sessions are logged out under the following conditions:
 * - The user logs in through another session or application.
 * - The application using the API calls SW_Logout().
 * - A communication error or timeout occurs on the API connection.
 * The final case will cause any registered session state callback to
 * be called by the API. You may receive this error from an API call
 * prior to the callback firing due to unavoidable race/timing issues.
 */
#define SWERR_NotLoggedIn                       (-549)

#define SWERR_InactiveLegalEntity               (-551)
#define SWERR_CannotInitiateTrade               (-552)
#define SWERR_InactiveParticipant               (-553)

#define SWERR_AllDisabled                       (-559)
#define SWERR_AllNotExternallyVisible           (-560)
#define SWERR_NoSingleSideTrade                 (-563)
#define SWERR_NoTradeBookPerm                   (-564)
#define SWERR_NoTradeEntityPerm                 (-565)
#define SWERR_NoAmendPerm                       (-567)
#define SWERR_PermissionError                   (-570)
#define SWERR_CannotTerminate                   (-571)
#define SWERR_CannotSubmitToMatchingUsers       (-574)
#define SWERR_NoRecipients                      (-577)
#define SWERR_NoNonStandardDefaultPerm          (-578)
/**
 * Something is wrong with the deal submitted.
 * This error means that that the deal has failed business logic
 * validation, for example, an unsupported tenor has been provided.
 * See the output of @ref SW_GetLastErrorSpecificsEx() for details on the
 * issue. The action may be retried once the deal has been corrected.
 */
#define SWERR_InvalidDeal                       (-579)
#define SWERR_NotAPIPermissioned                (-581)
/**
 * The given password is invalid.
 * See @ref SW_ChangePassword for the constraints imposed on user passwords.
 * @note This error is only returned by @ref SW_LoginOnBehalf, @ref SW_Login
 * and @ref SW_ChangePassword.
 */
#define SWERR_PasswordInvalid                   (-582)
#define SWERR_RecipientMismatch                 (-583)
#define SWERR_RecipientIdNotFound               (-584)
/**
 * You many not transfer a deal to yourself.
 *
 * This error code is only returned by @ref SW_DealTransfer.
 */
#define SWERR_DealTransferToSelf                (-585)
#define SWERR_NotDataSourcePermissioned         (-586)
/**
 * @deprecated The API will no longer return ithis value, so client code should not reference it
 */
#define SWERR_OperationFailed                   (-587)
/** The given RE/RO submission ID is NULL or unknown to the system. */
#define SWERR_SubmissionIDNotValid              (-589)
/**
 * The action is not available because the trade is pre-accepted.
 *
 * You cannot call SW_DealAccept(), nor SW_DealAcceptAffirm() on pre-accepted trades,
 * call SW_DealAffirm() instead if you wish to progress them.
 */
#define SWERR_PreAcceptedAcceptAffirm           (-590)
#define SWERR_NoPermissionedUsers               (-593)
#define SWERR_CannotRequestRevision             (-594)
/**
 * The account being logged in is inactive. Please contact customer services
 * to activate it.
 * @note This error is only returned by @ref SW_LoginOnBehalf, @ref SW_Login
 * and @ref SW_ChangePassword.
 */
#define SWERR_AccountInactive                   (-596)
#define SWERR_NoIndependentAmountPerm           (-604)
#define SWERR_PrivateDataConflict               (-605)
#define SWERR_NoSubmitMatchPerm                 (-606)
#define SWERR_AcctInactDeactPar                 (-607)

/**
 * The counterparty is not able to receive strategy trades.
 *
 * Counterparties must be explicitly configured to be able to receive
 * strategy trades. Contact customer services for further details.
 */
#define SWERR_CounterpartyCantRecvStrategy      (-661)

/**
 * The given @ref SW_DealVersionHandle (DVH) is out of date.
 *
 * Some actions can only be performed on the latest version of the deal (or
 * latest DVH within a major version for some actions).  If the DVH is out of
 * date (because another action has been performed on it), your action can no
 * longer be performed.
 *
 * Since this error indicates that the deal has changed, your application
 * should ensure that the action it was performing is still valid and
 * desirable before retrying with a later DVH.  This should include both
 * a call to @ref SW_DealGetDealState() to check the new state of the trade
 * and a call to @ref SW_DealGetSWML() to check the economics of the trade.
 * For example, it is possible that the counterparty has @ref SW_DealPull()'d
 * the deal and @ref SW_DealAffirm()'d with changed economics, so simply
 * ensuring that the deal state is still applicable is not sufficient (in
 * this case the sate could be SWDS_AwaitingMyAction both before and
 * after the pull/affirm pair, however the economics of the deal may have
 * changed).  It is also possible that the counterparty has left the deal
 * in a state where your originally desired action is no longer available.
 * For example if prior to this error the deal state was SWDS_AwaitingMyAction
 * and you were attempting to affirm, that after the error the deal may be
 * withdrawn or in some other state where affirm is no longer available.
 *
 * A DVH for the latest version of a deal at a particular point in time can
 * be obtained by passing @ref SWS_LATESTVERSION to
 * @ref SW_DealGetVersionHandle().
 *
 * @sa dealver.
 */
#define SWERR_HandleNotLatest                   (-662)

/**
 * An unsupported XML version was requested for the given trade.
 *
 * Some functions allow the caller to specify an XML version, for example
 * @ref SW_DealGetSWDML. This error code is returned if the version requested
 * cannot be provided for the trade given.
 *
 * This can occur if the XML (e.g. FpML, SWML, SWDML, SWBML etc) version
 * requested is not valid for the asset class of the deal given or if the
 * deal contains attributes or features that are not supported in that
 * version of the XML.
 *
 * Requesting the same deal in a different version of XML where the asset
 * class or attributes/features are supported may succeed.
 *
 * If your application does not support later versions of the trade
 * representation it may choose to transfer this deal for processing
 * with tc_client/EU Web or withdraw/reject the trade until such time that
 * support for the required reature is added to your application to
 * enable automatic processing.
 *
 * Note that @ref SWERR_BadParameter will be returned for
 * unknown versions; this error is returned when the version is valid, but
 * not for the particular set of inputs given in the call or resulting
 * xml for the call.
 */
#define SWERR_UnsupportedXmlVersion             (-665)
#define SWERR_DealTransfereeNotLoggedIn         (-667)
#define SWERR_DealTransfereeNotPrivileged       (-670)
#define SWERR_DealTransfereeAlreadyActive       (-671)
/**
 * The specified participant is unknown in MarkitWire or you are not permissioned to submit to it.
 */
#define SWERR_UnknownParticipant                (-672)
#define SWERR_NoPrimeBrokerRecipients           (-678)
#define SWERR_NoBreakOverridePerm               (-679)
#define SWERR_NotEligibleForClearing            (-680)
#define SWERR_BackloadedTradeAlreadyExists      (-681)
#define SWERR_NoTradePerm                       (-700)
#define SWERR_NoCancelPerm                      (-702)
#define SWERR_NoReleaseOwnPerm                  (-703)
#define SWERR_NoTradeProductPerm                (-704)
#define SWERR_NoReleaseOtherPerm                (-705)
#define SWERR_NoPreSendTransferPerm             (-706)
#define SWERR_NoPreSendTransferAffirmPerm       (-707)
#define SWERR_NoInitiateClearingPerm            (-708)
#define SWERR_NoPartialNovationPerm             (-712)
#define SWERR_NoOneStepPermission               (-714)

/**
 * The attempted Action is not Available for your user type.
 *
 * Some actions are not available for selected user types. For example,
 * @ref SW_DealPickup is not available if your user type is "Always Input (AI)".
 * In this case you should take some alternative action, such as submitting
 * a deal to matching.  Your user type can be determined by calling
 * @ref SW_GetMyUserInfo and checking the type attribute on the @c UserId
 * node of the returned XML.
 */
#define SWERR_WrongUserType                     (-715)
#define SWERR_NoMatchFunctionPerm               (-716)
#define SWERR_CannotSubmitToMatcher             (-718)

/**
 * The attempted action is not available on the deal in its current state.
 *
 * Some actions are only available if the deal is in the correct state.
 * For example, you cannot release a deal before it has been affirmed,
 * nor pickup a deal that has already been picked up.
 *
 * When you receive this error, the action will not succeed until the
 * deal changes state. You should not therefore not retry the action
 * until a new notification for the deal is received.
 */
#define SWERR_ActionUnavailable                 (-719)
#define SWERR_CanOnlySubmitToMatcher            (-720)
#define SWERR_InternalTradeIdRequired           (-721)
#define SWERR_InitiateClearingFailed            (-763)
/**
 * The user does not have the correct permissions to perform the requested action.
 */
#define SWERR_InvalidPermissions                (-800)
/**
 * The batch id passed is unknown to the system.
 * @note This error is only returned by @ref SW_BatchAck.
 */
#define SWERR_InvalidBatchID                    (-803)
/**
 * Another party or user is modifying the deal.
 *
 * Retry the action again every few seconds until succeeds or
 * fails with a different error.
 *
 * You may receive this error from any API call. Only one action
 * may be processed on a deal at a time. In the event that the deal
 * is being modified by the system or another user, the system will
 * retry your action several times before returning this error.
 *
 * You can always retry the action when you receive this error,
 * until it succeeds or fails with a different error code. It is
 * recommended that you wait a few seconds before retrying to
 * allow the other action to finish.
 */
#define SWERR_TradeBusyOrOutOfDate              (-807)
#define SWERR_NoAllocatePerm                    (-853)
/**
 * No recipients should be specified when amending a post-send draft.
 * @note This error is only returned by @ref SW_DealAmendDraft.
 */
#define SWERR_RecipientsNotRequired             (-858)
/**
 * Something was wrong with the Exercise data submitted. For example, the
 * number of options specified is incorrect.
 * @note This error is only returned by @ref SW_SubmitPostTradeEvent where the action is an exercise.
 */
#define SWERR_InvalidExercise                   (-862)

/**
 * Submitting a deal with Amortisation is not possible as the user does not have permission.
 *
 * To submit a deal with an Amortisation Schedule, the user
 * must have the "Amortising" permission.
 */
#define SWERR_NoAmortisationPerm                (-869)

/**
 * The submitted strategy trade is in an incomplete state.  There are legs of the trade
 * missing which must be present in order for further action to be taken with this deal,
 * i.e. picking up or affirming,
 */
#define SWERR_BrokerStrategyTradeIsIncomplete   (-870)

/**
 * The user you are attempting to login on behalf of does not exist or you
 * are not permissioned to log in on their behalf.
 * @note This error is only returned by @ref SW_LoginOnBehalf.
 */
#define SWERR_WrongUsernameOrNotPermissioned    (-871)

/**
 * The account you are attempting to login on behalf of is inactive.
 */
#define SWERR_OnBehalfAccountInactive           (-872)

/**
 * The trade was submitted to an interoperable participant but was not eligible for interoperability.
 */
#define SWERR_NotEligibleForInterop             (-874)

/**
 * The deal is not yet in a state where you can update it.
 *
 * This error differs from @ref SWERR_ActionUnavailable in that
 * a future counterparty or system action may allow your action to
 * succeed. However, you will not receive a notification for the
 * action that is required. You may therefore wish to wait some
 * time and try the action again.
 *
 * For example, this error may occur if a post trade event has been
 * initiated by a counterparty, but not picked up or rejected by
 * your side. Any further action on the deal cannot occur until
 * the deal is picked up/rejected, but if another user in your
 * participant picks up the deal, you will not receive a notification
 * of that event.
 */
#define SWERR_ActionNotYetAvailable             (-876)

/** The API call is not implemented.
 * This error can only be raised by the thin API (not the normal MW fat API).
 * It will only be raised for a very small number of
 * deprecated or private API calls.
 */
#define SWERR_NotImplemented                    (-877)

/** The service to which you attempted a login has been temporarily disabled.
 * The service has been disabled for administrative reasons, please try again later.
 */
#define SWERR_ServiceDisabled                   (-878)

/** The package trade child you trying to create is invalid.
 * Please correct the fields in error messgae and then try again.
 */
#define SWERR_InvalidPackageChild               (-879)

/** The book provided in the recipient xml for a brokered trade was not found.
 */
#define SWERR_NoTradeBook                       (-880)

/**
 * The deal is not eligible for settlement
 */
#define SWERR_DealNotValidForSettlementAgency   (-881)

/**
 * Single Sided Participant Clearing is not supported
 */
#define SWERR_SingleSidedParticipantNotSupported (-882)

/** INCREMENT SWERR_LAST WHEN ADDING NEW ERROR CODES!
 */
#define SWERR_LAST                              (-883)

/**
 * @def SW_ALLOW_DEPRECATED_ERROR_CODES
 * Allow use of deprecated error codes
 *
 * To allow existing code to compile, but with unreachable error handling
 * define SW_ALLOW_DEPRECATED_ERROR_CODES
 */
#if 0
#define SW_ALLOW_DEPRECATED_ERROR_CODES
#endif

#ifdef SW_ALLOW_DEPRECATED_ERROR_CODES

/**
 * SWERR_BadVersion (-70) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_BadVersion                        (-70)

/**
 * SWERR_BadXML (-100) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_BadXML                            (SWERR_InvalidXML)

/**
 * SWERR_InvalidSWMLVersion (-102) has been replaced by SWERR_UnsupportedXmlVersion.
 * See @ref swmlversions for details on selecting SWML versions an error code
 * handling for functions that take SWML version numbers.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidSWMLVersion                (SWERR_UnsupportedXmlVersion)

/**
 * SWERR_UpdateFailed (-110)  has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_UpdateFailed                      (SWERR_InvalidDeal)

/**
 * SWERR_UpdateBatchOnNonIRS (-117) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_UpdateBatchOnNonIRS               (-117)

/**
 * SWERR_InvalidMajorVersion (-122) has been replaced by SWERR_BadParameter.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidMajorVersion               (SWERR_BadParameter)

/**
 * SWERR_InvalidDealId (-130) has been replaced by SWERR_BadParameter.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidDealId                     (SWERR_BadParameter)

/**
 * SWERR_RuntimeException (-150) has been replaced by SWERR_InternalError.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_RuntimeException                  (SWERR_InternalError)

/**
 * SWERR_DataConversion (-180) has been replaced by SWERR_InternalError.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DataConversion                    (SWERR_InternalError)

/**
 * SWERR_ServerUp (-302) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_ServerUp                          (-302)

/**
 * SWERR_ServerDown (-303) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_ServerDown                        (-303)

/**
 * SWERR_SystemMessage (-304) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_SystemMessage                     (-304)

/**
 * SWERR_InternalHandlerError (-305) has been replaced by SWERR_InternalError.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InternalHandlerError              (SWERR_InternalError)

/**
 * SWERR_PollingNotAllowed (-307) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_PollingNotAllowed                 (-307)

/**
 * SWERR_PollIntervalTooLong (-308) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_PollIntervalTooLong               (-308)

/**
 * SWERR_NoConnection (-309) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_NoConnection                      (-309)

/**
 * SWERR_InvalidParameter (-352) has been replaced by SWERR_BadParameter.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidParameter                  (SWERR_BadParameter)

/**
 * SWERR_BadID (-353) has been replaced by SWERR_BadParameter.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_BadID                             (SWERR_BadParameter)

/**
 * SWERR_BadXMLContent (-358) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_BadXMLContent                     (SWERR_InvalidXML)

/**
 * SWERR_InvalidDates (-359) has been replaced by SWERR_BadParameter.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidDates                      (SWERR_BadParameter)

/**
 * SWERR_InvalidDateRange (-360) has been replaced by SWERR_BadParameter.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidDateRange                  (SWERR_BadParameter)

/**
 * SWERR_TradeIDTooLong (-402) has been replaced by SWERR_BadParameter.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_TradeIDTooLong                    (SWERR_BadParameter)

/**
 * SWERR_DealIDMismatch (-404) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_DealIDMismatch                    (-404)

/**
 * SWERR_DtdPullDownFail (-405) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_DtdPullDownFail                   (-405)

/**
 * SWERR_FunctionNotSupported (-406) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_FunctionNotSupported              (-406)

/**
 * SWERR_XSLTError (-407) has been replaced by SWERR_InternalError.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_XSLTError                         (SWERR_InternalError)

/**
 * SWERR_ResourceIdNotAvailable (-408) has been replaced by SWERR_InternalError.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_ResourceIdNotAvailable            (SWERR_InternalError)

/**
 * SWERR_LegIDTooLong (-409) has been replaced by SWERR_BadParameter.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_LegIDTooLong                      (SWERR_BadParameter)

/**
 * SWERR_LegIDMismatch (-410) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_LegIDMismatch                     (-410)

/**
 * SWERR_InvalidLegID (-411) has been replaced by SWERR_BadParameter.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidLegID                      (SWERR_BadParameter)

/**
 * SWERR_XslPullDownFail (-412) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_XslPullDownFail                   (-412)

/**
 * SWERR_ConnectionFailed (-501) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_ConnectionFailed                  (-501)

/**
 * SWERR_LoginFailed (-502) has been replaced by SWERR_WrongUsernameOrPassword.
 * The API never differentiated between the invalid username and invalid password,
 * so SWERR_UnknownUser, SWERR_LoginFailed and SWERR_WrongOldPassword were interchangable.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_LoginFailed                       (SWERR_WrongUsernameOrPassword)

/**
 * SWERR_UnknownUser (-504) has been replaced by SWERR_WrongUsernameOrPassword.
 * The API never differentiated between the invalid username and invalid password,
 * so SWERR_UnknownUser, SWERR_LoginFailed and SWERR_WrongOldPassword were interchangable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_UnknownUser                       (SWERR_WrongUsernameOrPassword)

/**
 * SWERR_CannotLogout (-510) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_CannotLogout                      (-510)

/**
 * SWERR_WrongDealState (-511) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_WrongDealState                    (SWERR_ActionUnavailable)

/**
 * SWERR_BadDeal (-512) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_BadDeal                           (SWERR_InvalidDeal)

/**
 * SWERR_UnknownVersion (-515) has been replaced by SWERR_UnknownDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_UnknownVersion                    (SWERR_UnknownDeal)

/**
 * SWERR_UnknownSwapsWireID (-517) has been replaced by SWERR_UnknownDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_UnknownSwapsWireID                (SWERR_UnknownDeal)

/**
 * SWERR_CurrencyMismatch (-523) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_CurrencyMismatch                  (SWERR_InvalidDeal)

/**
 * SWERR_DealNotDraft (-524) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealNotDraft                      (SWERR_ActionUnavailable)

/**
 * SWERR_ChatUnavailable (-525) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_ChatUnavailable                   (SWERR_ActionUnavailable)

/**
 * SWERR_AttributeReadOnly (-526) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_AttributeReadOnly                 (SWERR_InvalidDeal)

/**
 * SWERR_ShortFormRequired (-527) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_ShortFormRequired                 (SWERR_InvalidXML)

/**
 * SWERR_DealPullUnavailable (-528) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealPullUnavailable               (SWERR_ActionUnavailable)

/**
 * SWERR_TradeSourceMismatch (-530) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_TradeSourceMismatch               (SWERR_InvalidDeal)

/**
 * SWERR_SWBMLVersionMismatch (-531) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_SWBMLVersionMismatch              (SWERR_InvalidDeal)

/**
 * SWERR_NotPermissioned (-532) has been replaced by SWERR_PermissionError.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_NotPermissioned                   (SWERR_PermissionError)

/**
 * SWERR_WrongOldPassword (-533) has been replaced by SWERR_WrongUsernameOrPassword.
 * The API never differentiated between the invalid username and invalid password,
 * so SWERR_UnknownUser, SWERR_LoginFailed and SWERR_WrongOldPassword were interchangable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_WrongOldPassword                  (SWERR_WrongUsernameOrPassword)

/**
 * SWERR_BadDate (-536) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_BadDate                           (SWERR_InvalidDeal)

/**
 * SWERR_NoTradeSourcePermission (-537) has been replaced by SWERR_PermissionError.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_NoTradeSourcePermission           (SWERR_PermissionError)

/**
 * SWERR_AmendUnavailable (-538) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_AmendUnavailable                  (SWERR_ActionUnavailable)

/**
 * SWERR_CancelUnavailable (-539) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_CancelUnavailable                 (SWERR_ActionUnavailable)

/**
 * SWERR_SystemDown (-550) has been replaced by SWERR_Timeout.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_SystemDown                        (SWERR_Timeout)

/**
 * SWERR_ProductTypeMismatch (-553) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_ProductTypeMismatch               (SWERR_InvalidDeal)

/**
 * SWERR_DocTypeMismatch (-555) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DocTypeMismatch                   (SWERR_InvalidDeal)

/**
 * SWERR_ContractDefMismatch (-556) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_ContractDefMismatch               (SWERR_InvalidDeal)

/**
 * The password has been changed recently.
 *
 * Passwords cannot be changed multiple times in rapid succession for security reasons.
 * If you believe your password has been compromised, please contact Customer Services.
 * @note This error is only returned by @ref SW_LoginOnBehalf and @ref SW_Login.
 */
#define SWERR_PasswordRecentlyChanged           (-557)

/**
 * The password has already been used recently.
 * For security reasons, you cannot reuse a recently used password.
 * @note This error is only returned by @ref SW_ChangePassword.
 */
#define SWERR_PasswordInHistory                 (-558)

/**
 * SWERR_RecentlyChanged (-557) has been replaced by the more descriptive
 * SWERR_PasswordRecentlyChanged, although its value has not changed.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_RecentlyChanged                   (SWERR_PasswordRecentlyChanged)

/**
 * SWERR_UserNotPermissionedForLegalEntity (-561) has been replaced by SWERR_NoTradeEntityPerm.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_UserNotPermissionedForLegalEntity (SWERR_NoTradeEntityPerm)

/**
 * SWERR_InvalidRepresentation (-562) is no longer used.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidRepresentation             (-562)

/**
 * SWERR_UnknownSecurity (-566) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_UnknownSecurity                   (SWERR_InvalidDeal)

/**
 * SWERR_PremiumMismatch (-568) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_PremiumMismatch                   (SWERR_InvalidDeal)

/**
 * SWERR_StateError (-569) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_StateError                        (SWERR_ActionUnavailable)

/**
 * SWERR_ProductEquityMismatch (-572) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_ProductEquityMismatch             (SWERR_InvalidDeal)

/**
 * SWERR_UnableToPerformAction (-573) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_UnableToPerformAction             (SWERR_ActionUnavailable)

/**
 * SWERR_PremiumPercMismatch (-575) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_PremiumPercMismatch               (SWERR_InvalidDeal)

/**
 * SWERR_StrikePercMismatch (-576) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_StrikePercMismatch                (SWERR_InvalidDeal)

/**
 * SWERR_TradeValidationError (-580) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_TradeValidationError              (SWERR_InvalidDeal)

/**
 * SWERR_DatabaseError (-588) is no longer used.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DatabaseError                     (-588)

/**
 * SWERR_InvalidParticipant (-591) has been replaced by SWERR_UnknownParticipant.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidParticipant                (SWERR_UnknownParticipant)

/**
 * SWERR_GroupNotInParticipant (-592) has been replaced by SWERR_UnknownUserOrGroup.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_GroupNotInParticipant             (SWERR_UnknownUserOrGroup)

/**
 * SWERR_CannotAccept (-595) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_CannotAccept                      (SWERR_ActionUnavailable)

/**
 * SWERR_PasswordChangeFail (-597) is no longer used.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_PasswordChangeFail                (-597)

/**
 * SWERR_UserNotPermissioned (-598) is no longer used.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_UserNotPermissioned               (-598)
/**
 * SWERR_GroupNotPermissioned (-599) is no longer used.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_GroupNotPermissioned              (-599)

/**
 * SWERR_CacheIntegrityError (-600) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_CacheIntegrityError               (-600)

/**
 * SWERR_CannotGenerateXML (-601) has been replaced by SWERR_InvalidDeal.
 * This error was previously only returned from @ref SW_CSVToXML. See the
 * documentation for that function for details on the errors it may return.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_CannotGenerateXML                 (SWERR_InvalidDeal)

/**
 * SWERR_InvalidSwapType (-602) has been replaced by SWERR_InvalidDeal.
 * This error was previously only returned from @ref SW_CSVToXML. See the
 * documentation for that function for details on the errors it may return.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidSwapType                   (SWERR_InvalidDeal)

/**
 * SWERR_RecipientNotEndUser (-603) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_RecipientNotEndUser               (-603)

/**
 * SWERR_FilePullDownFail (-608) has been replaced by SWERR_InternalError.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_FilePullDownFail                  (SWERR_InternalError)

/**
 * SWERR_UnknownBIC (-609) has been replaced by SWERR_InvalidLegalEntity.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_UnknownBIC                        (SWERR_InvalidLegalEntity)

/**
 * SWERR_DealPickupUnavailable (-650) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealPickupUnavailable             (SWERR_ActionUnavailable)

/**
 * SWERR_DealAcceptAffirmUnavailable (-651) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealAcceptAffirmUnavailable       (SWERR_ActionUnavailable)

/**
 * SWERR_DealRejectDKUnavailable (-652) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealRejectDKUnavailable           (SWERR_ActionUnavailable)

/**
 * SWERR_DealRequestRevisionUnavailable (-653) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealRequestRevisionUnavailable    (SWERR_ActionUnavailable)

/**
 * SWERR_DealAffirmUnavailable (-654) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealAffirmUnavailable             (SWERR_ActionUnavailable)

/**
 * SWERR_DealTransferUnavailable (-655) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealTransferUnavailable           (SWERR_ActionUnavailable)

/**
 * SWERR_DealWithdrawUnavailable (-656) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealWithdrawUnavailable           (SWERR_ActionUnavailable)

/**
 * SWERR_DealReleaseUnavailable (-657) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealReleaseUnavailable            (SWERR_ActionUnavailable)

/**
 * SWERR_DealAcknowledgeUnavailable (-658) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealAcknowledgeUnavailable        (SWERR_ActionUnavailable)

/**
 * SWERR_RejectDirectUnavailable (-659) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_RejectDirectUnavailable           (SWERR_ActionUnavailable)

/**
 * SWERR_InvalidPrivateData (-660) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidPrivateData                (SWERR_InvalidXML)

/**
 * SWERR_HandleNotValid (-661) has been replaced by SWERR_UnknownDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_HandleNotValid                    (SWERR_UnknownDeal)

/**
 * SWERR_DealNotFound (-663) has been replaced by SWERR_UnknownDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealNotFound                      (SWERR_UnknownDeal)

/**
 * SWERR_CannotRepresentDeal (-664) has been replaced by SWERR_UnsupportedXmlVersion.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_CannotRepresentDeal               (SWERR_UnsupportedXmlVersion)

/**
 * SWERR_UserNotInParticipant (-666) has been replaced by SWERR_UnknownUserOrGroup.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_UserNotInParticipant              (SWERR_UnknownUserOrGroup)

/**
 * SWERR_PrivateDataReadOnly (-668) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_PrivateDataReadOnly               (-668)

/**
 * SWERR_MissingQueryData (-669) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_MissingQueryData                  (-669)

/**
 * SWERR_DealAcceptUnavailable (-673) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealAcceptUnavailable             (SWERR_ActionUnavailable)

/**
 * SWERR_OptionStyleMismatch (-674) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_OptionStyleMismatch               (-674)

/**
 * SWERR_CannotModifyDeal (-675) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_CannotModifyDeal                  (SWERR_ActionUnavailable)

/**
 * SWERR_CannotSubmitNonPrimeBrokerDeal (-676) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_CannotSubmitNonPrimeBrokerDeal    (SWERR_InvalidXML)

/**
 * SWERR_CannotSubmitPrimeBrokerDeal (-677) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_CannotSubmitPrimeBrokerDeal       (SWERR_InvalidXML)

/**
 * SWERR_ContinueUnavailable (-682) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_ContinueUnavailable               (SWERR_ActionUnavailable)

/**
 * SWERR_NovationUnavailable (-683) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_NovationUnavailable               (SWERR_ActionUnavailable)

/**
 * SWERR_CannotSubmitNonNovation (-684) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_CannotSubmitNonNovation           (SWERR_InvalidXML)

/**
 * SWERR_CannotSubmitNovation (-685) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_CannotSubmitNovation              (SWERR_InvalidXML)

/**
 * SWERR_ConversationWithdrawn (-686) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_ConversationWithdrawn             (SWERR_ActionUnavailable)

/**
 * SWERR_CannotAmendNonPrimeBrokerDeal (-687) has been replaced by SWERR_InvalidXML.
 * This error was returned under two circumstances previously; When submitted SWDML
 * for the amendment was not a prime brokered deal, but the underlying deal was, and
 * secondly when the SWDML was a prime brokered deal but the underlying deal was not.
 * If the first case, SWERR_InvalidXML is now returned, in the second, SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_CannotAmendNonPrimeBrokerDeal     (SWERR_InvalidXML)

/**
 * SWERR_CannotAmendPrimeBrokerDeal (-688) has been replaced by SWERR_InvalidXML.
 * This error was returned under two circumstances previously; When submitted SWDML
 * for the amendment was a prime brokered deal, but the underlsing deal was not, and
 * secondly when the SWDML was not a prime brokered deal but the underlying deal was.
 * If the first case, SWERR_InvalidXML is now returned, in the second, SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_CannotAmendPrimeBrokerDeal        (SWERR_InvalidXML)

/**
 * SWERR_NoListedContract (-701) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_NoListedContract                  (-701)

/**
 * SWERR_NoSingleSideTradePerm (-709) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_NoSingleSideTradePerm             (-709)

/**
 * SWERR_LongFormRequired (-711) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_LongFormRequired                  (SWERR_InvalidXML)

/**
 * SWERR_ExerciseUnavailable (-713) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_ExerciseUnavailable               (SWERR_ActionUnavailable)

/**
 * SWERR_MatchUpdateUnavailable (-717) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_MatchUpdateUnavailable            (SWERR_ActionUnavailable)

/**
 * SWERR_InvalidInterestGroup (-722) has been replaced by SWERR_UnknownUserOrGroup.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidInterestGroup              (SWERR_UnknownUserOrGroup)

/**
 * SWERR_NoStatus (-723) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_NoStatus                          (-723)

/**
 * SWERR_FixedAmountMismatch (-724) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_FixedAmountMismatch               (SWERR_InvalidDeal)

/**
 * SWERR_EquityRicMismatch (-725) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_EquityRicMismatch                 (SWERR_InvalidDeal)

/**
 * SWERR_XMLUnknownTag (-751) has been replaced by SWERR_InvalidXML
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_XMLUnknownTag                     (SWERR_InvalidXML)

/**
 * SWERR_NoTradeIdSpecified (-753) has been replaced by SWERR_InvalidXML
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_NoTradeIdSpecified                (SWERR_InvalidXML)

/**
 * SWERR_NonReleasedDeal (-761) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_NonReleasedDeal                   (-761)

/**
 * SWERR_InvalidClearingHouse (-762) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidClearingHouse              (-762)

/**
 * SWERR_InvalidClearingFlag (-764) has been replaced by SWERR_InvalidXML
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidClearingFlag               (SWERR_InvalidXML)

/**
 * SWERR_InvalidContractState (-784) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidContractState              (SWERR_InvalidXML)

/**
 * SWERR_InvalidBookingState (-785) is no longer used.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidBookingState               (-785)

/**
 * SWERR_BookingStateNotAllowed (-786) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_BookingStateNotAllowed            (SWERR_InvalidXML)

/**
 * SWERR_InvalidSalesCredit (-787) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidSalesCredit                (SWERR_InvalidXML)

/**
 * SWERR_InvalidBrokerageAmount(-788) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidBrokerageAmount            (SWERR_InvalidXML)

/**
 * SWERR_TradeWithdrawn (-789) is no longer used.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_TradeWithdrawn                    (-789)

/**
 * SWERR_LogicException (-790) has been replaced by SWERR_InternalError.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_LogicException                    (SWERR_InternalError)

/**
 * SWERR_SWMLException (-791) has been replaced by SWERR_UnsupportedXmlVersion.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_SWMLException                     (SWERR_UnsupportedXmlVersion)

/**
 * SWERR_ConnectionInError (-793) has been replaced by SWERR_LostConnection.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_ConnectionInError                 (SWERR_LostConnection)

/**
 * SWERR_ConnectionInDoubt (-794) is no longer used.
 * See @ref SW_RegisterSessionStateCallback() for possible callback errors.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_ConnectionInDoubt                 (-794)

/**
 * SWERR_Disconnected (-795) has been replaced by SWERR_LostConnection.
 * See @ref SW_RegisterSessionStateCallback() for possible callback errors.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_Disconnected                      (SWERR_LostConnection)

/**
 * SWERR_NoOldPrivateVer (-796) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_NoOldPrivateVer                   (-796)

/**
 * SWERR_XMLError (-802) has been replaced by SWERR_InternalError.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_XMLError                          (SWERR_InternalError)

/**
 * SWERR_InvalidActivityType (-805) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidActivityType               (SWERR_InvalidXML)

/**
 * SWERR_NonDeliverable (-808) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_NonDeliverable                    (SWERR_InvalidXML)

/**
 * SWERR_ClientClearing (-809) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_ClientClearing                    (SWERR_InvalidXML)

/**
 * SWERR_Password_Invalid (-810) has been replaced by SWERR_WrongUsernameOrPassword.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_Password_Invalid                  (SWERR_WrongUsernameOrPassword)

/**
 * SWERR_BadUserOrAuthData (-811) has been replaced by SWERR_WrongUsernameOrPassword.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_BadUserOrAuthData                 (SWERR_WrongUsernameOrPassword)

/**
 * SWERR_BadUserOrAuthDataAndLocked (-812) has been replaced by SWERR_WrongUsernameOrPassword.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_BadUserOrAuthDataAndLocked        (SWERR_WrongUsernameOrPassword)

/**
 * SWERR_RecentlyChangedPassword (-813) has been replaced by SWERR_PasswordRecentlyChanged.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_RecentlyChangedPassword           (SWERR_PasswordRecentlyChanged)

/**
 * SWERR_Unexpected (-815) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_Unexpected                        (-815)

/**
 * SWERR_BookingState_FieldTooLong (-820) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_BookingState_FieldTooLong         (SWERR_InvalidXML)

/**
 * SWERR_CState_FieldTooLong (-831) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_CState_FieldTooLong               (SWERR_InvalidXML)

/**
 * SWERR_SinkConf_FieldTooLong (-832) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_SinkConf_FieldTooLong             (SWERR_InvalidXML)

/**
 * SWERR_BookID_FieldTooLong (-834) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_BookID_FieldTooLong               (SWERR_InvalidXML)

/**
 * SWERR_PartyID_FieldTooLong (-835) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_PartyID_FieldTooLong              (SWERR_InvalidXML)

/**
 * SWERR_SalesCredit_FieldTooLong (-836) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_SalesCredit_FieldTooLong          (SWERR_InvalidXML)

/**
 * SWERR_SalesCredit_NegativeValue (-837) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_SalesCredit_NegativeValue         (SWERR_InvalidXML)

/**
 * SWERR_Comment_FieldTooLong (-838) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_Comment_FieldTooLong              (SWERR_InvalidXML)

/**
 * SWERR_BrCurr_FieldTooLong (-839) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_BrCurr_FieldTooLong               (SWERR_InvalidXML)

/**
 * SWERR_BrAmount_FieldTooLong (-840) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_BrAmount_FieldTooLong             (SWERR_InvalidXML)

/**
 * SWERR_AdditionalField_FieldTooLong (-841) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_AdditionalField_FieldTooLong      (SWERR_InvalidXML)

/**
 * SWERR_TradeID_FieldTooLong (-842) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_TradeID_FieldTooLong              (SWERR_InvalidXML)

/**
 * SWERR_EndTradeID_FieldTooLong (-843) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_EndTradeID_FieldTooLong           (SWERR_InvalidXML)

/**
 * SWERR_DateTime_FieldTooLong (-844) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_DateTime_FieldTooLong             (SWERR_InvalidXML)

/**
 * SWERR_MajVersion_FieldTooLong (-845) has been replaced by SWERR_BadParameter.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_MajVersion_FieldTooLong           (SWERR_BadParameter)

/**
 * SWERR_UniqueVersion_FieldTooLong (-846) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_UniqueVersion_FieldTooLong        (SWERR_InvalidXML)

/**
 * SWERR_PrivateVersion_FieldTooLong (-847) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_PrivateVersion_FieldTooLong       (SWERR_InvalidXML)

/**
 * SWERR_Side_FieldTooLong (-848) has been replaced by SWERR_InvalidSide.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_Side_FieldTooLong                 (SWERR_InvalidSide)

/**
 * SWERR_InvalidValue (-849) is no longer used.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidValue                      (-849)

/**
 * SWERR_NettingString_FieldTooLong (-850) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_NettingString_FieldTooLong        (SWERR_InvalidXML)

/**
 * SWERR_PTradeId_FieldTooLong (-851) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_PTradeId_FieldTooLong             (SWERR_InvalidXML)

/**
 * SWERR_ExitUnavailable (-852) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_ExitUnavailable                   (SWERR_ActionUnavailable)

/**
 * SWERR_BadStrategy (-854) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_BadStrategy                       (SWERR_InvalidDeal)

/**
 * SWERR_StrategyTypeMismatch (-855) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_StrategyTypeMismatch              (SWERR_InvalidDeal)

/**
 * SWERR_DealNotPreSendDraft (-856) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_DealNotPreSendDraft               (SWERR_ActionUnavailable)

/**
 * SWERR_RecipientsRequired (-857) is no longer used. If recipients are required
 * in recipient xml and are not specifiedd, SWERR_NoRecipients will be returned.
 * @deprecated The API will not return this value, so client code should not
 * refer to it.
 */
#define SWERR_RecipientsRequired                (SWERR_NoRecipients)

/**
 * SWERR_NoMasterConfirmationDate (-859) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_NoMasterConfirmationDate          (SWERR_InvalidDeal)

/**
 * SWERR_PositionChangeUnavailable (-860) has been replaced by SWERR_ActionUnavailable.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_PositionChangeUnavailable         (SWERR_ActionUnavailable)

/**
 * SWERR_InvalidPositionChange (-861) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_InvalidPositionChange             (SWERR_InvalidXML)

/**
 * SWERR_PricePerOptionMismatch (-863) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_PricePerOptionMismatch            (SWERR_InvalidDeal)

/**
 * SWERR_HedgeLevelMismatch (-864) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_HedgeLevelMismatch                (SWERR_InvalidDeal)

/**
 * SWERR_BasisMismatch (-865) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_BasisMismatch                     (SWERR_InvalidDeal)

/**
 * SWERR_ImpliedLevelMismatch (-866) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_ImpliedLevelMismatch              (SWERR_InvalidDeal)

/**
 * SWERR_AttributeIsNull (-867) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_AttributeIsNull                   (SWERR_InvalidDeal)

/**
 * SWERR_AttributeIsNull (-867) has been replaced by SWERR_InvalidDeal.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_BrokerTradeValueIsNull            (SWERR_InvalidDeal)

/**
 * SWERR_UnsupportedClientVersion (-873) has been replaced by SWERR_SoftwareMismatch.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_UnsupportedClientVersion          (SWERR_SoftwareMismatch)

/**
 * SWERR_MissingNovationSwdmlComponent (-875) has been replaced by SWERR_InvalidXML.
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_MissingNovationSwdmlComponent     (SWERR_InvalidXML)

/**
 * SWERR_Truncated (1) is no longer used.
 * Previously this code was returned under some circumstances from @ref SW_QueryDeals
 * to indicate that only a partial result set had been returned.
 *
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_Truncated                         (1)

/**
 * SWERR_UnableToGenerateSWDML (2) is no longer used.
 * Previously this code was returned under some circumstances from @ref SW_DealGetSWDML,
 * @ref SW_DealGetUnderlyingDealSWDML or @ref SW_GetSWDMLfromSWML, however it
 * was confusing (being positive) and often irrelevant to clients who wanted SWDML.
 *
 * Please see the documentation for the above functions for details on
 * handling their possible error codes.
 *
 * @deprecated The API will not return the old value, so client code should not
 * refer to it.
 */
#define SWERR_UnableToGenerateSWDML             (2)

/** SWERR_NotEnoughRandomness (-519) is no longer used.
 * Previously returned when the openssl random number generator requires more randomness.
 *
 * @deprecated The API will not return this value, so client code should not
 * refer to it
 */
#define SWERR_NotEnoughRandomness               (-519)

#endif

/** @} */

#endif /* SW_API_ERRORCODES_H */
