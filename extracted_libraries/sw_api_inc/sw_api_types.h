#if defined (_MSC_VER) && _MSC_VER > 1000
#pragma once
#endif

#ifndef SW_API_TYPES_H
#define SW_API_TYPES_H

/** @file sw_api_types.h */

/*
 * This normally comes from windef.h via windows.h, but define it for anyone
 * not using them
 */
#if defined (WIN32)
#ifndef STDAPICALLTYPE
#define STDAPICALLTYPE __stdcall
#endif
#else
/** a symbol to make sure the code knows it's running within the API client */
#define SW_CLIENT_API
#ifndef STDAPICALLTYPE
#define STDAPICALLTYPE
#endif
#endif

#ifdef SWIG
/** a % directive to SWIG to tell it whether the class is mutable or immutable */
#define SWIG_DIRECTIVE(what) % ## what;
#else
/** A null macro to avoid SWIG specific code */
#define SWIG_DIRECTIVE(what)
#endif

#ifdef __cplusplus
extern "C" {
#endif

/** @brief Describes the method by which callbacks should be executed. */
enum SW_CallbackMode
{
    SWCM_Synchronous, /**< Synchronous */
    SWCM_Asynchronous /**< Asynchronous */
};

/** @brief Enumeration giving simplified view of the dealers state from a brokers perspective */
enum SW_DealerDealState
{
    SWDDS_Err = -1, /**< Invalid or unrepresentable dealer deal state. */
    SWDDS_NotPickedUp,
    SWDDS_PickedUp,
    SWDDS_Accepted,
    SWDDS_Rejected,
    SWDDS_RequestedRevision
#if SW_API_VER > 500
    /* New Enum values will be added here, but only used by api functions if
     * @ref SW_Initialise() was called with at least the matching SW_API_VER value.
     */
#endif
};

/** @brief Attributes of trades not exposed by the contract state.
 * These flags are passed to the callback set by SW_RegisterDealNotifyExCallback().
 * to provide further information for client deal processing.
 */
enum SW_TradeAttributeFlags
{
    /** A synthesised trade.
     * The trade was created for the purpose of affirming a group of related
     * trades, but does not itself represent a legal trade. For example, the
     * parent trade is a Strategy.
     */
    SWTA_Synthesised = 0x1
};

/**
 * Deal States.
 */
enum SW_DealState
{
    SWDS_Err = -1,                           /**< Invalid or unrepresentable deal state. */
    SWDS_PendingBrokeredDeal,                /* 0 */
    SWDS_PendingDirectDeal,                  /* 1 */
    SWDS_BrokeredPickedUp,                   /* 2 */
    SWDS_AwaitingCptyAccept,                 /* 3 */
    SWDS_AwaitingCptyAction,                 /* 4*/
    SWDS_AwaitingCptyActionRef,              /* 5*/
    SWDS_AwaitingMyAction,                   /* 6*/
    SWDS_AwaitingMyActionRef,                /* 7*/
    SWDS_AffirmedDeal,                       /* 8*/
    SWDS_AwaitingBrokerAction,               /* 9*/
    SWDS_AwaitingAcknowledgement,            /* 10*/
    SWDS_Terminated,                         /* 11*/
    SWDS_Transferred,                        /* 12*/
    SWDS_Released,                           /* 13*/
    SWDS_PendingDirectDealWithMe,            /* 14*/
    SWDS_PendingDirectDealWithCpty,          /* 15*/
    SWDS_PendingDirectDealWithCptyPulled,    /* 16*/
    SWDS_UnsentDeal,                         /* 17*/
    SWDS_IncomingTransfer,                   /* 18*/
    SWDS_PrimeBrokerAgreed,                  /* 19*/
    SWDS_PrimeBrokerAccepted,                /* 20*/
    SWDS_PrimeBrokerRevisionPending,         /* 21*/
    SWDS_PrimeBrokerAgreementPending,        /* 22*/
    SWDS_ContinueWithNoPrimeBroker,          /* 23*/
    SWDS_NovationFeeAgreedWithCounterparty,  /* 24*/
    SWDS_NovationFeeAgreementPending,        /* 25*/
    SWDS_IncomingRemainingAgreementPending,  /* 26*/
    SWDS_PendingMatchWithCpty,               /* 27*/
    SWDS_PendingMatchWithMe,                 /* 28*/
    SWDS_TerminatedByMatch,                  /* 29*/
    SWDS_Unsent,                             /* 30*/
    SWDS_Active,                             /* 31*/
    SWDS_Withdrawn,                          /* 32*/
    SWDS_Accepted,                           /* 33*/
    SWDS_ObsoleteVersion,                    /* 34*/

    /** Updated, but you may not be active in the deal.  For deals you are
     * active in, you will also receive other, more specific notifications. */
    SWDS_DealUpdated,                        /* 35 */

    /** New-style notification match states */
    SWDS_MatchInfo,                          /* 36*/

    /** Reporting Info Notification */
    SWDS_ReportInfo,                         /* 37*/

#if SW_API_VER > 500
    /* New Enum values will be added here, but only used by api functions if
     * @ref SW_Initialise() was called with at least the matching SW_API_VER value.
     */
#endif
};

/**
 * Types of deals.
 */
enum SWDA_DealType
{
    SWDT_New,
    SWDT_Draft,
    SWDT_Backload,
    SWDT_PrimeBroker,
    SWDT_PrimeBrokerDraft,
    SWDT_Novation,
    SWDT_Underlying,
    SWDT_Match,
    SWDT_Auto
#if SW_API_VER > 500
    /* New Enum values will be added here, but only used by api functions if
     * @ref SW_Initialise() was called with at least the matching SW_API_VER value.
     */
#endif
};

/**
 * @typedef int SW_SessionID
 * @brief Represents a session connected to the SwapsWire system.
 * @sa SW_Connect
 */
typedef int SW_SessionID;
/**
 * @typedef int SW_LoginID
 * @brief Represents a user logged in through a session.
 * The login id, also known as the login handle, is returned from @ref SW_Login.
 * When the users actions are completed, it should be disposed of by calling
 * @ref SW_Logout.
 */
typedef int SW_LoginID;
/**
 * @defgroup dealids Deal Identifiers
 * @brief Types used to refer to deal versions.
 */
/* @{ */
/**
 * @typedef const char* SW_DealVersionHandle
 * @brief A 64 character string uniquely identifying a version and side of a deal.
 * Deal version handles (or DVH's) are used to identify the version of a deal to
 * operate on.  API functions that perform actions on deals typically take the
 * DVH of the deal, perform the action(s) and then return the DVH of the resulting
 * deal to the caller.
 * In the event that the DVH passed to an API function has been superceeded by a
 * later deal version (for example, if the other side of a deal has modified it
 * since the user called the function), then the error @ref SWERR_HandleNotLatest
 * is generally returned. If the DVH passed is invalid (@c NULL, empty or malformed)
 * it will usually be rejected with @ref SWERR_BadParameter.
 * @note As with all output strings, returned DVHs must be freed by the user.
 * See @ref resource.
 * @sa ErrorCodes
 */
typedef const char* SW_DealVersionHandle;

/**
 * @brief For dealers and Clearing Houses, it is DealVersionHandle.
 * for broker, it is the error message of the update operation. It is empty string if operation is successful.
 */
typedef const char* SW_DealUpdateResult;

/**
 * @brief The MarkitWire deal identifier, a positive integer.
 * Passing a negative value as the @a dealID parameter to API functions will
 * result in @ref SWERR_BadParameter being returned. Passing a deal identifier
 * that is not visible to your user or does not exist will result
 * in @ref SWERR_UnknownDeal.
 */
typedef long long SW_DealID;
/**
 * The integer contract version of a deal, starting from 1.
 * @note 'Major version' and 'contract version' are used interchangeably in this documentation.
 * The major version of a deal changes whenever the deals contract state does.
 * For example, novating or excercising a deal will increment the major version.
 * @note For the brokers side of a deal, the major version is is always 1. This
 *       is because once the other parties accept the deal, the broker is no longer
 *       a party to it.
 * @sa dealversionconstants, SW_DealMinorVersion, SW_DealPrivateVersion.
 */
typedef int SW_DealMajorVersion;
/**
 * The integer revision number of a deal, starting from 0.
 * @note 'Minor version' and 'revision' are used interchangeably in this documentation.
 * The revision or minor number of a deal increments when a broker resubmits
 * a previously withdrawn deal. When a brokered deal is initially submitted,
 * it has an @ref SW_DealMajorVersion of 1 and an @ref SW_DealMinorVersion of 0.
 * Withdrawing the deal does not change the major or minor version of the deal.
 * If the deal is then resubmitted, it will have an @ref SW_DealMajorVersion of 1
 * and an @ref SW_DealMinorVersion of 1. Subsequent withdraw/resubmits increment
 * the minor version following the same pattern.
 * @note The minor version number is @em only applicable to the brokers side of a deal.
 * @sa dealversionconstants, SW_DealMajorVersion, SW_DealPrivateVersion.
 */
typedef int SW_DealMinorVersion;
/**
 * The integer private version of a deal, starting from 1.
 * Each side of a deal has their own private version number. The private
 * version increments when an update is made to the deal that does not
 * require a new contract state, for example when a unilateral update is made.
 * The private version may increment by more than 1 when it changes, depending
 * on internal processing.
 * When a deal changes contract (major) version, the private version is reset to 1.
 * The combination of @ref SW_DealMajorVersion and @ref SW_DealPrivateVersion
 * can be used to identify a specific version of a deal. However it is
 * recommended that @ref SW_DealVersionHandle is used for tracking deal versions
 * instead, since it is unambiguous in various edge cases.
 * @note The private version is 0 on a deal that is not picked up. While it is
 *       not possible to pass a value of 0 to any API functions, you may see
 *       this value in notifications.
 * @note The private version is @em not applicable to the brokers side of a deal.
 * @sa dealversionconstants, SW_DealMajorVersion, SW_DealMinorVersion.
 */
typedef int SW_DealPrivateVersion;

/**
 * @typedef int SW_DealSide.
 * @brief The side of the deal, an integer.
 * @sa sideconstants.
 */
typedef int SW_DealSide;
/* @} */
/**
 * @typedef int SW_TimeSpan
 * @brief A time, given as a number of seconds since Jan 1 1970 (The UNIX Epoc).
 */
typedef int SW_TimeSpan;
/**
 * @typedef int SW_ErrCode
 * @brief The type of the return code from all Swapswire API functions.
 * @sa ErrorCodes
 */
typedef int SW_ErrCode;
/**
 * @typedef const char* SW_DealVersionHandles
 * @brief A list of deal version handles, separated by newline characters.
 * @note As with all output strings, returned version handle lists must be freed
 * by the user. See @ref resource.
 * @sa ErrorCodes
 */
typedef const char* SW_DealVersionHandles; /* Multiple - \n separated */

/**
 * @typedef const char* SW_BrokerDealID
 * @brief A string containing an internal broker deal ID, or
 * <a href="./xmlref.html#swbMultiPartDeal">swbMultiPartDealID XML</a>.
 *
 * There are two distinct representations of broker deal ids. The first
 * is simply a string of characters that have meaning to the broker, and
 * typically correspond to the trade identifier from the brokers booking system.
 * The second is swbMultiPartDealID XML, which is used to group trades
 * together (for example in a strategy). See
 * <a href="./xmlref.html#swbMultiPartDeal">swbMultiPartDealID XML</a> for
 * more information.
 *
 * Neither representation may contain the vertical bar character ('|').
 * Broker trade ids are limited to @ref SWB_DEAL_ID_MAXLEN characters.
 * Leg id's are limited to @ref SWB_LEG_ID_MAXLEN characters. In the
 * event that the above constraints are not met, @ref SWERR_BadParameter
 * will be returned by the function the ID is passed to.
 *
 * The preferred format for broker leg id's is "X/Y", for example "1/3"
 * indicating that this deal is the first leg of three legs in total.
 *
 * @note As with all output strings, returned broker trade ids must be freed
 * by the user. See @ref resource.
 * @sa ErrorCodes
 */
typedef const char* SW_BrokerDealID;

/**
 * An identifier for a recipient of a brokered deal.
 *
 * Within the SWBML of a deal, the recipients are specified in the "<swbHeader>"
 * element as "<swbRecipient>" elements containing an "id" attribute and a
 * "<partyReference>" element. The broker is free to choose the "id" attribute,
 * provided they are legal XML attribute values. A common scheme is to name
 * them numerically, e.g. "_1", "_2", etc, although other schemes exist, for
 * example "pay" and "rec". The following excerpt from an SWML document:
   @verbatim
   <swbHeader>
     ...
     <swbRecipient id="_1">
       <partyReference href="partyA"/>
     </swbRecipient>
     <swbRecipient id="_2">
       <partyReference href="partyB"/>
     </swbRecipient>
   </swbHeader>
   @endverbatim
 * Uses the first scheme. In the above example, the @c SW_BrokerRecipientIDs for
 * each side are "_1" and "_2". When this deal is submitted, these two values
 * can be passed to functions that expect a @c SW_BrokerRecipientID in order
 * to query information about the recipient that the ID represents.
 */
typedef const char* SW_BrokerRecipientID;

/**
 * A list of broker recipient ID's.
 * The list of @ref SW_BrokerRecipientID elements is returned as a string with
 * each ID separated by a newline character.
 * @sa SW_BrokerRecipientID
 */
typedef const char* SW_BrokerRecipientIDs;

/**
 * @typedef const char* SW_XML
 * @brief A string containing an XML document.
 * XML passed by the user is validated by the API. When an XML parameter
 * is mandatory, but is passed as NULL or an empty string, @ref SWERR_BadParameter
 * is returned. When passed XML does not parse, or fails schema/DTD validation,
 * @ref SWERR_InvalidXML is returned. @ref SWERR_InvalidXML may also be returned
 * if the XML fails further validation checks, for example, if the wrong type
 * of XML is passed to a function. As a special case, when a deals XML
 * representation is invalid, for example it fails validation against the
 * systems business rules, @ref SWERR_InvalidDeal is returned. In all cases,
 * details of why the XML is invalid can be retreived using @ref SW_GetLastErrorSpecificsEx.
 * @sa ErrorCodes
 */
typedef const char* SW_XML;

/**
 * @typedef SW_ErrCode STDAPICALLTYPE DSQUERYHANDLER (SW_LoginID lh, void* tag, SW_XML resXML, SW_ErrCode retCode)
 * @brief The signature of the callback function for asynchronous processing via SW_QueryDeals().
 */
typedef SW_ErrCode STDAPICALLTYPE DSQUERYHANDLER (SW_LoginID lh, void* tag, SW_XML resXML, SW_ErrCode retCode);
/**
 * @typedef DSQUERYHANDLER* PDSQUERYHANDLER
 * @brief A pointer to a callback function for @ref SW_QueryDeals.
 */
typedef DSQUERYHANDLER* PDSQUERYHANDLER;

/**
 * @brief The data passed to the deprecated deal notification callback.
 * @deprecated @ref SW_RegisterDealNotifyExCallback should be used instead.
 */
typedef void STDAPICALLTYPE SW_DealNotifyCallback (SW_LoginID            lh,
                                                   void*                 tag,
                                                   SW_BrokerDealID       brokerDealID,
                                                   SW_DealID             dealID,
                                                   SW_DealMajorVersion   majorVersion,
                                                   SW_DealMinorVersion   minorVersion,
                                                   SW_DealPrivateVersion privateVersion,
                                                   SW_DealSide           side,
                                                   SW_DealVersionHandle  prevDealVersionHandle,
                                                   SW_DealVersionHandle  dealVersionHandle,
                                                   enum SW_DealState     newState,
                                                   const char*           newStateStr,
                                                   const char*           contractStateStr,
                                                   const char*           productType);
/**
 * @typedef SW_DealNotifyCallback* SW_DealNotifyCallbackPtr
 * @brief A pointer to a callback function for @ref SW_RegisterDealNotifyCallback.
 * @deprecated @ref SW_RegisterDealNotifyExCallback should be used instead.
 */
typedef SW_DealNotifyCallback* SW_DealNotifyCallbackPtr;

/**
 * @brief The data passed to the extended deal notification callback.
 */
typedef struct
{
    SWIG_DIRECTIVE(immutable)
    SW_LoginID lh;                    /**< The login handle of the user receiving the callback. */
    void* clientData;                 /**< Client specific data passed to SW_RegisterDealNotifyExCallback(). */
    SW_BrokerDealID brokerId;         /**< The MarkitWire broker ID, if the deal is a brokered deal. */
    SW_DealID dealId;                 /**< The MarkitWire deal ID. */
    SW_DealMajorVersion majorVer;     /**< The major version number. */
    SW_DealMinorVersion minorVer;     /**< The minor version number. */
    SW_DealPrivateVersion privateVer; /**< The private version number. */
    SW_DealSide side;                 /**< The deal side. */
    SW_DealVersionHandle prevDVH;     /**< The DVH of the previous deal version, if available. */
    SW_DealVersionHandle dvh;         /**< The DVH of this version of the deal. */
    enum SW_DealState newState;       /**< The new state of the deal. */
    const char* newStateStr;          /**< The new state of the deal, expressed as a string. */
    const char* contractState;        /**< The contract state of the deal. */
    const char* productType;          /**< The product type of the deal. */
    unsigned int tradeAttrFlags;      /**< One or more @ref SW_TradeAttributeFlags */
    SWIG_DIRECTIVE(mutable)
} SW_DealNotifyData;

/**
 * @brief The function type of the users callback for @ref SW_RegisterDealNotifyExCallback.
 * @note @a data is constant and should not be modified or freed by the
 *    caller. It is only valid for the duration of the callback, so if the
 *    user wishes to store or process it at a later point, they should take a copy
 *    of the data, including copies of any embedded strings.
 */
typedef void STDAPICALLTYPE SW_DealNotifyExCallback (const SW_DealNotifyData* data);

/**
 * @typedef SW_DealNotifyExCallback* SW_DealNotifyExCallbackPtr
 * @brief A pointer to a @ref SW_DealNotifyExCallback function.
 * This is the signature of the user callback passed as parameter @a cb to
 * the @ref SW_RegisterDealNotifyExCallback function.
 */
typedef SW_DealNotifyExCallback* SW_DealNotifyExCallbackPtr;

/**
 * @brief The type of a callback function for @ref SW_RegisterBatchCallback.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param tag The users data pass as parameter @a tag to @ref SW_RegisterBatchCallback.
 * @param resultXML Bulk Actions XML describing the batch actions.
 * @return Currently unused, however clients should return @ref SWERR_Success as
 *    this parameter may be used in the future to indicate errors in client processing.
 * @note @a resultXML is constant and should not be modified or freed by the
 *    caller. It is only valid for the duration of the callback, so if the
 *    user wishes to store or process it at a later point, they should take a copy.
 */
typedef SW_ErrCode STDAPICALLTYPE SW_BatchCallback (SW_LoginID lh,
                                                    void*      tag,
                                                    SW_XML     resultXML);
/**
 * @typedef SW_BatchCallback* SW_BatchCallbackPtr
 * @brief A pointer to a @ref SW_BatchCallback function for @ref SW_RegisterBatchCallback.
 */
typedef SW_BatchCallback* SW_BatchCallbackPtr;

/**
 * @brief  The signature of the callback function called when the
 * session state changes.
 *
 * When a caller registers a callback using SW_RegisterSessionStateCallback(),
 * the API will notify the program by calling it whenever the session state
 * changes.
 *
 * The callback receives a parameter @a errorCode which represents the nature
 * of the state change. Any of the following codes may be returned:
 * - @ref SWERR_Connected
 * - @ref SWERR_LostConnection
 * - @ref SWERR_UserLoggedOut
 * - @ref SWERR_InternalError
 *
 * See @ref SW_RegisterSessionStateCallback() for a discussion of how to
 * correctly handle each code.
 *
 * @param sh        The handle for the session that changed state.
 * @param tag       This is the tag supplied in the call to SW_Connect().
 * @param errorCode The type of change that occurred.
 */
typedef void (STDAPICALLTYPE* SW_SessionStateCallbackPtr)(SW_SessionID sh, void* tag, SW_ErrCode errorCode);

/**
 * @defgroup titypes Trade Input Types.
 * @brief Types of trades that users may submit to the system.
 * @details Users can be set up to allow submission of match or affirmation
 * deals depending on workflow requirements. Users that always submit match
 * deals are referred to as "AI" users.
 */

#ifdef __cplusplus
}
#endif

#endif /* SW_API_TYPES_H */
