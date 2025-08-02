#if defined (_MSC_VER) && _MSC_VER > 1000
#pragma once
#endif

#ifndef SW_API_CONSTANTS_DEFINES_H
#define SW_API_CONSTANTS_DEFINES_H

/** @file sw_api_constants.h */

/**
 * @defgroup constants API Constants
 * Constants for various API functions.
 */
/** @{ */

/**
 * @def SW_API_VER
 * The version of the MarkitWire API.
 *
 * Applications can use this macro to prevent the use of new features when
 * built against older versions of the API.
 */
#ifndef SW_API_VER
#define SW_API_VER 500
#endif

#include "sw_api_errorcodes.h"

/**
 * @defgroup swmlversions SWML Versions
 * Constants for choosing the version of SWML to generate from @ref SW_DealGetSWML.
 * Functions that expect an SWML version will return @ref SWERR_BadParameter if
 * the @a swmlVersion parameter is not one of the below values.
 * In the event that the product for which SWML is requested is not representable
 * in the given SWML version, @ref SWERR_UnsupportedXmlVersion will be returned.
 */
/* @{ */
/** @deprecated SWML Version 2.0 is no longer supported */
#define SWML_2_0                          "2.0"
/** @deprecated SWML Version 2.1 is no longer supported */
#define SWML_2_1                          "2.1"
/** SWML Version 3.0.
 * This is the minimum SWML version that can be retrieved. Certain product
 * classes may have higher minimum versions.
 */
#define SWML_3_0                          "3.0"
#define SWML_3_1                          "3.1"  /**< SWML Version 3.1 */
#define SWML_4_0                          "4.0"  /**< SWML Version 4.0 */
#define SWML_4_1                          "4.1"  /**< SWML Version 4.1 */
#define SWML_4_2                          "4.2"  /**< SWML Version 4.2 */
#define SWML_4_3                          "4.3"  /**< SWML Version 4.3 */
#define SWML_4_4                          "4.4"  /**< SWML Version 4.4 */
#define SWML_4_5                          "4.5"  /**< SWML Version 4.5 */
#define SWML_4_6                          "4.6"  /**< SWML Version 4.6 */
#define SWML_4_7                          "4.7"  /**< SWML Version 4.7 */
#define SWML_4_9                          "4.9"  /**< SWML Version 4.9 */
#define SWML_5_0                          "5.0"  /**< SWML Version 5.0 */
#define SWML_5_3                          "5.3"  /**< SWML Version 5.3 */
#define SWML_5_11                         "5.11" /**< SWML Version 5.11 */
/** Return the system recommended version for the deal type SWML is being generated for. */
#define SWML_RECOMMENDED                  "9999.0"
/* @} */

/**
 * @defgroup swdmlversions SWDML Versions
 * Constants for choosing the version of SWDML to generate from
 * @ref SW_DealGetSWDML, @ref SW_DealGetUnderlyingDealSWDML and @ref SW_GetLongFromShortSWDMLEx.
 * Functions that expect an SWDML version will return @ref SWERR_BadParameter if
 * the @a swdmlVersion parameter is not one of the below values.
 * In the event that the product for which SWDML is requested is not representable
 * in the given SWDML version, @ref SWERR_UnsupportedXmlVersion will be returned.
 */
/* @{ */
#define SWDML_3_0                         "3.0"  /**< SWDML Version 3.0 */
#define SWDML_3_1                         "3.1"  /**< SWDML Version 3.1 */
#define SWDML_4_2                         "4.2"  /**< SWDML Version 4.2 */
#define SWDML_4_4                         "4.4"  /**< SWDML Version 4.4 */
#define SWDML_4_5                         "4.5"  /**< SWDML Version 4.5 */
#define SWDML_4_6                         "4.6"  /**< SWDML Version 4.6 */
#define SWDML_4_7                         "4.7"  /**< SWDML Version 4.7 */
#define SWDML_4_9                         "4.9"  /**< SWDML Version 4.9 */
#define SWDML_5_3                         "5.3"  /**< SWDML Version 5.3 */
#define SWDML_5_11                        "5.11" /**< SWDML Version 5.11 */
/* @} */

/**
 * @defgroup dealstateversions Deal State Information XML Versions
 * Constants for choosing the version of Deal State Information XML to generate from
 * @ref SW_DealGetXML.
 */
/* @{ */
#define SW_DEAL_STATE_INFO_1_0 "1.0" /**< Version 1.0, the only currently supported version */
/* @} */

/**
 * @defgroup fpmlversions FpML versions
 * Constants for choosing the version of FpML to generate from
 * @ref SW_DealGetClearingXML and @ref SW_DealGetXML
 * Functions that expect an FpML version will return @ref SWERR_BadParameter if
 * the @a FpMLVersion parameter is not one of the below values.
 * In the event that the product for which FpML is requested is not representable
 * in the given FpML version, @ref SWERR_UnsupportedXmlVersion will be returned.
 */
/* @{ */
#define FpML_2_0                          "2.0"  /**< FpML Version 2.0 */
#define FpML_3_0                          "3.0"  /**< FpML Version 3.0 */
#define FpML_4_0                          "4.0"  /**< FpML Version 4.0 */
#define FpML_4_1                          "4.1"  /**< FpML Version 4.1 */
#define FpML_4_2                          "4.2"  /**< FpML Version 4.2 */
#define FpML_4_4                          "4.4"  /**< FpML Version 4.4 */
#define FpML_4_5                          "4.5"  /**< FpML Version 4.5 */
#define FpML_4_6                          "4.6"  /**< FpML Version 4.6 */
#define FpML_4_7                          "4.7"  /**< FpML Version 4.7 */
#define FpML_4_9                          "4.9"  /**< FpML Version 4.9 */
#define FpML_5_3                          "5.3"  /**< FpML Version 5.3 */
#define FpML_5_7                          "5.7"  /**< FpML Version 5.7 */
#define FpML_5_11                         "5.11" /**< FpML Version 5.11 */

/* @} */

#if SW_API_VER > 500
/*
 * New constants will be added here, but only used by api functions if @ref SW_Initialise
 * was called with at least the matching SW_API_VER value.
 */
#endif

/**
 * Indicates that @ref SW_Poll should wait indefinitely for notifications.
 */
#define SWS_INFINITE_TIMEOUT              -1

/**
 * @defgroup bookingstates Private Booking States
 * Booking states that can be returned by @ref SW_DealGetPrivateBookingState.
 */
/* @{ */
#define SWS_PENDING_STATE                 "Pending"
#define SWS_WITHDRAWN_STATE               "Withdrawn"
#define SWS_DONE_STATE                    "Done"
#define SWS_RELEASED_STATE                "Released"
/* @} */

/**
 * @defgroup dealversionconstants Deal Version Selection
 * Constants for selecting the version of a deal to operate on,
 * where a @ref SW_DealMajorVersion, @ref SW_DealMinorVersion or
 * @ref SW_DealPrivateVersion parameter is required.
 */
/* @{ */
/**
 * The latest active major, minor or private version of a trade.
 *
 * This can be passed to any function that takes a @ref SW_DealMajorVersion,
 * @ref SW_DealMinorVersion or @ref SW_DealPrivateVersion parameter
 * provided that the function does not modify the deal.
 *
 * For @ref SW_DealMajorVersion, it represents the latest non-withdrawn
 * version of a deal. If a deal only has one version, which has been withdrawn,
 * then it represents that version.
 *
 * For @ref SW_DealMinorVersion, it represents the latest resubmission of
 * the broker deal. Broker deals always have an @ref SW_DealMajorVersion of 1.
 *
 * For @ref SW_DealPrivateVersion, it represents the latest version on
 * the callers side of the deal for the @ref SW_DealMajorVersion given.
 *
 * For functions that modify deals, passing this value will result in
 * in @ref SWERR_BadParameter. This is because modifying a non-explicit
 * version of a deal introduces the risk that the counterparty may have
 * modified it, making the action no longer applicable or applicable to
 * a deal that has been modified from the deal the caller expected.
 *
 * @note Where possible, callers should prefer to use the @ref SW_DealVersionHandle
 *       of a deal to refer to it, since a single deal identifier is easier to
 *       handle correctly and is unambiguous in various edge cases.
 */
#define SWS_LATESTVERSION                 -1
/* @} */

/**
 * @defgroup sideconstants Side Selection
 * Constants for selecting sides of a deal where a @ref SW_DealSide is required.
 */
/* @{ */
/**
 * My side of a trade.
 * This can be passed to any function that takes a @ref SW_DealSide.
 * Note that for internal trades, the system cannot determine which is
 * "your" side. Using a @ref SW_DealVersionHandle is preferable in order
 * to prevent ambiguity in this case.
 */
#define SWS_MYSIDE                        -1
/* @} */

/**
 * Reserved for future use.
 */
#define SWS_ALLSIDES                      -2

/**
 * @defgroup xmltags XML Tags
 * Tag and attribute names used in MarkitWire XML documents.
 */
/* @{ */
#define SWS_XMLTAG_SINKQUERY              "SinkQuery"
#define SWS_XMLTAG_SINKUPDATE             "SinkUpdate"
#define SWS_XMLTAG_SINKQUERYRES           "SinkQueryRes"
#define SWS_XMLTAG_CLEARINGRES            "ClearingResult"
#define SWS_XMLTAG_ERRORTEXT              "ErrorText"
#define SWS_XMLTAG_RESULTROW              "QueryRow"
#define SWS_XMLTAG_STARTDATE              "ActivityStartDate"
#define SWS_XMLTAG_ENDDATE                "ActivityEndDate"
#define SWS_XMLTAG_EXPOPT_STARTDATE       "ExpiryOptionStartDate"
#define SWS_XMLTAG_EXPOPT_ENDDATE         "ExpiryOptionEndDate"
#define SWS_XMLTAG_CONTRACT_STATE         "ContractState"
#define SWS_XMLTAG_TRADEID                "tradeId"
#define SWS_XMLTAG_ENDTRADEID             "EndTradeId"
#define SWS_XMLTAG_ALLVERSIONS            "AllVersions"
#define SWS_XMLTAG_EXTENDEDINFO           "ExtendedInfo"
#define SWS_XMLTAG_RESULTBATCHSIZE        "ResultBatchSize"
#define SWS_XMLTAG_ACTIVITYTYPE           "activityType"
#define SWS_XMLTAG_OBLIGATIONTOCLEAR      "swObligationToClear"
#define SWS_XMLTAG_PDATA                  "swPrivateData"
#define SWS_XMLTAG_PTRADEID               "swPrivateTradeId"
#define SWS_XMLTAG_PPROCSTATE             "swPrivateProcessState"
#define SWS_XMLTAG_PBOOKSTATE             "swPrivateBookingState"
#define SWS_XMLTAG_COMMENT                "swPrivateDealSinkComment"
#define SWS_XMLTAG_PSINKCONF              "swPrivateDealSinkConfirmation"
#define SWS_XMLTAG_TBOOKID                "swTradingBookId"
#define SWS_XMLTAG_BPARTYID               "swBrokerPartyId"
#define SWS_XMLTAG_SALESCR                "swSalesCredit"
#define SWS_XMLTAG_BRKG                   "swBrokerageAmount"
#define SWS_XMLTAG_WILLCLEAR              "swSendForClearing"
#define SWS_XMLTAG_WILLSETTLE             "swSendForSettlement"
#define SWS_XMLTAG_NETTINGSTRING          "swNettingString"
#define SWS_XMLTAG_BATCHID                "swBatchId"
#define SWS_XMLTAG_PRIVATE_BATCHID        "swPrivateBatchId"
#define SWS_XMLTAG_ADDITIONAL_FIELD1      "swPrivateAdditionalField1"
#define SWS_XMLTAG_ADDITIONAL_FIELD2      "swPrivateAdditionalField2"
#define SWS_XMLTAG_ADDITIONAL_FIELD3      "swPrivateAdditionalField3"
#define SWS_XMLTAG_ADDITIONAL_FIELD4      "swPrivateAdditionalField4"
#define SWS_XMLTAG_ADDITIONAL_FIELD5      "swPrivateAdditionalField5"
#define SWS_XMLTAG_BRCURR                 "currency"
#define SWS_XMLTAG_BRAMNT                 "amount"
#define SWS_XMLTAG_ID                     "id"
#define SWS_XMLTAG_FIELDNAME              "fieldName"
#define SWS_XMLTAG_ADDFIELD               "swAdditionalField"
#define SWS_XMLTAG_SEQ                    "sequence"
#define SWS_XMLTAG_SYSMSGS                "SystemMessages"
#define SWS_XMLTAG_MESSAGE                "Message"
#define SWS_XMLTAG_MESSAGETEXT            "MessageText"
#define SWS_XMLTAG_VALIDFROM              "ValidFromTimestamp"
#define SWS_XMLTAG_VALIDTO                "ValidToTimestamp"
#define SWS_XMLTAG_READ                   "Read"
#define SWS_XMLTAG_ND                     "NonDeliverable"
#define SWS_XMLTAG_CLIENTCLEARING         "ClientClearing"
#define SWS_XMLTAG_BULK_ACTIONS           "BulkActions"
#define SWS_XMLTAG_PER_BATCH              "Batch"
#define SWS_XMLTAG_NAME                   "name"
#define SWS_XMLTAG_DESC                   "description"
#define SWS_XMLTAG_PER_DEAL               "Deal"
#define SWS_XMLTAG_ACTION                 "Action"
#define SWS_XMLTAG_APPID                  "AppId"
#define SWS_XMLTAG_MAJORVERSION           "MajorVersion"
#define SWS_XMLTAG_MINORVERSION           "MinorVersion"
#define SWS_XMLTAG_PRIVATEVERSION         "PrivateVersion"
#define SWS_XMLTAG_SIDE                   "Side"
/* @} */

/**
 * @defgroup csvfamilies CSV Families
 * Constants for CSV family selection in @ref csv2xml functions
 */
/* @{ */
/**
 * @brief The Backload CSV format.
 * When passed as the @c csvFamily parameter to @ref csv2xml functions, the data
 * passed in @c headerRow and @c dataRow is expected to be in the "Backload"
 * CSV format as described in Appendix A of the Unified API Backloading Cookbook.
 */
#define SW_CSV_FAMILY_BACKLOAD            "Backload"
/**
 * @brief The Match CSV format.
 * When passed as the @c csvFamily parameter to @ref csv2xml functions, the data
 * passed in @c headerRow and @c dataRow is expected to be in the "Match"
 * CSV format as described in Appendix B of the Private Matching Cookbook.
 */
#define SW_CSV_FAMILY_MATCH               "Match"
/* @} */

/**
 * @defgroup csvxmltypes CSV XML Types
 * Constants for XML output selection in @ref SW_CSVToXML.
 */
/* @{ */
/**
 * @brief XML representing a deal.
 * When passed as the @a xmlType parameter to @ref SW_CSVToXML, the result is
 * Long form SWDML suitable for submission through SW_SubmitNewDirectDeal(),
 * SW_SubmitNewMatchDeal() or SW_SubmitNewPrimeBrokerDeal().
 */
#define SW_XMLTYPE_LONG_SWDML             "LongSWDML"
/**
 * @brief XML representing private data for a deal.
 * When passed as the @a xmlType parameter to @ref SW_CSVToXML, the result is
 * <a href="./xmlref.html#PrivateData">Private Data XML</a> suitable for passing
 * as the @c privateData argument to deal submission and amendment functions.
 */
#define SW_XMLTYPE_PRIVATE_DATA_XML       "PrivateDataXML"
/**
 * @brief Trade XML.
 * This is an internal format used by MarkitWire.
 */
#define SW_XMLTYPE_TRADE_XML              "TradeXML"
/**
 * @brief XML representing a cancellation fee.
 * When passed as the @a xmlType parameter to @ref SW_CSVToXML, the result is
 * <a href="./xmlref.html#CancellationFee">Cancellation Fee XML</a> suitable for
 * passing as the @c postTradeXML parameter to @ref SW_SubmitPostTradeEvent().
 */
#define SW_XMLTYPE_CANCELLATION_FEE_XML   "CancellationFeeXML"
/**
 * @brief XML representing a deal recipient.
 * When passed as the @a xmlType parameter to @ref SW_CSVToXML, the result is
 * <a href="./xmlref.html#Recipient">Recipient XML</a> suitable for passing as
 * the @c recipientXML parameter to deal submission functions.
 */
#define SW_XMLTYPE_RECIPIENT_XML          "RecipientXML"
/**
 * @brief XML representing an excercise event.
 * When passed as the @a xmlType parameter to @ref SW_CSVToXML, the result is
 * <a href="./xmlref.html#Exercise">Exercise XML</a> suitable for passing as
 * the @c postTradeXML parameter to @ref SW_SubmitPostTradeEvent().
 */
#define SW_XMLTYPE_EXERCISE_XML           "ExerciseXML"
/**
 * @brief XML representing a dispute event.
 * When passed as the @a xmlType parameter to @ref SW_CSVToXML, the result is
 * Dispute XML suitable for passing as the @c disputeXML parameter to
 * @ref SW_DealDispute().
 */
#define SW_XMLTYPE_DISPUTE_XML            "DisputeXML"
/**
 * @brief The message text of the deal.
 * When passed as the @a xmlType parameter to @ref SW_CSVToXML, the result is
 * the free text message for the counterparty of the deal, suitable for passing
 * as the @c messageText parameter to deal submission and amendment functions.
 * @note Unlike the other XML types, this value is returned as a plain string.
 */
#define SW_XMLTYPE_MESSAGE_TEXT           "MessageText"
/* @} */

/**
 * @defgroup staticcategories Static Data Categories.
 * Constants for categories of data that can be returned from @ref SW_GetStaticData.
 */
/* @{ */
/**
 * @brief Supported XML Versions.
 * When passed as the @a dataCategory parameter to @ref SW_GetStaticData, the result is
 * a CSV delimited row containing the supported versions for the type of XML
 * given in @a dataType. For this category of data, @a dataType should
 * be @ref SW_SD_TYPE_SWML_VERSIONS, @ref SW_SD_TYPE_SWDML_VERSIONS, or
 * @ref SW_SD_TYPE_FPML_VERSIONS.
 */
#define SW_SD_CATEGORY_XML_VERSIONS          "XMLVERSIONS"
/**
 * @brief Supported currencies.
 * When passed as the @a dataCategory parameter to @ref SW_GetStaticData, the result is
 * a CSV delimited row containing the system supported currencies. For this
 * category of data, @a dataType should be @ref SW_SD_TYPE_CURRENCIES.
 */
#define SW_SD_CATEGORY_CURRENCIES            "CURRENCIES"
/**
 * @brief CSV Header Data.
 * When passed as the @a dataCategory parameter to @ref SW_GetStaticData, the result is
 * a CSV delimited row containing a default CSV header. The type of header to return
 * is determined by the value passed in @a dataType. For this category of data,
 * @a dataType should be @ref SW_SD_TYPE_CSV_FAMILY_MATCH
 * or @ref SW_SD_TYPE_CSV_FAMILY_BACKLOAD corresponding to the supported @ref csvfamilies
 * for @ref SW_CSVToXML.
 * In the returned results, a column name surrounded by braces, e.g. "(fieldname)",
 * indicates an optional column.
 */
#define SW_SD_CATEGORY_CSV_HEADER            "CSVHEADER"
/**
 * @brief Static Data Extracts.
 * When passed as the @a dataCategory parameter to @ref SW_GetStaticData, the result is
 * either a comma separated list of available static data extracts, which if they were
 * passed as the @a dataCategory parameter would yield the specific mapping data XML.
 */
#define SW_SD_CATEGORY_AVAILABLE_EXTRACTS    "AVAILABLEEXTRACTS"
/**
 * @brief Available XML Types.
 * When passed as the @a dataCategory parameter to @ref SW_GetStaticData(), in
 * conjunction with @a dataType of @ref SW_SD_TYPE_XML_TYPES, the result is
 * a comma separated list of available xml types such as swml, swdml, dealinfo, clearing,
 * publishing, etc.
 */
#define SW_SD_CATEGORY_XML                   "XML"
/**
 * @brief Available TradeID Types
 * When passed as the @a dataCategory parameter to @ref SW_GetStaticData(), in
 * conjunction with @a dataType of @ref SW_SD_TYPE_TRADEID_TYPES, the result is
 * a comma separated list of available TradeID types that could be used in the
 * TradeIdType attribute of QueryDeals, such as ParentPTE, Allocation, Novation,
 * BreakOut, etc.
 */
#define SW_SD_CATEGORY_TRADEID               "TRADEID"
/**
 * @brief Supported MCAs.
 * When passed as the @a dataCategory parameter to @ref SW_GetStaticData, the result
 * is <a href="./xmlref.html#MCDetails">MCA Details XML</a> that specifies
 * the Master Confirmation details configured for the parameters given
 * in the @a dataType parameter.
 *
 * The @a dataType parameter in this case must be
 * valid <a href="./xmlref.html#MCAQueryXML">MCA Query XML</a> that specifies the
 * legal entities and product type to query for.
 */
#define SW_SD_CATEGORY_MCA                   "MCAs"

/**
 * @brief Saved Participant Details.
 * When passed as the @a dataCategory parameter to @ref SW_GetStaticData, the result
 * is <a href="./xmlref.html#sdapi_participantInfoData">Participant Info Data XML</a> that specifies
 * the Participant details configured for the parameters given
 * in the @a dataType parameter.
 *
 * The @a dataType parameter in this case must be
 * valid <a href="./xmlref.html#sdapi_participantInfoQuery">Participant Info Query XML</a> that specifies
 * the usernames and the query.
 */
#define SW_SD_CATEGORY_PARTICIPANT_INFO_DATA                   "PARTICIPANTINFO"

/**
 * @brief Available Eligibility Types.
 * When passed as the @a dataCategory parameter to @ref SW_GetStaticData, in
 * conjunction with @a dataType of @ref SW_SD_TYPE_ELIGIBILITY_TYPES, the result
 * is a comma separated list of available eligibility types such as clearing,
 * publishing, etc.
 */
#define SW_SD_CATEGORY_ELIGIBILITY           "ELIGIBILITY"

/**
 * @brief Reporting Status CSV Header Row.
 * When passed as the @a dataCategory parameter to @ref SW_GetStaticData, in
 * conjunction with @a dataType of @ref SW_SD_TYPE_CSV_REPORTING_COLUMNS,  the result is
 * a comma separated list of the columns of data returned in the output of
 * the @ref SW_DealGetReportingStatus call.
 */
#define SW_SD_CATEGORY_CSV_REPORTING_COLUMNS "REPORTCSVCOLUMNS"
/* @} */

/**
 * @defgroup statictypes Static Data Subtypes
 * Constants for sub types of data that can be returned from @ref SW_GetStaticData.
 * Each sub type is associated with one static data category, see @ref staticcategories.
 */
/* @{ */
/**
 * @brief Supported SWML Versions.
 * When passed as the @a dataType parameter to @ref SW_GetStaticData in conjunction
 * with passing @a dataCategory @ref SW_SD_CATEGORY_XML_VERSIONS, returns a
 * CSV row containing the currently supported SWML versions for all products.
 */
#define SW_SD_TYPE_SWML_VERSIONS           "SWML"
/**
 * @brief Supported SWDML versions.
 * When passed as the @a dataType parameter to @ref SW_GetStaticData in conjunction
 * with passing @a dataCategory @ref SW_SD_CATEGORY_XML_VERSIONS, returns a
 * CSV row containing the currently supported SWDML versions for all products.
 */
#define SW_SD_TYPE_SWDML_VERSIONS          "SWDML"
/**
 * @brief Supported FpML versions.
 * When passed as the @a dataType parameter to @ref SW_GetStaticData in conjunction
 * with passing @a dataCategory @ref SW_SD_CATEGORY_XML_VERSIONS, returns a
 * CSV row containing the currently supported FpML versions for all products.
 */
#define SW_SD_TYPE_FPML_VERSIONS           "FpML"
/**
 * @brief Supported currencies.
 * When passed as the @a dataType parameter to @ref SW_GetStaticData in conjunction
 * with passing @a dataCategory @ref SW_SD_CATEGORY_CURRENCIES, returns a
 * CSV row containing the currently supported currencies for all products.
 */
#define SW_SD_TYPE_CURRENCIES              "CURRENCIES"
/**
 * @brief Backload family CSV header row.
 * When passed as the @a dataType parameter to @ref SW_GetStaticData in conjunction
 * with passing @a dataCategory @ref SW_SD_CATEGORY_CSV_HEADER, returns the
 * default headings for backload family CSV. See @ref SW_CSVToXML.
 */
#define SW_SD_TYPE_CSV_FAMILY_BACKLOAD     "Backload"
/**
 * @brief Match family CSV header row.
 * When passed as the @a dataType parameter to @ref SW_GetStaticData in conjunction
 * with passing @a dataCategory @ref SW_SD_CATEGORY_CSV_HEADER, returns the
 * default headings for match family CSV. See @ref SW_CSVToXML.
 */
#define SW_SD_TYPE_CSV_FAMILY_MATCH        "Match"
/**
 * @brief List of available user mappings for your participant.
 * When passed as the @a dataType parameter to @ref SW_GetStaticData in conjunction
 * with passing @a dataCategory @ref SW_SD_CATEGORY_AVAILABLE_EXTRACTS, returns the
 * list of available user mappings for your participant, separated by commas (',').
 */
#define SW_SD_TYPE_XML_TYPES                "XmlTypes"
/**
 * @brief List of available eligibility types for @ref SW_DealCheckEligibility().
 * When passed as the @a dataType parameter to @ref SW_GetStaticData in conjunction
 * with passing @a dataCategory @ref SW_SD_CATEGORY_ELIGIBILITY, returns the
 * list of available eligibility types, separated by commas (',').
 */
#define SW_SD_TYPE_ELIGIBILITY_TYPES        "EligibilityTypes"
/**
 * @brief Reporting Status CSV Header Row.
 * When passed as the @a dataType parameter to @ref SW_GetStaticData in conjunction
 * with passing @a dataCategory @ref SW_SD_CATEGORY_CSV_REPORTING_COLUMNS, returns the
 * list of columns returned in the output of @ref SW_DealGetReportingStatus, separated by commas (',').
 */
#define SW_SD_TYPE_CSV_REPORTING_COLUMNS    "REPORTCSVCOLUMNS"
/**
 * @brief Available TradeID Types
 * When passed as the @a dataType parameter to @ref SW_GetStaticData in conjunction
 * with passing @a dataCategory @ref SW_SD_CATEGORY_TRADEID, returns the list of
 * available TradeID types, separated by commas (','), that could be used in the
 * TradeIdType attribute of QueryDeals.
 */
#define SW_SD_TYPE_TRADEID_TYPES             "TRADEIDTYPES"
/* @} */

/**
 * @defgroup capabilities User Capabilities
 * Constants for capabilities to enable extended API functionality.
 */
/* @{ */
/**
 * @brief Enable MatchInfo notifications for matching deals.
 * When passed as the @a capability parameter to @ref SW_SetCapability in conjunction
 * with passing @a enable with a non-zero integer, MatchInfo notifications will be raised
 * for matching deals.
 * @note Enabling this capability means that New-Match deal notifications where the
 * new state is @c Released, @c Pending or @c Withdrawn will not be delivered, unless
 * the capability @ref SW_CAP_MATCHINFO_NOTIFICATIONS_UNFILTERED is also set.
 */
#define SW_CAP_MATCHINFO_NOTIFICATIONS "MatchInfoNotifications"
/**
 * @brief Do not filter normal matching notifications when MatchInfo notifications are enabled.
 * When passed as the @a capability parameter to @ref SW_SetCapability in conjunction
 * with passing @a enable with a non-zero integer, deal sink notifications that are
 * normally filtered when @ref SW_CAP_MATCHINFO_NOTIFICATIONS are enabled will be
 * delivered in addition to MatchInfo notifications.
 */
#define SW_CAP_MATCHINFO_NOTIFICATIONS_UNFILTERED "MatchInfoNotificationsUnfiltered"
/**
 * @brief Enable ReportInfo notifications for Reporting Status Changes.
 * When passed as the @a capability parameter to @ref SW_SetCapability in conjunction
 * with passing @a enable with a non-zero integer, ReportInfo notifications will be raised
 * for updates to Reporting Status.
 * This setting is persistent between logins, if this behaviour is not required then it is
 * necessary that the capability is disabled prior to logout by calling
 * @ref SW_SetCapability with @a enable set to an integer with value zero.
 */
#define SW_CAP_REPORTINFO_NOTIFICATIONS "ReportInfoNotifications"
/**
 * @brief Filter ReportInfo notifications for Reporting Status Changes.
 * When passed as the @a capability parameter to @ref SW_SetCapability in conjunction
 * with passing @a enable with a non-zero integer, ReportInfo notifications will be further
 * filtered to those which have a status of Requested, Completed or Error.
 * To disable this behaviour call @ref SW_SetCapability with @a enable set to an integer
 * with value zero.
 */
#define SW_CAP_REPORTINFO_NOTIFICATIONS_FILTER "ReportInfoNotificationsFilter"
/**
 * @brief Return ReportInfo notifications data in XML format.
 * When passed as the @a capability parameter to @ref SW_SetCapability in conjunction
 * with passing @a enable with a non-zero integer, specifies that the notification
 * data will be in XML Format.
 */
#define SW_CAP_REPORTING_STATUS_XMLFORMAT "ReportInfoNotifXMLFORMAT"
/**
 * @brief Enable Reporting elements in SWML.
 * When passed as the @a capability parameter to @ref SW_SetCapability in conjunction
 * with passing @a enable with a non-zero integer, extended tags regarding
 * Regulatory Reporting will be generated in 4.x SWML output.
 * This setting is persistent between logins, if this behaviour is not required then it is
 * necessary that the capability is disabled prior to logout by calling
 * @ref SW_SetCapability with @a enable set to an integer with value zero.
 */
#define SW_CAP_INCLUDE_REPORTING_INFO_SWML "IncludeReportingInfoSWML"
/**
 * @brief Enable Reporting elements in SWML regardless of which regimes the trade falls into.
 * When passed as the @a capability parameter to @ref SW_SetCapability in conjunction
 * with passing @a enable with a non-zero integer, extended tags regarding
 * Regulatory Reporting will be generated in 4.x SWML output.
 * This setting is persistent between logins, if this behaviour is not required then it is
 * necessary that the capability is disabled prior to logout by calling
 * @ref SW_SetCapability with @a enable set to an integer with value zero.
 */
#define SW_CAP_INCLUDE_ALL_REGIMES_SWML "IncludeAllRegimesSWML"
/**
 * @brief Enable Business Conduct elements in SWML.
 * When passed as the @a capability parameter to @ref SW_SetCapability in conjunction
 * with passing @a enable with a non-zero integer, extended tags regarding
 * Regulatory Reporting will be generated in 4.x SWML output.
 * This setting is persistent between logins, if this behaviour is not required then it is
 * necessary that the capability is disabled prior to logout by calling
 * @ref SW_SetCapability with @a enable set to an integer with value zero
 */
#define SW_CAP_INCLUDE_BUSINESS_CONDUCT_DETAILS_SWML "IncludeBusinessConductDetailsSWML"
/**
 * @brief Enable Returning extended information from SW_GetLegalEntities().
 * When passed as the @a capability parameter to @ref SW_SetCapability in conjunction
 * with passing @a enable with a non-zero integer, more information will be
 * returned in the resulting <a href="./xmlref.html#LegalEntity">Legal Entity XML</a>.
 */
#define SW_CAP_EXTENDED_LE_RESULT_XML "ExtendedLEResultXML"
/**
 * @brief Enable ISDA 2021 style structures in output SWML for legacy non-ISDA 2021 trades.
 * When passed as the @a capability parameter to @ref SW_SetCapability in conjunction with
 * passing @a enable with a non-zero integer, legacy trades will output the new ISDA 2021
 * style structures in SWML; i.e. output info in new xPaths within FpML as opposed to
 * in Extended Trade Details. Products that are applicable for this User Capability are
 * Break specific ones: IRS, OIS, Swaption, CapFloor, Basis Swap, Cross Currency Basis Swap,
 * Cross Currency IRS, Fixed Fixed Swap, ZC Inflation Swap.
 */
#define SW_CAP_USE_2021_SWML42_FOR_NONISDA2021 "Use2021SWML4.2ForNonISDA2021"
/* @} */

/**
 * @defgroup xmlbookingstates Booking States
 * Deal booking states that can be returned in XML.
 */
/* @{ */
#define SWS_XMLTAG_BKSTATE_PENDING        "Pending"
#define SWS_XMLTAG_BKSTATE_WITHDRAWN      "Withdrawn"
#define SWS_XMLTAG_BKSTATE_NOTPICKEDUP    "Not Picked Up"
#define SWS_XMLTAG_BKSTATE_DONE           "Done"
#define SWS_XMLTAG_BKSTATE_RELEASED       "Released"
#define SWS_XMLTAG_BKSTATE_RECEIVED       "Received"
#define SWS_XMLTAG_BKSTATE_ERROR          "Error"
#define SWS_XMLTAG_BKSTATE_VALIDATED      "Validated"
#define SWS_XMLTAG_BKSTATE_CLEARED        "Cleared"
#define SWS_XMLTAG_BKSTATE_EXPIRED        "Expired"
#define SWS_XMLTAG_BKSTATE_EXPT_EXP       "All (except Expired)"
/* @} */

/**
 * @defgroup contractstates Contract States
 * System reserved deal contract states.
 */
/* @{ */
#define SWS_XMLTAG_CSTATE_ALL                   "All"
#define SWS_XMLTAG_CSTATE_EXPT_EX               "All (except Exercised-Cash & Exercised-Physical)"
#define SWS_XMLTAG_CSTATE_ALLOCATED             "Allocated"
#define SWS_XMLTAG_CSTATE_AMENDED               "Amended"
#define SWS_XMLTAG_CSTATE_AMENDED_ALLOC         "Amended-Allocated"
#define SWS_XMLTAG_CSTATE_AMENDED_CLEARING      "Amended-Clearing"
#define SWS_XMLTAG_CSTATE_AMENDED_MATCH         "Amended-Match"
#define SWS_XMLTAG_CSTATE_CANCELLED             "Cancelled"
#define SWS_XMLTAG_CSTATE_CANCELLED_MATCH       "Cancelled-Match"
#define SWS_XMLTAG_CSTATE_CANCELLED_POSITION    "Cancelled-Position"
#define SWC_XMLTAG_CSTATE_CLEARING              "Clearing"
#define SWC_XMLTAG_CSTATE_CLEARING_TAKEUP       "Clearing-Takeup"
#define SWS_XMLTAG_CSTATE_EXERCISED             "Exercised"
#define SWS_XMLTAG_CSTATE_EX_CASH               "Exercised-Cash"
#define SWS_XMLTAG_CSTATE_EX_CASH_MATCH         "Exercised-Cash-Match"
#define SWS_XMLTAG_CSTATE_EX_PHY                "Exercised-Physical"
#define SWS_XMLTAG_CSTATE_EX_PHY_MATCH          "Exercised-Physical-Match"
#define SWS_XMLTAG_CSTATE_EXIT                  "Exit"
#define SWS_XMLTAG_CSTATE_EXIT_MATCH            "Exit-Match"
#define SWS_XMLTAG_CSTATE_NEW                   "New"
#define SWS_XMLTAG_CSTATE_NEW_ALLOCATION        "New-Allocation"
#define SWS_XMLTAG_CSTATE_NEW_CLEARING          "New-Clearing"
#define SWS_XMLTAG_CSTATE_MATCHING              "New-Match"
#define SWS_XMLTAG_CSTATE_NEW_NOVATED           "New-Novated"
#define SWS_XMLTAG_CSTATE_NEW_NOVATED_ALLOC     "New-Novated-Allocated"
#define SWC_XMLTAG_CSTATE_NEW_OUTSIDE_NOV       "New-OutsideNovation"
#define SWC_XMLTAG_CSTATE_NEW_OUTSIDE_NOV_MATCH "New-OutsideNovation-Match"
#define SWS_XMLTAG_CSTATE_NEW_POSITION          "New-Position"
#define SWC_XMLTAG_CSTATE_NEW_PRIME_BROKERED    "New-PrimeBrokered"
#define SWS_XMLTAG_CSTATE_NOVATED               "Novated"
#define SWS_XMLTAG_CSTATE_NOVATED_ALLOC         "Novated-Allocated"
#define SWC_XMLTAG_CSTATE_NOVATED_PARTIAL       "Novated-Partial"
#define SWC_XMLTAG_CSTATE_NOVATED_PARTIAL_ALLOC "Novated-Partial-Allocated"
#define SWC_XMLTAG_CSTATE_PRIME_BROKERED        "PrimeBrokered"
/* @} */

/*
 * Deal 'actions' as 4-char mnemonics.
 */
#define SW_ACTION_UNKNOWN                "UNKN"
#define SW_ACTION_PICKUP                 "PCKP"
#define SW_ACTION_REJECT                 "RJCT"
#define SW_ACTION_ACCEPT                 "ACPT"
#define SW_ACTION_AFFIRM                 "AFRM"
#define SW_ACTION_WITHDRAW               "WDRW"
#define SW_ACTION_AMEND                  "AMND"
#define SW_ACTION_CANCEL                 "CANC"
#define SW_ACTION_TERMINATE              "TERM"
#define SW_ACTION_TRANSFER               "TXFR"
#define SW_ACTION_RELEASE                "RELS"

/**
 * @defgroup newstates New States
 * New state values.
 */
/* @{ */
#define SWS_NEWSTATE_ACPT                  "Accepted"
#define SWS_NEWSTATE_ACPTWITHTHRDPTY       "AcceptedWithThirdParty"
#define SWS_NEWSTATE_AFFIRM                "Affirm"
#define SWS_NEWSTATE_ALLCHILDRENACTIONED   "AllAllocationsActioned"
#define SWS_NEWSTATE_ALLCHILDRENCLEARED    "AllAllocationsCleared"
#define SWS_NEWSTATE_BETATRADESCREATED     "BetaTradesCreated"
#define SWS_NEWSTATE_CANCELACK             "CancelAcknowledged"
#define SWS_NEWSTATE_CANCELLED             "Cancelled"
#define SWS_NEWSTATE_CHAT                  "Chat"
#define SWS_NEWSTATE_CHILDCLEAREDUPDATE    "AllocationsCountUpdate"
#define SWS_NEWSTATE_CPTYAFFIRM            "CptyAffirm"
#define SWS_NEWSTATE_CPTYCHAT              "CptyChat"
#define SWS_NEWSTATE_DECLEARED             "Decleared"
#define SWS_NEWSTATE_DONE                  "Done"
#define SWS_NEWSTATE_FORCEACK              "ForceAcknowledge"
#define SWS_NEWSTATE_MINIBLOCKSUPDATE      "MiniBlocksUpdate"
#define SWS_NEWSTATE_PICKEDUP              "PickedUp"
#define SWS_NEWSTATE_PRIMEAGREE            "PrimaryAgree"
#define SWS_NEWSTATE_REGFORCLEARING        "RegisteredForClearing"
#define SWS_NEWSTATE_REGFORPUBLISHING      "RegisteredForPublishing"
#define SWS_NEWSTATE_REJ                   "Rejected"
#define SWS_NEWSTATE_REJFORCLEARING        "RejectedForClearing"
#define SWS_NEWSTATE_REJFORCLEARINGUPDATE  "RejectedForClearingUpdate"
#define SWS_NEWSTATE_REJFORPUBLISHING      "RejectedForPublishing"
#define SWS_NEWSTATE_RELEASED              "Released"
#define SWS_NEWSTATE_REQREV                "RequestRevision"
#define SWS_NEWSTATE_RESUBPICKUP           "ResubmitPickedUp"
#define SWS_NEWSTATE_SAACCEPTED            "SAAccepted"
#define SWS_NEWSTATE_SAPARKED              "SAParked"
#define SWS_NEWSTATE_SAREJECTED            "SARejected"
#define SWS_NEWSTATE_SASENT                "SASent"
#define SWS_NEWSTATE_SENT                  "Sent"
#define SWS_NEWSTATE_SENTFORCLEARING       "SentForClearing"
#define SWS_NEWSTATE_SENTFORCLEARINGUPDATE "SentForClearingUpdate"
#define SWS_NEWSTATE_SENTFORPUBLISHING     "SentForPublishing"
#define SWS_NEWSTATE_TRANPICKUP            "TransferPickup"
#define SWS_NEWSTATE_TRANSFERRED           "Transferred"
#define SWS_NEWSTATE_UPDFORCLEARING        "UpdatedForClearing"
#define SWS_NEWSTATE_WITHDRAWN             "Withdrawn"
#define SWS_NEWSTATE_WITHDRAWNBYMATCH      "WithdrawnByMatch"

/* @} */

/**
 * @defgroup fieldlimits Field Limits
 * Maximum field lengths for certain data types.
 */
/* @{ */
/** The maximum length of free text parameters */
#define SW_FREE_TEXT_MAXLEN               2000
/** The maximum length of @c swNovationExecutionTradeId given in PrivateData or SinkUpdate XML */
#define TRADEID_MAXLEN                    38
#define MAJVER_MAXLEN                     6  /**< Unused */
#define UNIQUEVER_MAXLEN                  38 /**< Unused */
#define PRIVATEVER_MAXLEN                 6  /**< Unused */
#define SIDE_MAXLEN                       2  /**< Unused */
/** The maximum length of @c swPrivateBookingState given in PrivateData or SinkUpdate XML */
#define BKSTATE_MAXLEN                    219
/** The maximum length of @c swNettingString given in PrivateData or SinkUpdate XML */
#define NETTINGSTRING_MAXLEN              2000
/** The maximum length of @c swClearIfEligible given in PrivateData or SinkUpdate XML */
#define CLEARIFELIGIBLE_MAXLEN            5
/** The maximum length of @c swSendForConfirmation given in PrivateData or SinkUpdate XML */
#define SENDFORCONFIRMATION_MAXLEN        5
#define CSTATE_MAXLEN                     219 /**< Unused */
/** The maximum length of @c swPrivateDealSinkConfirmation given in PrivateData or SinkUpdate XML */
#define SINKCONF_MAXLEN                   2000
#define DATE_MAXLEN                       14  /**< Unused */
/** The maximum length of @c swTradingBookId given in PrivateData or SinkUpdate XML */
#define BOOKID_MAXLEN                     2000
/** The maximum length of party identifiers such as @c swClearingBrokerId, @c swPrivateFundId, @c swTraderId etc given in PrivateData or SinkUpdate XML */
#define PARTYID_MAXLEN                    2000
/** The maximum length of @c swSalesCredit given in PrivateData or SinkUpdate XML */
#define SALESCREDIT_MAXLEN                2000
/** The maximum length of @c swPrivateDealSinkComment given in PrivateData or SinkUpdate XML */
#define COMMENT_MAXLEN                    2000
/** The maximum length of @c swBrokerageAmount/currency given in PrivateData or SinkUpdate XML */
#define BRCURR_MAXLEN                     2000
/** The maximum length of @c swBrokerageAmount/amount given in PrivateData or SinkUpdate XML */
#define BRAMOUNT_MAXLEN                   2000
/** The maximum length of any @c swAdditionalField elements given in PrivateData or SinkUpdate XML */
#define ADDITIONALFIELD_MAXLEN            2000
/** The maximum length of @c swExecutionMode given in PrivateData or SinkUpdate XML */
#define EXECMODE_MAXLEN                   20
/** The maximum length of @c batchName for @ref SW_BatchGetOutstanding */
#define BATCHNAME_MAXLEN                  240
/** The maximum length of @c swInterOpTradeId or @c swOtherPartyInterOpTradeId given in PrivateData or SinkUpdate XML */
#define INTEROPID_MAXLEN                  40
/** The maximum length of an @ref SW_BrokerDealID id. */
#define SWB_DEAL_ID_MAXLEN                40
/** The maximum length of an @ref SW_BrokerDealID leg id. */
#define SWB_LEG_ID_MAXLEN                 20
/** The maximum length of GLOBAL UTI values such as @c swDFReporting/swGlobalUTI given in PrivateData or SinkUpdate XML */
#define GLOBAL_UTI_MAXLEN                 52
/** The maximum length of USI values such as @c swDFReporting/swPriorUSI and @c swDFReporting/swBlockUSI given in PrivateData or SinkUpdate XML */
#define USI_MAXLEN                        32
/** The maximum length of USI namespace values such as @c swDFReporting/swPriorUSINamespace and @c swDFReporting/swBlockUSINamespace given in PrivateData or SinkUpdate XML */
#define USI_NAMESPACE_MAXLEN              10
/** The maximum length of UTI values such as @c swJFSAReporting/swPriorUSI and @c swJFSAReporting/swBlockUSI given in PrivateData or SinkUpdate XML */
#define UTI_MAXLEN                        40
/** The maximum length of UTI namespace values such as @c swJFSAReporting/swPriorUTINamespace and @c swJFSAReporting/swBlockUTINamespace given in PrivateData or SinkUpdate XML */
#define UTI_NAMESPACE_MAXLEN              20

/* @} */

/**
 * @defgroup xml_type Types of XML returned by SW_DealGetXML
 */
/* @{ */
/** @brief SWML.
 * When passed as the @a xmlType parameter of @ref SW_DealGetXML, the data returned
 * is SWML. See @ref swmlversions for the supported SWML versions that can be passed
 * as the @a xmlVersion parameter in this case.
 */
#define SWX_SWML "swml"

/** The xml type for SWDML */
#define SWX_SWDML "swdml"

/** The xml type, SWDML, for a swaptions underlying swap */
#define SWX_Underlying "underlying"

/** @brief Clearing XML.
 * When passed as the @a xmlType parameter of @ref SW_DealGetXML, the data returned
 * is <a href="./xmlref.html#ClearingXML">Clearing XML</a>. See @ref fpmlversions for
 * the supported Clearing XML versions that can be passed as the @a xmlVersion parameter
 * in this case.
 */
#define SWX_Clearing "clearing"

/** @brief Publishing XML.
 * When passed as the @a xmlType parameter of @ref SW_DealGetXML, the data returned
 * is <a href="./xmlref.html#PublishingXML">Publishing XML</a>. See @ref fpmlversions for
 * the supported Publishing XML versions that can be passed as the @a xmlVersion parameter
 * in this case.
 */
#define SWX_Publishing "publishing"

/** @brief NettingInstructionResp XML.
 * When passed as the @a xmlType parameter of @ref SW_DealGetXML, the data returned
 * is <a href="./xmlref.html#NettingInstructionRespXML">NettingInstructionResp XML</a>. Supported versions
 * are simply ignored for this XML type.
 */
#define SWX_NettingInstructionResp "nettinginstructionresp"

/** @brief Deal State Information XML.
 * When passed as the @a xmlType parameter of @ref SW_DealGetXML, the data returned
 * is <a href="./xmlref.html#DealState">Deal State Information XML</a>. See @ref dealstateversions for
 * the supported Deal State Information XML versions that can be passed as the @a xmlVersion parameter
 * in this case.
 */
#define SWX_DealStateInfo "dealinfo"
/* @} */

/**
 * @defgroup eligibility_types Eligibility types available for SW_DealCheckEligibility
 */
/* @{ */
/** Eligibility for clearing*/
#define SWE_Clearing                    "clearing"
/** Eligibility for publishing*/
#define SWE_Publishing                  "publishing"
/* @} */

/* @} */
#endif /* SW_API_CONSTANTS_DEFINES_H */
