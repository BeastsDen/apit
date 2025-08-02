#if defined (_MSC_VER) && _MSC_VER > 1000
#pragma once
#endif

#ifndef SW_API_H
#define SW_API_H

#ifndef SW_API_VER
#define SW_API_VER 500
#endif

#include "sw_api_types.h"
#include "sw_api_errorcodes.h"
#include "sw_api_constants.h"

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
   MarkitSERV MarkitWire API header file.

   The following ifdef block is the standard way of creating macros which make exporting
   from a DLL simpler. All files within this DLL are compiled with the SW_CLIENT_EXPORTS
   symbol defined on the command line. this symbol should not be defined on any project
   that uses this DLL. This way any other project whose source files include this file see
   SW_CLIENT_API functions as being imported from a DLL, whereas this DLL sees symbols
   defined with this macro as being exported.
   Note that on non-Win32 platforms, both macros expand to nothing.
 */
#ifndef SWIG
#if defined (WIN32)
#ifdef SW_CLIENT_EXPORTS
#define SW_CLIENT_API
#else
#define SW_CLIENT_API __declspec(dllimport)
#endif
/*
   This normally comes from windef.h via windows.h, but define it for anyone
   not using them
 */
#ifndef STDAPICALLTYPE
#define STDAPICALLTYPE __stdcall
#endif
#else
#define SW_CLIENT_API
#ifndef STDAPICALLTYPE
#define STDAPICALLTYPE
#endif
#endif
#else
/* SWIG is defined */

#define SW_CLIENT_API
#ifndef STDAPICALLTYPE
#define STDAPICALLTYPE
#endif

#endif

/**
 * @mainpage MarkitSERV MarkitWire API Documentation
 *
 * The following documentation covers the C language interface to the
 * MarkitWire API.
 *
 * The available functions are grouped into modules and
 * can be visited from the <a href="modules.html">Modules</a> page.
 *
 * Additionally, please see the following additional documentation:
 * @li <a href="./relnotes.html">Release Notes</a>. This document
 * gives instructions for users upgrading from a previous versions.
 * @li <a href="./versions.html">Supported Platforms</a>. This document
 * lists the operating systems and platforms supported by the MarkitWire API.
 * @li <a href="./xmlref.html">XML Reference</a>. This document describes
 * the format of various XML parameters used by API functions, with
 * examples.
 * @li <a href="./thin_api_network.html">Thin API Networking Guide</a>. This document details the
 * networking configuration required to connect to the Thin API services.
 * @li <a href="./tracing.html">Tracing</a>. This document details the
 * steps required to enable tracing information, in the event that
 * MarkitSERV Customer Services require extra information to diagnose an issue.
 */

/**
 * @page MarkitWire Removed Calls
 *
 * The following documentation covers the removed MarkitWire API call.
 *
 * The full removed call list can be found from following document:
 * @li <a href="./removedcalls.html">Removed Calls</a>.
 *
 * The deprecated API calls list can be visited from
 * the <a href="deprecated.html">Deprecated List</a> page.
 *
 */

/**
 * @page MW DealSink New State Constant List and API Constant List
 *
 * The following documentation covers the MarkitWire New State constants in
 * notification via DealSink.
 *
 * The full DealSink constants list can be found from following document:
 * @li <a href="./dsconstantlist.html">DealSink - New States</a>.
 *
 * The existing API calls constant list can be visited from
 * the <a href="group__newstates.html">API New States</a> page.
 *
 */

#if !defined (SWIG) || defined (SW_EXPOSE_RESOURCE_FUNCTIONS)
/** @defgroup resource Resource Management
 * @brief Functions to allocate and release API resources.
 *
 * Strings passed to the API are taken to be normal, constant nul-terminated
 * C strings. Passing invalid pointer values, including strings, will result
 * in undefined behavior. @c NULL may be passed only where explicitly stated
 * in this documentation. Once an API call has returned, the user is free to
 * modify or release any string parameters that were passed to it.
 *
 * Strings returned by the API are similarly normal nul-terminated C strings.
 * The user should not attempt to change any of the bytes or read past the
 * terminating nul of any returned string. All returned strings must be
 * released using SW_ReleaseString() once the user is finished with the
 * result. Failure to do this will result in memory leaks.
 *
 * The best practice for resource handling with the API is as follows:
 * - Always set the output parameter to @c NULL before calling the API.
 * - Always free the output parameter after calling the API, even if the
 *   API call failed.
 *
 * @note These functions are not available through the SWIG generated api
 * wrappers (e.g. Java), since these do not require manual memory management.
 */

/**
 * @ingroup resource
 * @brief Allocate a string.
 * @details Returns a string allocated by the API. Such strings must be released
 * using SW_ReleaseString() to prevent memory leaks.
 * @note This function is primarily for MarkitWire to provide backward
 * compatibility with previous versions of the API. In general, users
 * should prefer to use memory allocation from their own C run-time.
 * @param size The size of the string to allocate.
 */
SW_CLIENT_API
char* STDAPICALLTYPE SW_AllocateString(unsigned size);

/**
 * @ingroup resource
 * @brief Release a string allocated by the API.
 * @details Release a string that was allocated by a previous API call
 * or SW_AllocateString(). Note that passing @c NULL for @a buffer is not an error.
 * @param buffer The string to release.
 * @return Nothing.
 */
SW_CLIENT_API
void STDAPICALLTYPE SW_ReleaseString(const char* buffer);

#endif /* SWIG */

/** @defgroup connection Connection/Login */

/**
 * @ingroup connection
 * @brief Load the API configuration from a file.
 * @details This function loads API configuration settings from the file named by the
 * @a iniFile parameter.
 * Calling this function is optional. If you call it, you must do so before
 * calling any other API functions.  If you do not call it, or the call
 * returns an error and your application continues anyway, the API will
 * use compiled in default values for its configuration. Calling this function
 * after calling any other API function or after a previous successful call
 * to it has no effect, regardless of whether an error is returned by it.
 * Alternatively, on unix (solaris, linux), if a file named sw_client_api.ini
 * is present in the current working directory or any ancestor thereof this file
 * will be automatically loaded by the api.
 * This behavour also occurs under Windows.
 * @param iniFile The path to a MarkitWire ini file, without the ".ini" extension.
 * @param apiVersion The version of the API the application is compiled against.
 *     Applications should pass @ref SW_API_VER for this parameter.
 * @return @ref ErrorCodes. @ref SWERR_BadParameter is returned if @a iniFile
 * can not be found in the applications directory or any directory above it.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_Initialise(const char* iniFile,
                                        int         apiVersion);

/**
 * @ingroup connection
 * @brief Initiate a connection to the MarkitWire server.
 * @details Returns a session handle in @a sh_out.
 * The client connects to the server. When the API
 * succeeds or gives up the session callback function will be called.
 * It is not necessary to wait for the session callback function to be
 * called before calling the next function (e.g. SW_Login()) as all functions
 * will wait (for up to the timeout period) if the connection is not present.
 * The connection callback, if used, will be called if the API detects any
 * serious problems with the connection to the server. If the connection
 * is lost momentarily, then the API will automatically attempt to
 * re-connect, and if successful, the service will continue un-interrupted
 * (including any actions that were in-flight over the interruption).
 * Depending on how the connection is severed, it will usually take some time
 * before the connection loss is reported via the callback (typically 90
 * seconds, but up to 5.5 minutes + the larger of your timeout or 90 seconds
 * for a black hole router).
 * @param server address of the MarkitWire server with optional port,
 * e.g. "https://mw.uat.api.markit.com" (defaults to port 443)
 * Pass @c NULL or an empty string to use the server(s) defined
 * in the ini file.
 * @param timeout Time in seconds to wait for responses from server.
 * @param tag Pointer that is passed into the callback routine when called.
 * @param[out] sh_out Destination for the session handle representing the connection.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_Connect(const char*   server,
                                     int           timeout,
                                     void*         tag,
                                     SW_SessionID* sh_out);
/**
 * @ingroup connection
 * @brief Disconnect from the MarkitWire server.
 * @details Terminate the connection to the MarkitWire server.
 * @param sh Session handle returned from SW_Connect().
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_Disconnect(SW_SessionID sh);

/**
 * @ingroup connection
 * @brief Set a string to identify this session.
 * @param sh Session handle returned from SW_Connect().
 * @param infoString String to associate with the session.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SetApplicationInfo(SW_SessionID sh,
                                                const char*  infoString);

/**
 * @ingroup connection
 * @brief Login to a previously connected session.
 * @details This function associates an established session connection with a login
 * to a server. Only one login per API connection is currently allowed at any
 * one time. If the call succeeds, @a lh_out contains the resulting login handle.
 * @param sh Session handle returned from SW_Connect().
 * @param userID User name to connect with.
 * @param password Password for @a userID.
 * @param[out] lh_out Destination for the returned @ref SW_LoginID.
 * @return @ref ErrorCodes @ref SWERR_WrongUsernameOrPassword
 * @sa SWERR_TempDirFail
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_Login(SW_SessionID sh,
                                   const char*  userID,
                                   const char*  password,
                                   SW_LoginID*  lh_out);

/**
 * @ingroup connection
 * @brief Login on behalf of another user.
 * @details Similar to SW_Login(), with the difference that this function allows a user
 * with sufficient privileges to work on behalf of another user.
 * @note this function is permission restricted for internal MarkitWire services only.
 * @param sh Session handle returned from SW_Connect().
 * @param adminID User name to connect with.
 * @param password Password for @a adminID.
 * @param userID User name of the user to work on behalf of.
 * @param[out] lh_out Destination for the returned @ref SW_LoginID.
 * @return @ref ErrorCodes @ref SWERR_WrongUsernameOrPassword
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_LoginOnBehalf(SW_SessionID sh,
                                           const char*  adminID,
                                           const char*  password,
                                           const char*  userID,
                                           SW_LoginID*  lh_out);

/**
 * @ingroup connection
 * @brief Log out a user from the MarkitWire system.
 * @details Once a user is logged out by calling this function, @a lh is no longer
 * valid and should not be used again. If the client application logs in
 * again, the new handle returned from SW_Login() should be used for
 * API calls from that point.
 * Calling SW_Logout deregisters any callback handlers installed via previous
 * calls to the following functions with the login handle lh:
 *  SW_RegisterDealNotifyCallback
 *  SW_RegisterDealNotifyExCallback
 *  SW_RegisterBatchCallback
 *
 * i.e. it is equivalent to another call to the SW_RegisterXXX function with
 * the callback ptr argument set to null (0) and after the call to SW_Logout
 * returns it is guaranteed that there will be no further callbacks for the
 * login handle.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_Logout(SW_LoginID lh);

/**
 * @ingroup connection
 * @brief Indicate a clients ability or inability to handle extended API functionality.
 * @details This function enables extended functionality for the user it is
 * called on. By enabling capabilities the user can access non-backward
 * compatible functionality on an opt-in basis. For example, the user can
 * indicate that they wish to receive more information in returned XML,
 * or that they are capable of processing newly added notifications.
 *
 * Calling this function with @a enable as a non-zero value enables
 * the given capability for the user, while passing @a enable as @c 0
 * disables it. Capabilities are not persisted across logins, so they
 * should be set after every successful call to @ref SW_Login.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param capability The particular capability the user wishes to
 * enable. See @ref capabilities for a list of available capabilities.
 * @param enable Whether to enable (non-zero) or disable (zero) @a capability.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SetCapability(SW_LoginID  lh,
                                           const char* capability,
                                           int         enable);

/**
 * @ingroup connection
 * @brief Get the capabilities of the logged in user.
 * @details This function returns the set of capabilities previously
 * set by the caller using @ref SW_SetCapability, as a comma separated list.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param result_out Destination for the returned list of
 * capabilities. See @ref capabilities for a list of capabilities.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetCapabilities(SW_LoginID   lh,
                                             const char** result_out);

/**
 * @ingroup connection
 * @brief Change a Users Password.
 * @details Allows the password for a given user to be changed.
 * @param sh Session handle returned from SW_Connect().
 * @param userID User's ID
 * @param password Password for @a userID.
 * @param newPassword New password for @a userID. This must be at least eight
 *     characters in length, contain both characters and digits, and not be in
 *     the users password history (the last 12 passwords used).
 * @return @ref ErrorCodes, @ref SWERR_WrongUsernameOrPassword, @ref SWERR_PasswordInvalid
 *     @ref SWERR_PasswordInHistory
 * @deprecated Deprecated, and will not be supported by Markitwire.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_ChangePassword(SW_SessionID sh,
                                            const char*  userID,
                                            const char*  password,
                                            const char*  newPassword);

/** @defgroup notifications Notifications */

/**
 * @ingroup notifications
 * @brief Set the callback threading mode.
 * @details The API notifies various events via function callbacks, which
 * can occur either synchronously or asynchronously.
 * - In @em synchronous mode, callbacks happen when the user calls SW_Poll().
 *   Failure to poll frequently enough will result in delayed notification
 *   delivery and growth of the internal notification queue.
 * - In @em asynchronous mode, callbacks can occur at any time from an internal
 *   API thread. You must take care to ensure your handlers are thread-safe.
 * @note The default callback mode is SWCM_Synchronous.
 * @param callbackMode @ref SWCM_Synchronous or @ref SWCM_Asynchronous
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SetCallbackMode(enum SW_CallbackMode callbackMode);

/**
 * @ingroup notifications
 * @brief Register a session state callback.
 * @details Registers a function to call when the state of the server
 * connection changes or an asynchronous internal action fails.
 *
 * Only one callback can be set at a time; each call to this function
 * overwrites any previous callback. @a cfunc is called according to
 * the mode set in @ref SW_SetCallbackMode(). Due to various operating
 * system limits and internal processing, the session state may not
 * be updated for several minutes when a change occurs.
 *
 * The following error codes are reported through @a cfunc:
 * - @ref SWERR_Connected
 * Called when the session is connected. This is usually the trigger to
 * start processing from outside of the callback.
 * - @ref SWERR_LostConnection
 * Called when the session is disconnected. This is usually the trigger to
 * sleep for a small period of time (several seconds), call
 * @ref SW_Disconnect() and then SW_Connect() within the callback before
 * returning. @a cfunc will be called again with whether the connection
 * was successful.
 * - @ref SWERR_UserLoggedOut
 * Called when a user has been logged out, typically because they have
 * logged in from another process. This is usually the trigger to re-login
 * within the callback, then start processing from outside of the callback.
 * Note that there is a one to one relationship between the @ref SW_SessionID
 * passed to @a cfunc and the users @ref SW_LoginID. The application should
 * store the session and login handle of each user so the user to login/out
 * can be determined.
 * - @ref SWERR_InternalError
 * Called when an internal error has occurred while processing asynchronous
 * actions on the client or server. When this occurs you should contact
 * Customer Services with the results of @ref SW_GetLastErrorSpecificsEx.
 * In the event that this error is reported, the users login and connected
 * state are indeterminate, and as such calling any deal processing or
 * connection related functions will have undefined results. Following the
 * delivery of this notification, the users login and connection will be terminated
 * internally, and a new notification will be made with code @ref SWERR_LostConnection.
 * it is recommended that your process exit and restart on reciept of this error,
 * unless you have been advised by customer services that it is safe to continue
 * under the specific circumstances that triggered the error.
 *
 * @param cfunc The callback function to register, or @c NULL to disable the callback.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_RegisterSessionStateCallback(SW_SessionStateCallbackPtr cfunc);

/**
 * @ingroup notifications
 * @brief Register a callback for deal notifications.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param tag User data to pass to the callback function.
 * @param cfunc The callback function to register, or @c NULL to disable the callback.
 * @note @a cfunc @em replaces any previous callback set with this function.
 * @return @ref ErrorCodes
 * @deprecated Deprecated in favour of @ref SW_RegisterDealNotifyExCallback,
 * which provides more information.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_RegisterDealNotifyCallback(SW_LoginID               lh,
                                                        void*                    tag,
                                                        SW_DealNotifyCallbackPtr cfunc);
/**
 * @ingroup notifications
 * @brief Register an extended callback for deal notifications.
 * @details Ensures that @a cfunc will be called whenever an event
 * occurs on a users deals.
 *
 * See SW_SetCallbackMode() for how the callback mode affects when this
 * callback is called.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param tag User data to pass to the callback function.
 * @param cfunc The callback function to register, or @c NULL to disable the callback.
 * @note @a cfunc @em replaces any previous callback set with this function.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_RegisterDealNotifyExCallback(SW_LoginID                 lh,
                                                          void*                      tag,
                                                          SW_DealNotifyExCallbackPtr cfunc);
/**
 * @ingroup notifications
 * @brief Register a callback for batch notifications.
 * @details Ensures that @a cb will be called whenever a batch event
 * occurs which includes a users deals. See SW_SetCallbackMode() for
 * how the callback mode affects when this callback is called.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param tag User data to pass to the callback function.
 * @param cb The callback function to register, or @c NULL to disable the callback. See @ref SW_BatchCallback.
 * @note @a cb @em replaces any previous callback set with this function.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_RegisterBatchCallback(SW_LoginID          lh,
                                                   void*               tag,
                                                   SW_BatchCallbackPtr cb);

/**
 * @ingroup notifications
 * @brief Poll for notifications.
 * @details Polls for notifications to be delivered synchronously to any
 * registered callbacks.
 *
 * @note This function only needs to be used if the synchronous callback mechanism
 * is used. If the asynchronous callback mechanism is used, calling this
 * function will result in some callbacks being called from the
 * same thread that calls this function, and some from the internal thread. See
 * @ref SW_SetCallbackMode for more details.
 *
 * When this function is called, any undelivered notifications are passed to
 * the callback handlers set by @ref SW_RegisterDealNotifyExCallback,
 * @ref SW_RegisterBatchCallback and @ref SW_RegisterSessionStateCallback.
 * Callbacks are made on the same thread that calls this function. If no
 * callback is set, the notification is ignored.
 *
 * This function returns after @a maxtime milliseconds elapse, or when all
 * notifications have been processed and there have been no new notifications
 * for @a timeout milliseconds. The times passed are indicative only and should
 * not be used for timing.
 *
 * For a typical single threaded application calling SW_Poll() periodically,
 * a large value (60,000ms or 60s) for maxtime and a timeout of zero will
 * cause all outstanding notifications to be processed. However the ideal
 * values will depend on the overall behavior of your application.
 *
 * @param maxtime Milliseconds to spend processing notifications.
 * @param timeout Milliseconds to wait once there are no notifications to process.
 *   Passing @c -1 will cause an indefinite wait.
 * @return Either SWERR_Success if all notifications are passed to the users
 * callback(s) correctly, or @ref SWERR_InternalError if an internal error occurs.
 * If the function returns @ref SWERR_InternalError you should contact customer
 * services for resolution of the issue.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_Poll(int maxtime,
                                  int timeout);

/** @defgroup error Error Handling */

/**
 * @ingroup error
 * @brief Get a human readable description of an error code.
 * @details This function returns a string describing the given error code,
 * suitable for displaying to a user.
 * @param errorCode An error code returned by a MarkitWire API call.
 * @param[out] result_out Destination for the returned description. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetErrorDescription(SW_ErrCode   errorCode,
                                                 const char** result_out);

/**
 * @ingroup error
 * @brief Get a human readable description of an error code.
 * @deprecated Deprecated in favour of @ref SW_GetErrorDescription,
 * which uses the standard API resource handling strategy. See @ref resource.
 * @details This function returns a string describing the given error code,
 * suitable for displaying to a user.
 * @param errorCode An error code returned by a MarkitWire API call.
 * @return A string describing @a errorCode, or @c NULL if @a errorCode
 * is not recognised.
 * @note The string returned is static and should @em not be released by the user. The
 *   string is only valid until the next API call is made, so if you wish to
 *   hold it for any period of time, you must make a copy. Using the returned
 *   pointer after calling another API function may cause your application to crash.
 */
SW_CLIENT_API
const char* STDAPICALLTYPE SW_ErrorStr(SW_ErrCode errorCode);

/**
 * @ingroup error
 * @brief Return more information about the last error.
 * @details Returns additional information about the last error that occurred.
 * This is helpful for developers in particular to get more information when
 * debugging. When reporting an unexpected API problem to customer services,
 * the output of this function should be included in with the problem report.
 *
 * If no error has occurred, an empty string is returned. The error state
 * is cleared after calling this function, so subsequent calls will continue
 * to return an empty string until another error occurs.
 *
 * @note This function must be called from the same thread on which the
 * function that returned an error was called.
 *
 * @param[out] result_out Destination for the returned error information. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetLastErrorSpecificsEx(const char** result_out);

/**
 * @ingroup error
 * @brief Return more information about the last error.
 * @deprecated This function has been deprecated in favour of @ref SW_GetLastErrorSpecificsEx,
 * which uses the standard API resource handling strategy. See @ref resource.
 * @details Returns additional information about the last error that occurred.
 * See @ref SW_GetLastErrorSpecificsEx for details.
 *
 * @return A string giving information about the last error that occurred, or @c NULL
 *   if the function encounters an internal error.
 * @note Unlike most other functions that return output parameters, this function
 * returns its output directly. However, the user @em must free the returned
 * string using SW_ReleaseString(), even if empty, or memory leaks will result.
 */
SW_CLIENT_API
const char* STDAPICALLTYPE SW_GetLastErrorSpecifics();

/** @defgroup api Dealer Actions */

/**
 * @ingroup api
 * @brief Get Information about Users and Interest Groups.
 * @details This function returns all users and interest groups for
 * the given MarkitWire participant.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param addressListQueryXML <a href="./xmlref.html#AddressListQuery">Query XML</a> containing the search criteria.
 * @param[out] resultXML_out Destination for the returned <a href="./xmlref.html#AddressList">Address List XML</a>. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetAddressList(SW_LoginID lh,
                                            SW_XML     addressListQueryXML,
                                            SW_XML*    resultXML_out);

/**
 * @ingroup api
 * @brief Get information about the currently logged on user.
 * @details This function returns addressing information like
 * SW_GetAddressList(), but only for the current user.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param[out] resultXML_out Destination for the returned <a href="./xmlref.html#AddressList">Address List XML</a>. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetMyUserInfo(SW_LoginID lh,
                                           SW_XML*    resultXML_out);

/**
 * @ingroup util
 * @brief Return static data for the current user.
 * @details This function returns static data applicable to the current user.
 * The data returned can be used to validate data before passing it to
 * other API functions, to provide introspection facilities, or to display
 * input choices in a graphical interface without requiring a hard coded
 * list of constants that may change in future API versions.
 *
 * Returned data is typically a string or a row of CSV delimited values.
 * Please see @ref staticcategories and @ref statictypes for a description of
 * the kinds of data this function can return and their output format.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param dataCategory The category of data to return, see @ref staticcategories.
 * @param dataType The type of data within @a dataCategory, see @ref statictypes.
 * @param[out] result_out Destination for the returned data. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetStaticData(SW_LoginID  lh,
                                           const char* dataCategory,
                                           const char* dataType,
                                           SW_XML*     result_out);

/**
 * @ingroup api
 * @brief Map a @ref SW_DealerDealState to a human readable string.
 * @details Returns a human readable string for the given @ref SW_DealerDealState.
 * @param dealerDealStateCode The @ref SW_DealerDealState to return a string for.
 * @return A string constant corresponding to @a dealerDealStateCode, or
 *         @c NULL if @a dealerDealStateCode is invalid.
 * @note The returned string is constant and should @em not be released
 * by the caller.
 */
SW_CLIENT_API
const char* STDAPICALLTYPE SW_DealerDealStateStr(enum SW_DealerDealState dealerDealStateCode);

/** @defgroup broker Broker Actions */

/**
 * @ingroup broker
 * @brief Get the broker deal ID for a given MarkitWire deal ID.
 * @details This function maps a MarkitWire deal id back to the broker's internal deal id.
 * The resulting id will be stored in @a brokerDealID_out, or if an error occurs,
 * @a brokerDealID_out will be set to @c NULL.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param dealID The MarkitWire deal identifier. see @ref SW_DealID.
 * @param[out] brokerDealID_out Destination for the resulting @ref SW_BrokerDealID. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetBrokerIDfromSwapsWireID(SW_LoginID       lh,
                                                        SW_DealID        dealID,
                                                        SW_BrokerDealID* brokerDealID_out);
/**
 * @ingroup broker
 * @brief Get information about a brokered deal.
 * @details This function returns information about a brokered deal, such
 * as the recipients, state and versions of the deal.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param brokerDealID The broker's internal deal id, see @ref SW_BrokerDealID.
 * @param[out] dealInfo_out Destination for the resulting <a href="./xmlref.html#DealInfo">Deal Info XML</a>. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_BrokeredDealGetInfo(SW_LoginID      lh,
                                                 SW_BrokerDealID brokerDealID,
                                                 SW_XML*         dealInfo_out);
/**
 * @ingroup broker
 * @brief Get information about brokered deals clearing status.
 * @details This function returns information about brokered deals clearing status
 * in the <a href="./xmlref.html#BrokerClearingStatus">Broker Clearing Status</a> XML format.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param queryXML <a href="./xmlref.html#queryXML">Query XML</a> containing the search criteria.
 * @param[out] resultXML_out XML file which contains the deal clearing status. See @ref resource.
 * @return @ref ErrorCodes
 */

SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetBrokerClearingStatus(SW_LoginID lh,
                                                     SW_XML     queryXML,
                                                     SW_XML*    resultXML_out);
/**
 * @ingroup broker
 * @brief Get deal SWBML.
 * @details Get the SWBML/SWML representation of a deal.
 * For brokered deals submitted through the api, the SWBML initially submitted is
 * returned. For deals that were composed in the tc_client application, SWML is
 * returned.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param brokerDealID The broker's internal deal id, see @ref SW_BrokerDealID.
 * @param revisionNumber The revision number of the deal to query, see @ref SW_DealMinorVersion.
 * @param contractVersion The contract version of the deal to query, see @ref SW_DealMajorVersion.
 * @param[out] resultXML_out Destination for the resulting SWBML. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_BrokeredDealGetXML(SW_LoginID          lh,
                                                SW_BrokerDealID     brokerDealID,
                                                SW_DealMinorVersion revisionNumber,
                                                SW_DealMajorVersion contractVersion,
                                                SW_XML*             resultXML_out);
/**
 * @ingroup broker
 * @brief Get the Recipient XML for one side of the deal.
 * @details This function returns the <a href="./xmlref.html#Recipient">Recipient XML</a>
 * for the specified side of a given deal. This is the Recipient XML that was
 * passed when the deal was originally submitted by the broker.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param brokerDealID The broker's internal deal id, see @ref SW_BrokerDealID.
 * @param revisionNumber The revision number of the deal to query, see @ref SW_DealMinorVersion.
 * @param contractVersion The contract version of the deal to query, see @ref SW_DealMajorVersion.
 * @param recipientID The recipient to get the Recipient XML for. See @ref SW_BrokerRecipientID.
 * @param[out] resultXML_out Destination for the resulting <a href="./xmlref.html#Recipient">Recipient XML</a>. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_BrokeredDealGetRecipientXML(SW_LoginID           lh,
                                                         SW_BrokerDealID      brokerDealID,
                                                         SW_DealMinorVersion  revisionNumber,
                                                         SW_DealMajorVersion  contractVersion,
                                                         SW_BrokerRecipientID recipientID,
                                                         SW_XML*              resultXML_out);
/**
 * @ingroup broker
 * @brief Get the name of the user who picked up one side of a brokered deal.
 * @details This function returns the name of the trader who picked up the
 * deal for a specified deal recipient. If the deal has been picked up by different traders,
 * the returned value is name of trader who did last pickup before the deal got accepted.
 * If the deal has not been picked up, the string returned will be empty.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param brokerDealID The broker's internal deal id, see @ref SW_BrokerDealID.
 * @param revisionNumber The revision number of the deal to query, see @ref SW_DealMinorVersion.
 * @param contractVersion The contract version of the deal to query, see @ref SW_DealMajorVersion.
 * @param recipientID The recipient to get the pickup trader for. See @ref SW_BrokerRecipientID.
 * @param[out] identity_out Destination for the returned traders identity. See @ref resource.
 * @return @ref ErrorCodes
 * @deprecated Deprecated in favour of @ref SW_BrokeredDealGetInfo. Users should
 * read the returned @c Recipient/PickUpUserId from that function to obtain
 * the deals sides pickup identities.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_BrokeredDealGetPickupIdentityByRecipient(SW_LoginID           lh,
                                                                      SW_BrokerDealID      brokerDealID,
                                                                      SW_DealMinorVersion  revisionNumber,
                                                                      SW_DealMajorVersion  contractVersion,
                                                                      SW_BrokerRecipientID recipientID,
                                                                      const char**         identity_out);
/**
 * @ingroup broker
 * @brief Get the reason why one side of a brokered deal was rejected.
 * @details This function returns the reason why a trader rejected or
 * requested a revision of their side of a brokered deal, if they gave one.
 * If the deal has not been rejected then an empty string is returned.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param brokerDealID The broker's internal deal id, see @ref SW_BrokerDealID.
 * @param revisionNumber The revision number of the deal to query, see @ref SW_DealMinorVersion.
 * @param contractVersion The contract version of the deal to query, see @ref SW_DealMajorVersion.
 * @param recipientID The recipient to get the reject reason for. See @ref SW_BrokerRecipientID.
 * @param[out] rejectReason_out Destination for the returned reason. See @ref resource.
 * @return @ref ErrorCodes
 * @deprecated Deprecated in favour of @ref SW_BrokeredDealGetInfo. Users should
 * read the returned @c Recipient/RejectReason from that function to obtain
 * the deals sides rejection reasons.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_BrokeredDealGetRejectReasonByRecipient(SW_LoginID           lh,
                                                                    SW_BrokerDealID      brokerDealID,
                                                                    SW_DealMinorVersion  revisionNumber,
                                                                    SW_DealMajorVersion  contractVersion,
                                                                    SW_BrokerRecipientID recipientID,
                                                                    const char**         rejectReason_out);

/**
 * @ingroup broker
 * @brief Return summary information for deals in an Ended state.
 * @details This function returns information about ended deals that have either
 * been accepted by both dealers or been cancelled by the broker before
 * the dealers have accepted them (and so will never become a valid deal).
 *
 * A time range can be specified to limit the data returned to deals submitted
 * from @a endedTimeStartSpan up to but not including @a endedTimeCloseSpan.
 * Note that @a endedTimeCloseSpan may be given as a time in the future. However,
 * if @a endedTimeStartSpan is after @a endedTimeCloseSpan, @ref SWERR_BadParameter
 * will be returned.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param endedTimeStartSpan Start date for the search. See @ref SW_TimeSpan.
 * @param endedTimeCloseSpan End date for the search. This may be a time in
 *     the future. See @ref SW_TimeSpan.
 * @param[out] resultXML_out Destination for returned <a href="./xmlref.html#DealInfo">Deal Info XML</a>.See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetEndedDealInfo(SW_LoginID   lh,
                                              SW_TimeSpan  endedTimeStartSpan,
                                              SW_TimeSpan  endedTimeCloseSpan,
                                              const char** resultXML_out);

/**
 * @ingroup broker
 * @brief Return summary information for deals in an Ended state.
 * @details This function returns information about ended deals that have either
 * been accepted by both dealers or been cancelled by the broker before
 * the dealers have accepted them (and so will never become a valid deal).
 *
 * This function returns the details of deals matching a given set of search
 * criteria. The _queryXML_ must be given as <a href="./xmlref.html#EndedDealInfoQuery">Ended Deal Info XML</a>.
 *
 *
 * Extra
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param queryXML <a href="./xmlref.html#EndedDealInfoQuery">Query XML</a> containing the search criteria
 * @param[out] queryResultXML_out Destination for returned <a href="./xmlref.html#DealInfo">Deal Info XML</a>.See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetEndedDealInfoEx(SW_LoginID   lh,
                                                SW_XML       queryXML,
                                                const char** queryResultXML_out);

/**
 * @ingroup broker
 * @brief Terminate a rejected/withdrawn deal.
 * @details This function terminates a deal which has been rejected/withdrawn,
 * such that the deal can no longer be resubmitted.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param brokerDealID The broker's internal deal id, see @ref SW_BrokerDealID.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @note @a newDealVersionHandle_out is not currently populated for this function.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealTerminate(SW_LoginID            lh,
                                           SW_BrokerDealID       brokerDealID,
                                           SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup api
 * @brief Submit a new novation consent deal.
 * @details The submitted SWDML should contain a novation element specifying
 * the Novation Confirmation and optional Fee details.
 * The @a recipientsXML specifies the participant and users for both incoming and
 * remaining parties, the party references used link these to their roles
 * within the Novation as specified in the novation element (see the Dealer
 * API Cookbook for more details).
 * The Outgoing (the party submitting the Novation consent deal) and the Remaining parties must both
 * be parties to this deal.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientsXML <a href="./xmlref.html#Recipients">Recipients XML</a> containing the intended recipients.
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitNewBackloadAndNovateDeal(SW_LoginID            lh,
                                                            SW_XML                SWDML,
                                                            SW_XML                privateDataXML,
                                                            SW_XML                recipientsXML,
                                                            const char*           messageText,
                                                            SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup broker
 * @brief Submit a new brokered or prime brokered (client clearing) deal.
 * @details Submits a brokered or prime brokered deal on behalf of the broker.
 *
 * Each recipient specified in @a recipientsXML  include an @c id attribute which
 * is used to differentiate the recipients for further calls. An API user may
 * decide to simply hard-code these IDs as "_1", "_2" and "_3", or may use a more sophisticated
 * scheme, as long as within a single deal the recipients have different
 * IDs. These IDs must be given in order to make use of further
 * recipient data. Within the deal XML the IDs are also used to link the
 * recipients to a particular side of the deal, i.e. to identify the
 * fixed and floating rate payers (brokered trade) or the Client, Executing Broker and Prime Broker (prime brokered trade).
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param recipientsXML <a href="./xmlref.html#Recipients">Recipients XML</a> containing the two
 * recipients involved in the brokered trade, or the three recipients involved in the prime brokered trade.
 * @param dealXML <a href="./xmlref.html#SWBML">SWBML</a> describing the deal.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes, @ref SWERR_DuplicateID
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitNewBrokeredDealEx(SW_LoginID            lh,
                                                     SW_XML                recipientsXML,
                                                     SW_XML                dealXML,
                                                     SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup broker
 * @brief Resubmit a prime brokered deal that had previously been withdrawn or revision requested.
 * @details Resubmits a new version and/or new addressing details for a previously
 * submitted deal that is currently in a rejected/withdrawn state
 * following a reject/request for revision.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param recipientsXML <a href="./xmlref.html#Recipients">Recipients XML</a> containing the two
 * recipients involved in the brokered trade, or the three recipients involved in the prime brokered trade.
 * @param dealXML <a href="./xmlref.html#SWBML">SWBML</a> describing the deal.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_ReSubmitNewBrokeredDealEx(SW_LoginID            lh,
                                                       SW_XML                recipientsXML,
                                                       SW_XML                dealXML,
                                                       SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Initiate a new direct deal.
 * @details Submits a new direct deal from the caller to the counterparty
 * given in @a recipientXML.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitNewDirectDeal(SW_LoginID            lh,
                                                 SW_XML                SWDML,
                                                 SW_XML                privateDataXML,
                                                 SW_XML                recipientXML,
                                                 const char*           messageText,
                                                 SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Initiate a new prime broker deal.
 * @details Creates a new prime brokered deal.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientsXML <a href="./xmlref.html#Recipients">Recipients XML</a> containing the intended recipients.
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitNewPrimeBrokerDeal(SW_LoginID            lh,
                                                      SW_XML                SWDML,
                                                      SW_XML                privateDataXML,
                                                      SW_XML                recipientsXML,
                                                      const char*           messageText,
                                                      SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Create a draft deal.
 * @details Create a draft deal on MarkitWire. Applicable for direct deals only.
 * A draft deal is a deal which is not yet sent to the counterparty. It can
 * be used if a deal has to be transferred internally in the organisation
 * before sent to the counterparty. In the context of the API, it
 * has another very important use, that of creating a full representation
 * of a deal on MarkitWire from a short form SWDML. For a
 * simple, standard deal, it is assumed that it is enough to fill in a few
 * key fields (currency, notional, etc.) and rely on market standard values
 * for the rest of the fields. If the ShortForm element of SWDML is used,
 * MarkitWire will supplement the submitted details with the MarkitWire default
 * values, thus creating a full representation of the deal. If LongForm
 * SWDML is submitted, all details about the deal will be contained in the SWDML.
 * Please note that a draft deal is not yet sent to the counterparty. A further
 * action is needed by the Dealer API user to move the deal from the draft state,
 * e.g. SW_DealAffirm() or SW_DealDeleteDraft().
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitDraftNewDeal(SW_LoginID            lh,
                                                SW_XML                SWDML,
                                                SW_XML                privateDataXML,
                                                SW_XML                recipientXML,
                                                const char*           messageText,
                                                SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Submit a draft Prime Broker deal.
 * @details A draft Prime Broker deal is a deal which is not yet sent to the
 * counterparty. It can be used if a deal has to be transferred internally
 * in the organisation before sent to the counterparty.
 *
 * A further action is needed by the Dealer API user to move the deal from the
 * draft state, see SW_DealAffirm() and SW_DealDeleteDraft().
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientsXML <a href="./xmlref.html#Recipients">Recipients XML</a> containing the intended recipients.
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitDraftNewPrimeBrokerDeal(SW_LoginID            lh,
                                                           SW_XML                SWDML,
                                                           SW_XML                privateDataXML,
                                                           SW_XML                recipientsXML,
                                                           const char*           messageText,
                                                           SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Initiate a new backload deal.
 * @details This function is equivalent to the SW_SubmitNewDirectDeal() function, for
 * backloaded deals.
 *
 * @note This function can only be called by AI users. See @ref titypes.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitBackloadDeal(SW_LoginID            lh,
                                                SW_XML                SWDML,
                                                SW_XML                privateDataXML,
                                                SW_XML                recipientXML,
                                                const char*           messageText,
                                                SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @defgroup matching Matching Actions
 * @brief Functions for submitting trades for matching rather than affirmation.
 */

/**
 * @ingroup matching
 * @brief Initiate a new deal via the matching process.
 * @details This function is equivalent to the SW_SubmitNewDirectDeal() function
 * for deals that should be processed via the matching workflow. The deal submitted
 * is created with a contract state of "New-Match". Such deals are matched against
 * existing deals with a New or New-Allocation contract state to create a match.
 *
 * Multiple submissions of the New-Match match records must be preceded
 * with a call to SW_MatchUpdate(). To remove a New-Match matching record
 * from the matching pool a call to SW_MatchDelete() is required.
 *
 * @note This function can only be called by AI users. See @ref titypes.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitNewMatchDeal(SW_LoginID            lh,
                                                SW_XML                SWDML,
                                                SW_XML                privateDataXML,
                                                SW_XML                recipientXML,
                                                const char*           messageText,
                                                SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Initiate a new deal, that may be either a direct- or a match- deal.
 * @details Submits a new deal from the caller to the counterparty
 * given in @a recipientXML, where the system determines
 * whether it is an affirmation or a matching deal.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitNewDirectDealEx(SW_LoginID            lh,
                                                   SW_XML                SWDML,
                                                   SW_XML                privateDataXML,
                                                   SW_XML                recipientXML,
                                                   const char*           messageText,
                                                   SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Cancel a deal.
 * @details <b>This function is reserved for future use. Currently the
 * parameter @a effectiveDate will be ignored and the call will behave in
 * the same way as SW_SubmitCancellation(). However in the future the
 * @a effectiveDate will be enabled. When this happens the call
 * may not have the same consequences as intended. Therefore in order
 * to prevent unpredictable behavior clients are requested not to use
 * this call until further notice.
 * It is recommended that SW_SubmitPostTradeEvent() is used instead.</b>
 * Initiates a cancellation of a deal on MarkitWire. Applicable for direct
 * deals only. For a cancellation, only the cancellation fee can be changed.
 * No bilateral deal changes are allowed (for this, use SW_SubmitPostTradeEvent()).
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param cancellationFeeXML <a href="./xmlref.html#CancellationFee">Cancellation Fee XML</a> defining the cancellation fee.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param effectiveDate The effective date of the cancellation. See @ref SW_TimeSpan.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitCancellationEx(SW_LoginID            lh,
                                                  SW_DealVersionHandle  oldDealVersionHandle,
                                                  SW_XML                cancellationFeeXML,
                                                  SW_XML                privateDataXML,
                                                  SW_XML                recipientXML,
                                                  const char*           messageText,
                                                  SW_TimeSpan           effectiveDate,
                                                  SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Cancel a deal.
 * @details @see SW_SubmitCancellationEx().
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param cancellationFeeXML <a href="./xmlref.html#CancellationFee">Cancellation Fee XML</a> defining the cancellation fee.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitCancellation(SW_LoginID            lh,
                                                SW_DealVersionHandle  oldDealVersionHandle,
                                                SW_XML                cancellationFeeXML,
                                                SW_XML                privateDataXML,
                                                SW_XML                recipientXML,
                                                const char*           messageText,
                                                SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Create a draft cancellation to a deal.
 * @details <b>This function is reserved for future use. Currently the
 * parameter @a effectiveDate will be ignored. However in the future the
 * @a effectiveDate will be enabled. When this happens the call
 * may not have the same consequences as intended. Therefore in order
 * to prevent unpredictable behavior clients are requested not to use
 * this call until further notice.</b>
 * Initiates a draft cancellation of a deal on MarkitWire. Applicable for direct
 * deals only. For a cancellation, only the cancellation fee can be changed.
 * No bilateral deal changes are allowed (for this, use SW_SubmitDraftAmendment()).
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param cancellationFeeXML <a href="./xmlref.html#CancellationFee">Cancellation Fee XML</a> defining the cancellation fee.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param effectiveDate The effective date of the cancellation. See @ref SW_TimeSpan.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitDraftCancellation(SW_LoginID            lh,
                                                     SW_DealVersionHandle  oldDealVersionHandle,
                                                     SW_XML                cancellationFeeXML,
                                                     SW_XML                privateDataXML,
                                                     SW_XML                recipientXML,
                                                     const char*           messageText,
                                                     SW_TimeSpan           effectiveDate,
                                                     SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup matching
 * @brief Submit match cancellation deal.
 * @details <b>This function is reserved for future use. Currently the
 * parameter @a effectiveDate will be ignored and the call will behave in
 * the same way as SW_SubmitMatchCancellation(). However in the future the
 * @a effectiveDate will be enabled. When this happens the call
 * may not have the same consequences as intended. Therefore in order
 * to prevent unpredictable behavior clients are requested not to use
 * this call until further notice.
 * It is recommended that SW_SubmitPostTradeEvent() is used instead.</b>
 * This function is equivalent to the SW_SubmitNewDirectDeal() function
 * for deals that should got through the matching workflow. It creates a deal with
 * a Cancelled-Match contract state. Matching records with a Cancelled-Match
 * contract state are used to match against deals with a Cancelled contract state.
 * A cancelled deal can only be amended through the addition of a cancellation
 * fee. All other amendments to an already submitted record would be with a call
 * to SW_MatchUpdate().
 * The function facilitates the addition of a cancellation fee to the previous
 * Amended-Match or New-Match record that would have a booking state of 'Withdrawn'.
 * The cancellation fee is merged with the previous SWDML to create SWDML for a
 * Cancelled-Match matching record.
 * Multiple submissions of the Cancelled-Match match records will be preceded with a call
 * to SW_MatchUpdate()
 * To remove a Cancelled-Match matching record from the matching pool a call to
 * SW_MatchDelete() is required.
 *
 * @note This function can only be called by AI users. See @ref titypes.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param cancellationFeeXML <a href="./xmlref.html#CancellationFee">Cancellation Fee XML</a> defining the cancellation fee.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param effectiveDate The effective date of the cancellation. See @ref SW_TimeSpan.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitMatchCancellationEx(SW_LoginID            lh,
                                                       SW_DealVersionHandle  oldDealVersionHandle,
                                                       SW_XML                cancellationFeeXML,
                                                       SW_XML                privateDataXML,
                                                       SW_XML                recipientXML,
                                                       const char*           messageText,
                                                       SW_TimeSpan           effectiveDate,
                                                       SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup matching
 * @brief Submit match cancellation deal.
 * @details @see SW_SubmitMatchCancellationEx()
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param cancellationFeeXML <a href="./xmlref.html#CancellationFee">Cancellation Fee XML</a> defining the cancellation fee.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitMatchCancellation(SW_LoginID            lh,
                                                     SW_DealVersionHandle  oldDealVersionHandle,
                                                     SW_XML                cancellationFeeXML,
                                                     SW_XML                privateDataXML,
                                                     SW_XML                recipientXML,
                                                     const char*           messageText,
                                                     SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup clearing
 * @brief Enqueue the netting instruction and return status of the enqueue
 * @details This function submits a new set of netting instructions. The return value only gives confirmation
 * that the enqueue is valid. The results of the netting instructions themselves will be returned in the form
 * of event notifications.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param nettingInstructionXML <a href="./xmlref.html#NettingInstructionXML">Netting Instruction XML</a> containing the instructions to be enqueued and processed.
 * @param[out] correlationId_out Unique id to identify the netting instruction results. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitNettingInstruction(SW_LoginID   lh,
                                                      const char*  nettingInstructionXML,
                                                      const char** correlationId_out);

/**
 * @ingroup api
 * @brief Submit a post-trade event.
 * @details This function allows for amendment, cancellation, exit,
 * exercise and position change for direct and matching deals.
 *
 * @par Exercise
 * - One step physical exercise is submitted by passing <a href="./xmlref.html#Exercise">Exercise XML</a>
 * containing a @c "<physicalExercise>" element containing @c "<createAffirmReleaseSwap>true</createAffirmReleaseSwap>".
 * In this case the underlying deal is created and taken to released automatically.
 * - Two step exercise is submitted by passing <a href="./xmlref.html#Exercise">Exercise XML</a>
 * containing @c "<physicalExercise>" element containing "<createAffirmReleaseSwap>false</createAffirmReleaseSwap>".
 * The SWDML for the underlying swap can then be fetched using @ref SW_DealGetUnderlyingDealSWDML
 * and submitted using @ref SW_SubmitUnderlying to create the swap as a normal affirmation deal.
 * - Cash exercise is submitted by pasing <a href="./xmlref.html#Exercise">Exercise XML</a>
 * containing an @c "<cashExercise>" element.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param postTradeXML XML defining the post trade event. The current implementation
 *     supports <a href="./xmlref.html#Exit">Exit XML</a>,
 *     <a href="./xmlref.html#Cancellation">Cancellation XML</a>,
 *     <a href="./xmlref.html#SWDML">SWDML</a>, and
 *     <a href="./xmlref.html#Exercise">Exercise XML</a>.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitPostTradeEvent(SW_LoginID            lh,
                                                  SW_DealVersionHandle  oldDealVersionHandle,
                                                  SW_XML                postTradeXML,
                                                  SW_XML                privateDataXML,
                                                  SW_XML                recipientXML,
                                                  const char*           messageText,
                                                  SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Exit a Deal.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param exitReason The manditory reason for exiting the deal. Must not be
 *     more than @c SW_FREE_TEXT_MAXLEN characters in length.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @details @see SW_SubmitExitEx().
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitExit(SW_LoginID            lh,
                                        SW_DealVersionHandle  oldDealVersionHandle,
                                        const char*           exitReason,
                                        SW_XML                privateDataXML,
                                        SW_XML                recipientXML,
                                        const char*           messageText,
                                        SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup api
 * @brief Draft amend a deal.
 * @details Submit a draft of an amendment to an existing, non-draft direct deal.
 * The deal resulting from this function is not visible to counterparties
 * and so may be modified or transferred internally within a participant for review.
 * To submit an amendment to a draft version of a deal, such as the draft created
 * when this function succeeds, use SW_DealAmendDraft().
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitDraftAmendment(SW_LoginID            lh,
                                                  SW_DealVersionHandle  oldDealVersionHandle,
                                                  SW_XML                SWDML,
                                                  SW_XML                privateDataXML,
                                                  SW_XML                recipientXML,
                                                  const char*           messageText,
                                                  SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Submit the underlying deal for a swaption.
 * @details This function is used to submit the underlying swap in a two step swaption
 * exercise or following a problem with a one step swaption physical exercise.
 *
 * See @ref SW_SubmitPostTradeEvent for details of the steps required for
 * two step swaption exercise.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The exercised swaption deal to act on, see @ref SW_DealVersionHandle.
 * @param SWDML SWDML defining the bilateral deal details of the underlying deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitUnderlying(SW_LoginID            lh,
                                              SW_DealVersionHandle  oldDealVersionHandle,
                                              SW_XML                SWDML,
                                              SW_XML                privateDataXML,
                                              SW_XML                recipientXML,
                                              const char*           messageText,
                                              SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Submit a deal to be amended into a Prime Brokered deal.
 * @details This function allows a direct deal to be converted into a prime
 * brokered deal.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientsXML <a href="./xmlref.html#Recipients">Recipients XML</a> containing the intended recipients.
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitPrimeBrokerAmendment(SW_LoginID            lh,
                                                        SW_DealVersionHandle  oldDealVersionHandle,
                                                        SW_XML                SWDML,
                                                        SW_XML                privateDataXML,
                                                        SW_XML                recipientsXML,
                                                        const char*           messageText,
                                                        SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Submit a Novation of an existing MarkitWire deal, for direct deals only.
 * @details The submitted SWDML should contain a novation element specifying
 * the Novation Confirmation and optional Fee details.
 * The @a recipientsXML specifies the participant and users for both incoming and
 * remaining parties, the party references used link these to their roles
 * within the Novation as specified in the novation element (see the Dealer
 * API Cookbook for more details).
 * The Outgoing (the party submitting the Novation) and the Remaining parties must both
 * be parties to this deal. The deal must be in a released state for both parties.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientsXML <a href="./xmlref.html#Recipients">Recipients XML</a> containing the intended recipients.
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitNovation(SW_LoginID            lh,
                                            SW_DealVersionHandle  oldDealVersionHandle,
                                            SW_XML                SWDML,
                                            SW_XML                privateDataXML,
                                            SW_XML                recipientsXML,
                                            const char*           messageText,
                                            SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup api
 * @brief Creates a draft novation of an existing deal.
 * @details Creates a draft novation of an existing deal on MarkitWire. Applicable for direct deals only.
 * It can be used if a deal has to be transferred internally in the organisation
 * before being sent to the counterparty.
 * Please note that a draft deal is not yet sent to the counterparty. A further
 * action is needed by the Dealer API user to move the deal from the draft state,
 * e.g. SW_DealAffirm() or SW_DealDeleteDraft().
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientsXML <a href="./xmlref.html#Recipients">Recipients XML</a> containing the intended recipients.
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitDraftNovation(SW_LoginID            lh,
                                                 SW_DealVersionHandle  oldDealVersionHandle,
                                                 SW_XML                SWDML,
                                                 SW_XML                privateDataXML,
                                                 SW_XML                recipientsXML,
                                                 const char*           messageText,
                                                 SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup api
 * @brief Amend a draft deal on MarkitWire.
 * @details Applicable to standard draft deals only.
 * A draft deal is a deal which is not yet sent to the counterparty. It
 * can be used if a deal has to be transferred internally in the
 * organisation before sent to the counterparty.
 * Please note that a draft deal is not yet sent to the counterparty. A further
 * action is needed by the Dealer API user to move the deal from the draft state,
 * see e.g. SW_DealAffirm() and SW_DealDeleteDraft().
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes, @ref SWERR_RecipientsNotRequired
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealAmendDraft(SW_LoginID            lh,
                                            SW_DealVersionHandle  oldDealVersionHandle,
                                            SW_XML                SWDML,
                                            SW_XML                privateDataXML,
                                            SW_XML                recipientXML,
                                            const char*           messageText,
                                            SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Amend a draft deal.
 * @details Amends a draft deal on MarkitWire. Applicable to standard Draft deals only.
 * A draft deal is a deal which is not yet sent to the counterparty. It can
 * be used if a deal has to be transferred internally in the organisation
 * before sent to the counterparty.
 * Please note that a draft deal is not yet sent to the counterparty. A further
 * action is needed by the Dealer API user to move the deal from the draft
 * state, see e.g. SW_DealAffirm() and SW_DealDeleteDraft().
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param recipientsXML <a href="./xmlref.html#Recipients">Recipients XML</a> containing the intended recipients.
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealAmendDraftPrimeBroker(SW_LoginID            lh,
                                                       SW_DealVersionHandle  oldDealVersionHandle,
                                                       SW_XML                SWDML,
                                                       SW_XML                privateDataXML,
                                                       SW_XML                recipientsXML,
                                                       const char*           messageText,
                                                       SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup api
 * @brief Send a free-text dispute message.
 * @details Sends a free-text dispute message to the counterparty in the confirmation process.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param disputeXML XML Describing the dispute.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealDispute(SW_LoginID            lh,
                                         SW_DealVersionHandle  oldDealVersionHandle,
                                         SW_XML                disputeXML,
                                         SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Send a free-text message.
 * @details Sends a free-text message to the counterparty in the confirmation process.
 * Applicable for direct deals only.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealSendChatMessage(SW_LoginID            lh,
                                                 SW_DealVersionHandle  oldDealVersionHandle,
                                                 const char*           messageText,
                                                 SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Picks up the specified version of the deal.
 * @details Note that a valid Book ID in the private data must be set on
 * pickup, either explicitly through @a privateDataXML, or by
 * means of a default Book ID value associated with the user.
 *
 * If for some reason the pickup action cannot be performed (e.g. another
 * user has already picked up the deal or perhaps the broker has
 * terminated the deal), @ref SWERR_ActionUnavailable will be returned.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealPickup(SW_LoginID            lh,
                                        SW_DealVersionHandle  oldDealVersionHandle,
                                        SW_XML                privateDataXML,
                                        SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Accept a Deal from a broker.
 * @details Accepts the specified version of a deal with the broker, or accepts the
 * primary deal only within a prime brokered transaction. Applicable for
 * brokered and prime brokered deals only.
 * To accept a deal with the broker and affirm it with the counterparty at
 * the same time, or to accept a primary prime brokered deal along with the
 * resulting secondary deals, use SW_DealAcceptAffirm().
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * and affirmed.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealAccept(SW_LoginID            lh,
                                        SW_DealVersionHandle  oldDealVersionHandle,
                                        SW_XML                privateDataXML,
                                        SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Accept and Affirm a Deal.
 * @details Accepts the specified version of a deal with the broker and affirms it with
 * the counterparty, or accepts the primary and both resulting secondary
 * deals within a prime brokered transaction. applicable for brokered and prime
 * brokered deals only.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealAcceptAffirm(SW_LoginID            lh,
                                              SW_DealVersionHandle  oldDealVersionHandle,
                                              SW_XML                privateDataXML,
                                              SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Releases the specified version of the deal.
 * @details Applicable for both brokered deals and direct deals.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealRelease(SW_LoginID            lh,
                                         SW_DealVersionHandle  oldDealVersionHandle,
                                         SW_XML                privateDataXML,
                                         SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Reject a brokered deal.
 * @details Applicable for brokered deals only.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealRejectDK(SW_LoginID            lh,
                                          SW_DealVersionHandle  oldDealVersionHandle,
                                          const char*           messageText,
                                          SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Request a revision of the brokered deal.
 * @details Applicable for brokered deals only.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealRequestRevision(SW_LoginID            lh,
                                                 SW_DealVersionHandle  oldDealVersionHandle,
                                                 const char*           messageText,
                                                 SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Reject a deal.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealReject(SW_LoginID            lh,
                                        SW_DealVersionHandle  oldDealVersionHandle,
                                        const char*           messageText,
                                        SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Transfer a deal to another user/interest group.
 * @details Transfers the deal to another user/interest group within the same
 * organisation. Multiple users and/or interest groups can be specified.
 * This function is applicable for both brokered deals and direct deals.
 * At least one of the users to whom the deal is transferred must be
 * logged in for the transfer to take place.
 * The parameter @a transferRecipientXML is used to list the transferees.
 * It may be either a single user name, or alternately either
 * <a href="./xmlref.html#TransferRecipient">Transfer Recipient XML</a>
 * or <a href="./xmlref.html#Recipient">Recipient XML</a>.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param transferRecipientXML XML used to specify the recipient(s)
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes, @ref SWERR_DealTransferToSelf
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealTransfer(SW_LoginID            lh,
                                          SW_DealVersionHandle  oldDealVersionHandle,
                                          SW_XML                privateDataXML,
                                          SW_XML                transferRecipientXML,
                                          const char*           messageText,
                                          SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Withdraw a Deal.
 * @details Withdraw a submitted deal.
 * This function is unusual in that it can be called on dealer and brokered deals.
 *
 * If called by a dealer, you can only withdraw once you have picked up the deal.
 * To reject a deal before it has been picked up, use SW_DealReject() instead.
 * Dealers cannot withdraw trades submitted to them by a broker. To reject
 * a brokered deal, use SW_DealRejectDK() or SW_DealRequestRevision() instead.
 *
 * If called by a broker, @a oldDealVersionHandle must be a valid @ref SW_BrokerDealID
 * that has been previously submitted. Note that withdrawing a brokered deal
 * does not change its contract or revision number.
 *
 * When attempting to Withdraw an already withdraw deal, dealers will
 * receive @ref SWERR_ActionUnavailable. For brokers, the action will succeed,
 * however an empty DVH string will be returned in @a newDealVersionHandle_out
 * in this case. This empty string must still be freed using @ref SW_ReleaseString.
 * This behaviour may change in a future release to return the existing DVH,
 * so applications should be written to expect either no DVH or the existing
 * DVH be returned if this function is called on an already withdrawn brokered deal.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealWithdraw(SW_LoginID            lh,
                                          const char*           oldDealVersionHandle,
                                          SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Acknowledge that a deal has been withdrawn or terminated.
 * @details Acknowledges that a deal version has been withdrawn by the counterparty
 * (in the case of a direct deal) or terminated by the broker (in the case
 * of a brokered deal). Applicable for both brokered deals and direct deals.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealAcknowledge(SW_LoginID            lh,
                                             SW_DealVersionHandle  oldDealVersionHandle,
                                             SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Give control of a deal back to this user.
 * @details This function can be used if the control of the deal has been given
 * to the counterparty by use of SW_DealAffirm(), but the deal has not yet
 * been affirmed by the counterparty. SW_DealPull() will pull back the control
 * so that it can be affirmed again, if e.g. deal details need to be changed.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealPull(SW_LoginID            lh,
                                      SW_DealVersionHandle  oldDealVersionHandle,
                                      SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Continue a deal without the prime broker.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealContinueWithNoPrimeBroker(SW_LoginID            lh,
                                                           SW_DealVersionHandle  oldDealVersionHandle,
                                                           SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Delete the specified draft version. Applicable for direct deals only.
 * @details A user can only delete a draft deal before it has been affirmed (and thus
 * been made a live deal). To withdraw a live deal, use SW_DealWithdraw().
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealDeleteDraft(SW_LoginID            lh,
                                             SW_DealVersionHandle  oldDealVersionHandle,
                                             SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup matching
 * @brief Delete a private matching record.
 * @details This function call would be used to remove matching records that have failed
 * to match. If a matching record finds a match it is removed from the
 * matching pool by the matching process and a call to this function
 * is not required.
 * This function behaves in a similar way to SW_DealDeleteDraft()
 * although rather then being facility to delete draft deals it will enable
 * the deletion of New-Match, Amended-Match and Cancelled-Match matching records
 * that have a booking state of 'Pending' i.e. they have not been matched against
 * any externally submitted deals.
 *
 * @note This function can only be called by AI users. See @ref titypes.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_MatchDelete(SW_LoginID            lh,
                                         SW_DealVersionHandle  oldDealVersionHandle,
                                         SW_DealVersionHandle* newDealVersionHandle_out);
/**
 * @ingroup api
 * @brief Return a text string to identify the specified deal state.
 * @param dealStateCode The deal state to be translated.
 * @return A string representing the state, or NULL if the state is invalid.
 * @note
 * The returned strings should be used for display/information only and
 * should not be parsed by the users application. Since the string is static,
 * it should @em not be release by the user.
 */
SW_CLIENT_API
const char* STDAPICALLTYPE SW_DealStateStr(enum SW_DealState dealStateCode);

/**
 * @ingroup api
 * @brief Compare a deal to its default.
 * @details @param lh The logged in user, see @ref SW_LoginID.
 * @param dealVersionHandle DVH of the deal to compare. See @ref SW_DealVersionHandle.
 * @param[out] resultXML_out XML representing the differences between the
 *  given deal and the generated default deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_QueryDefaultMisMatch(SW_LoginID           lh,
                                                  SW_DealVersionHandle dealVersionHandle,
                                                  SW_XML*              resultXML_out);
/**
 * @ingroup api
 * @brief Get deal SWML.
 * @details This function returns SWML for a given deal.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param swmlVersion The version of SWML to return. See @ref swmlversions.
 * @param dealVersionHandle DVH of the deal to retrieve SWML for. See @ref SW_DealVersionHandle.
 * @param[out] resultXML_out Destination for the returned SWML. See @ref resource.
 * @return @ref ErrorCodes
 * @note See @ref SWERR_UnsupportedXmlVersion
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealGetSWML(SW_LoginID           lh,
                                         const char*          swmlVersion,
                                         SW_DealVersionHandle dealVersionHandle,
                                         SW_XML*              resultXML_out);
/**
 * @ingroup api
 * @brief Get SWDML for a deal.
 * @details This function returns SWDML for a given deal.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param swdmlVersion The version of SWDML to return. See @ref swdmlversions.
 * @param dealVersionHandle DVH of the deal to retrieve SWDML for. See @ref SW_DealVersionHandle.
 * @param[out] resultXML_out Destination for the returned SWDML. See @ref resource.
 * @return @ref ErrorCodes
 * @note See @ref SWERR_UnsupportedXmlVersion
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealGetSWDML(SW_LoginID           lh,
                                          const char*          swdmlVersion,
                                          SW_DealVersionHandle dealVersionHandle,
                                          SW_XML*              resultXML_out);
/**
 * @ingroup api
 * @brief Get SWDML for a swaptions underlying swap.
 * @details This function returns SWDML for the underlying swap of a physically
 * exercised swaption.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param swdmlVersion The version of SWDML to return. See @ref swdmlversions.
 * @param dealVersionHandle DVH of the deal to retrieve SWDML for. See @ref SW_DealVersionHandle.
 * @param[out] resultXML_out Destination for the returned SWDML. See @ref resource.
 * @return @ref ErrorCodes
 * @note See @ref SWERR_UnsupportedXmlVersion
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealGetUnderlyingDealSWDML(SW_LoginID           lh,
                                                        const char*          swdmlVersion,
                                                        SW_DealVersionHandle dealVersionHandle,
                                                        SW_XML*              resultXML_out);
/**
 * @ingroup api
 * @brief Transform SWML to SWDML.
 * @details This function converts the given SWML into SWDML.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param inputSWML SWML to convert to SWDML.
 * @param[out] resultXML_out Destination for the returned SWDML. See @ref resource.
 * @return @ref ErrorCodes
 * @note See @ref SWERR_UnsupportedXmlVersion
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetSWDMLfromSWML(SW_LoginID   lh,
                                              const char*  inputSWML,
                                              const char** resultXML_out);
/**
 * @ingroup api
 * @brief Get long-form SWDML from short-form SWDML.
 * @details This function converts the given short-form SWML to
 *    the requested version of long-form SWDML.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param inputShortFormSWDML short-form SWDML
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s)
 * @param swdmlVersion The version of SWDML to return. See @ref swdmlversions.
 * @param[out] resultXML_out Destination for the returned SWDML. See @ref resource.
 * @return @ref ErrorCodes
 * @note See @ref SWERR_UnsupportedXmlVersion
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetLongFromShortSWDMLEx(SW_LoginID  lh,
                                                     SW_XML      inputShortFormSWDML,
                                                     SW_XML      recipientXML,
                                                     const char* swdmlVersion,
                                                     SW_XML*     resultXML_out);
/**
 * @defgroup csv2xml CSV To XML Conversion
 * @brief Functions for manipulating CSV and converting CSV into XML.
 */

/**
 * @ingroup csv2xml
 * @brief Convert CSV input data into one or more types of XML output.
 * @details This function converts a comma delimited input file into XML
 * suitable for passing into other API functions.
 *
 * There are currently two supported formats of CSV that can be processed
 * by the CSV to XML functions. See @ref csvfamilies for details.
 *
 * The parameter @a headerRow defines the headers of the CSV data to convert and
 * should conform to the definition of the CSV family. Blank or unknown headings
 * will be ignored, as will their assocated data in @a dataRow.
 * The parameter @a dataRow should contain the row of CSV data, with each value
 * in the same order as @a headerRow.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param xmlType The type of XML to convert @a dataRow into. See @ref csvxmltypes.
 * @param xmlVersion The version of XML required. This is only required if
 *   @a xmlType is @ref SW_XMLTYPE_LONG_SWDML, otherwise it is ignored.
 * @param csvFamily The type of CSV in @a dataRow, see @ref csvfamilies.
 * @param headerRow The columns being passed in parameter @a dataRow.
 * @param dataRow A comma delimited line of data, in the format given by @a headerRow.
 * @param[out] resultXML_out Destination for the returned XML. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_CSVToXML(SW_LoginID  lh,
                                      const char* xmlType,
                                      const char* xmlVersion,
                                      const char* csvFamily,
                                      const char* headerRow,
                                      const char* dataRow,
                                      SW_XML*     resultXML_out);
/**
 * @ingroup csv2xml
 * @brief Get a CSV column value
 * @details This function returns a single column value from a passed CSV data row.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param csvFamily The type of CSV in @a dataRow, see @ref csvfamilies.
 * @param columnName The name of the column to get the data from.
 * @param headerRow A comma delimited list of data field headings. See @ref SW_CSVToXML
 * @param dataRow A single comma delimited line of data. If more than one row of data
 *   is present, only the value from the first row will be returned. See @ref SW_CSVToXML
 * @param[out] value_out Destination for the returned column value. See @ref resource.
 * @note If the column @c columnName is not present in @c headerRow, an
 *     empty string will be returned.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_CSVGetColumn(SW_LoginID   lh,
                                          const char*  csvFamily,
                                          const char*  columnName,
                                          const char*  headerRow,
                                          const char*  dataRow,
                                          const char** value_out);

/**
 * @ingroup csv2xml
 * @brief Set a CSV columns values
 * @details This function returns the input CSV rows with values for given column changed.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param csvFamily The type of CSV in @a dataRow, see @ref csvfamilies.
 * @param columnName The name of the column to set the data in.
 * @param newValue The value to put in all this column for each row in @a dataRow.
 * @param headerRow A comma delimited list of data field headings. See @ref SW_CSVToXML.
 * @param dataRow Comma delimited lines of data, each separated by a new line character. See @ref SW_CSVToXML.
 * @param[out] value_out Destination for the returned CSV rows. See @ref resource.
 * @note If the column @c columnName is not present in @c headerRow, @c dataRow
 *     will be returned unchanged.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_CSVSetColumn(SW_LoginID   lh,
                                          const char*  csvFamily,
                                          const char*  columnName,
                                          const char*  newValue,
                                          const char*  headerRow,
                                          const char*  dataRow,
                                          const char** value_out);

/** @defgroup dealver Deal Versioning
 * @brief Functions to manage deal versions.
 *
 * A deal can have many versions, representing the negotiation that took place
 * during its agreement, and post trade events performed on that deal (and
 * their negotiation).  The finest granularity of a deal is the
 * @ref SW_DealVersionHandle (DVH).
 *
 * A DVH is used to identify a specific version of a deal.
 *
 * DVH's also provide a mechanism for guarding against races when multiple
 * users are updating a deal.  Update actions can only take place on the
 * latest DVH (or latest DVH within a major version for some actions).
 * If you attempt to perform an update on a deal which has been modified
 * elsewhere, then you will receive an error (@ref SWERR_HandleNotLatest).
 *
 * Actions by other parties can be happening asynchronously to your actions.
 * Notifications of these actions actions are delivered asynchronously, so
 * even if an DVH appears to be the latest at the time of performing an
 * action, you may receive an @ref SWERR_HandleNotLatest error. You must
 * therefore be prepared to handle this error for every function that
 * modifies a deal.
 *
 * @note If an action results in a collision with another parties action
 * (and @ref SWERR_HandleNotLatest is returned), the deal is immediately
 * brought up to date (such that @ref SW_DealGetDealState() and
 * @ref SW_DealGetVersionHandle() return up to date information as of the
 * collision).  Notifications that would have otherwise informed you that
 * the deal was changing to the new state may not be delivered as a result.
 * Thus if the action you had intended to perform is no longer available
 * or desirable, you should check to see if there is an alternative
 * action you want to perform as a result of the update.
 *
 */

/**
 * @ingroup dealver
 * @brief Get DVH for a Specific Private Version of a Deal.
 * @details This function returns the DVH for the specified dealID,
 * contractVersion, private version and side.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param dealID The MarkitWire deal identifier. see @ref SW_DealID.
 * @param majorVersion The contract version of the deal. See @ref dealversionconstants.
 * @param privateVersion The private version of the deal. See @ref dealversionconstants.
 * @param side The side of the deal. See @ref sideconstants.
 * @param[out] dealVersionHandle_out A string containing the value of the deal
 *   version handle, or NULL if no matching handle is found. See @ref resource.
 * @return @ref ErrorCodes
 *
 * @note If @ref SWS_LATESTVERSION is used, the latest version at that point
 * in time is returned. It is possible that by the time you use that handle
 * another user may have modified the deal (again) and thus even having
 * retrieved the latest DVH you must still expect the possibility of receiving
 * an @ref SWERR_HandleNotLatest error on an update action.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealGetVersionHandle(SW_LoginID            lh,
                                                  SW_DealID             dealID,
                                                  SW_DealMajorVersion   majorVersion,
                                                  SW_DealPrivateVersion privateVersion,
                                                  SW_DealSide           side,
                                                  SW_DealVersionHandle* dealVersionHandle_out);

/**
 * @ingroup dealver
 * @brief Get all DVHs for a deal.
 * @details This function returns all available @ref SW_DealVersionHandle handles
 * for a given @a dealID, @a contractVersion and @a side. This is useful if
 * all changes to the deal need to be tracked. The returned handles can be used
 * to get the SWML for each version of the deal.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param dealID The MarkitWire deal identifier. see @ref SW_DealID.
 * @param majorVersion The contract version of the deal. See @ref dealversionconstants.
 * @param sides The side of the deal, or @ref SWS_ALLSIDES for all sides. See @ref sideconstants.
 * @param[out] dealVersionHandles_out Destination for the returned handles.
 * @note @a dealVersionHandles_out is returned as a list of DVH strings separated by
 *       carriage returns.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealGetAllVersionHandles(SW_LoginID             lh,
                                                      SW_DealID              dealID,
                                                      SW_DealMajorVersion    majorVersion,
                                                      SW_DealSide            sides,
                                                      SW_DealVersionHandles* dealVersionHandles_out);
/**
 * @ingroup dealver
 * @brief Get the non-DVH identifiers for a deal.
 * @details Get the deal id, version, private version and side from a deal version handle
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param dealVersionHandle DVH of the deal to get the DVHs for. See @ref SW_DealVersionHandle.
 * @param[out] dealID_out Destination for the deals MarkitWire identifier. See @ref SW_DealID.
 * @param[out] majorVersion_out Destination for the deals contract version. See @ref SW_DealMajorVersion.
 * @param[out] privateVersion_out Destination for the deals private version. See @ref SW_DealPrivateVersion.
 * @param[out] side_out Destination for the returned deal side.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealGetIDVersionsAndSide(SW_LoginID             lh,
                                                      SW_DealVersionHandle   dealVersionHandle,
                                                      SW_DealID*             dealID_out,
                                                      SW_DealMajorVersion*   majorVersion_out,
                                                      SW_DealPrivateVersion* privateVersion_out,
                                                      SW_DealSide*           side_out);
/**
 * @ingroup api
 * @brief Get the side representing the users side of a deal.
 * @details If possible you should avoid using this function as it will mean your
 * application will not handle internal deals correctly. This function is
 * provided for backward compatibility only.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param dealID The MarkitWire deal identifier. see @ref SW_DealID.
 * @param majorVersion The contract version of the deal. See @ref dealversionconstants.
 * @param[out] side_out Destination for the returned @ref SW_DealSide.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealGetMySide(SW_LoginID          lh,
                                           SW_DealID           dealID,
                                           SW_DealMajorVersion majorVersion,
                                           SW_DealSide*        side_out);
/**
 * @ingroup api
 * @brief Get the deal state for a Deal.
 * @details This function returns the state of the specified deal.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param dealVersionHandle DVH of the deal to get the state for. See @ref SW_DealVersionHandle.
 * @param[out] dealState_out Destination for the deal state.
 * @return The value from the @ref SW_DealState enumeration if >=0,
 * otherwise an error code from @ref ErrorCodes.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealGetDealState(SW_LoginID           lh,
                                              SW_DealVersionHandle dealVersionHandle,
                                              enum SW_DealState*   dealState_out);

/**
 * @ingroup api
 * @brief Get summary information regarding active deals.
 * @details This function returns detailed information about deals that
 * are currently active for the user.
 *
 * When called by a broker, the data is returned as <a href="./xmlref.html#DealInfo">Deal Info XML</a>.
 * When called by dealers, end users or clearing houses, the data is returned
 * as <a href="./xmlref.html#DealState">Deal State Information XML</a>.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param[out] resultXML_out Destination for returned <a href="./xmlref.html#DealInfo">Deal Info XML</a>
 *     or <a href="./xmlref.html#DealState">Deal State Information XML</a>. See @ref resource.
 * @note If no active deals are found, @a resultXML_out will contain an empty document,
 * consisting of only the root element.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetActiveDealInfo(SW_LoginID lh,
                                               SW_XML*    resultXML_out);
/**
 * @ingroup api
 * @brief Get information about all MarkitWire participants.
 * @details This function returns all MarkitWire participants that the
 * user is permissioned to see.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param participantQueryXML <a href="./xmlref.html#ParticipantQuery">Query XML</a> containing the search criteria.
 * @param[out] resultXML_out Destination for returned <a href="./xmlref.html#Participant">Participant XML</a>.See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetParticipants(SW_LoginID lh,
                                             SW_XML     participantQueryXML,
                                             SW_XML*    resultXML_out);
/**
 * @ingroup api
 * @brief Get information on Legal Entities.
 * @details This function returns details of the legal entities belonging to the
 * specified participants. The list of returned legal entities is screened to remove
 * any legal entities that you are not permitted to trade with.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param legalEntityListQueryXML <a href="./xmlref.html#LegalEntityQuery">Query XML</a> containing the search criteria.
 * @param[out] resultXML_out Destination for returned <a href="./xmlref.html#LegalEntity">Legal Entity XML</a>. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetLegalEntities(SW_LoginID lh,
                                              SW_XML     legalEntityListQueryXML,
                                              SW_XML*    resultXML_out);

/**
 * @ingroup api
 * @brief Get interest group subscriptions.
 * @details This function returns interest group subscription details
 * for the current user.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param[out] resultXML_out Destination for the <a href="./xmlref.html#InterestGroup">Interest Group XML</a>
 * containing the users subscription information. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetMyInterestGroups(SW_LoginID lh,
                                                 SW_XML*    resultXML_out);

/**
 * @ingroup api
 * @brief Set interest group subscriptions.
 * @details This function allows the interest group subscription details
 * of the current user to be changed.
 *
 * @note When changing the subscriptions for the current user, only those
 * groups which have been changed need to be present in @a interestGroupXML.
 * Any groups which are not present have their subscription status unchanged.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param interestGroupXML <a href="./xmlref.html#InterestGroup">Interest Group XML</a>
 * containing the new subscription details to set for the user. See @ref resource.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SetMyInterestGroups(SW_LoginID lh,
                                                 SW_XML     interestGroupXML);

/**
 * @ingroup api
 * @brief Get the Permitted Books for the logged in user.
 * @details This function returns details of the permitted books for a logged in user.
 *
 * The permitted books are cached locally on the client, so this function can
 * be called repeatedly without impacting performance. The cached copy of books
 * is updated whenever the user logs in, whenever the user is logged in and an
 * update is made to the permitted book list, and unconditionally once per hour.
 * It is therefore not necessary to connect and disconnect the session in order
 * to ensure that the data returned is current.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param[out] resultXML_out Destination for the <a href="./xmlref.html#BookList">Book List XML</a>
 * containing the users books. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetMyBooks(SW_LoginID lh,
                                        SW_XML*    resultXML_out);

/**
 * @ingroup api
 * @brief Affirm a deal with the counterparty.
 * @details Applicable for both brokered deals and direct deals.
 * Affirming the deal indicates a willingness to accept the deal details.
 * If the counterparty sent the deal to this User, and no changes
 * to the deal details are proposed, this will lead to the deal being
 * affirmed with the counterparty. If no text message is given, messageText
 * should be set to the empty string, not NULL.
 * The parameter @a SWDML contains either the empty string, or a valid SWDML
 * long-form representation of a deal. The empty string will be interpreted
 * as "affirm with no changes", i.e. if the deal was sent to this
 * user by the counterparty, these details will be confirmed. If a
 * non-empty string is supplied, the long-form of the SWDML must be used,
 * If @a SWDML contains valid SWDML, the server will decide whether these details
 * are different from what was previous sent or not. If they are identical,
 * these details will be confirmed. If they are different (e.g. the
 * counterparty sent the wrong payment date holiday centers, and this
 * User is affirming a deal back which contains the right holiday
 * centers), the deal will be sent to the counterparty to decide if they want
 * to confirm the changed details or not.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle
 * of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 * @note @a SWDML may be a blank string, in which case the deal is affirmed
 *       withot changes to the bilateral details.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealAffirm(SW_LoginID            lh,
                                        SW_DealVersionHandle  oldDealVersionHandle,
                                        SW_XML                SWDML,
                                        SW_XML                privateDataXML,
                                        const char*           messageText,
                                        SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup matching
 * @brief Update a private matching record.
 * @details To update a private matching record with any one of the XXX-Match contract
 * states. The function takes the last version of a record pointed to by the
 * oldDealVersionHanlde , creates a new deal with an incremented minor
 * version, withdraws the previous version and overwrites the new version with
 * the contents of SWDML. When a deal cancellation matching record is being
 * updated the parameter @a SWDML must contain
 * <a href="./xmlref.html#CancellationFee">Cancellation Fee XML</a>.
 *
 * @note This function can only be called by AI users. See @ref titypes.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param SWDML SWDML defining the bilateral deal details of the deal.
 * Cancellation XML when used to update a
 * cancellation matching record.
 * @param privateDataXML <a href="./xmlref.html#PrivateData">Private Data XML</a> to set private fields.
 * @param messageText Free-text message for the counterparty.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_MatchUpdate(SW_LoginID            lh,
                                         SW_DealVersionHandle  oldDealVersionHandle,
                                         SW_XML                SWDML,
                                         SW_XML                privateDataXML,
                                         const char*           messageText,
                                         SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup api
 * @brief Submit a valuation report.
 * @details This function is for submitting a variance swap calculation report in csv format.
 * The input csv data should be correctly formatted with all the appropriate
 * column headers. Clients should call @ref SW_GetLastErrorSpecificsEx to get a
 * result status for for each entry included in the report.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param inputCSV The csv delimited data to be submitted
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SubmitValuationReport(SW_LoginID  lh,
                                                   const char* inputCSV);
/**
 * @ingroup api
 * @brief Request a new valuation report.
 * @details This function is for requesting all open and outstanding 'value soon' variance
 * swap positions with all counterparties. The output is a csv delimited list of
 * valuations for the requested period.
 * Set the report date to 0 to retrieve the report for the current period, otherwise
 * setting a valid report date will retrieve a historical report from the date requested.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param reportDate The base valuation date for report retrieval. See @ref SW_TimeSpan.
 * @param[out] csv_out Variance swap calculation report in csv format. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_RequestValuationReport(SW_LoginID   lh,
                                                    SW_TimeSpan  reportDate,
                                                    const char** csv_out);
/**
 * @ingroup api
 * @brief Get the private booking state for a deal.
 * @details Get the private booking state for the given version of a deal.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param dealID The MarkitWire deal identifier. see @ref SW_DealID.
 * @param majorVersion The contract version of the deal. See @ref dealversionconstants.
 * @param side The side of the deal. See @ref sideconstants.
 * @param[out] privateBookingState_out Destination for the returned booking
 *     state. See @ref bookingstates, @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealGetPrivateBookingState(SW_LoginID          lh,
                                                        SW_DealID           dealID,
                                                        SW_DealMajorVersion majorVersion,
                                                        SW_DealSide         side,
                                                        const char**        privateBookingState_out);

/**
 * @ingroup api
 * @brief Get Deal XML.
 * @details This function allows a system to various kinds of information about
 * a deal, in one of several XML output formats.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param dealVersionHandle DVH of the deal to get information XML for. See @ref SW_DealVersionHandle.
 * @param xmlVersion The version of XML of the requested type to return. The
 *   versions available depend on the @a xmlType value passed.
 * @param xmlType The type of XML required. see @ref xml_type.
 * @param[out] resultXML_out Destination for the resulting XML. The type
 *   of XML returned depends on the @a xmlType value passed.  See @ref resource.
 * @return @ref ErrorCodes
 * @note See @ref SWERR_UnsupportedXmlVersion
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealGetXML(SW_LoginID           lh,
                                        SW_DealVersionHandle dealVersionHandle,
                                        const char*          xmlVersion,
                                        const char*          xmlType,
                                        SW_XML*              resultXML_out);

/**
 * @ingroup api
 * @brief Update a deal.
 * @details This function allows one of several updates to be made to a deal,
 * depending on the type of @a inputXML passed.
 *
 * Passing <a href="./xmlref.html#SinkUpdate">Sink Update XML</a> allows private data
 * associated with the deal to be updated, or to submit the deal for clearing.
 *
 * Passing <a href="./xmlref.html#PublishingStatusXML">Publishing Status XML</a> allows
 * the publishing state of a deal to be updated.
 *
 * Clearing Houses can pass <a href="./xmlref.html#ClearingStatusXML">Clearing Status XML</a>
 * to update the clearing status of the deal (for example, to indicate that the deal has been
 * accepted or rejected into the clearing process).
 *
 * Broker can pass <a href="./xmlref.html#BrokerUpdateXML">Broker Update XML</a>
 * to resubmit the deal to clearing.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param dealIdentifier For dealers and Clearing Houses, it is the DVH of the deal to update. See @ref SW_DealVersionHandle.
 *   For broker, it is the broker trade id.
 * @param inputXML XML describing the update(s) to be made to the deal.
 * @param[out] dealUpdateResult_out For dealers and Clearing Houses it is the destination for the @ref SW_DealVersionHandle of the
 *   resulting deal. Note that if the update has no effect on the deal (for example,
 *   you set a private data field to the same value it alreads has), then the returned DVH
 *   may be the same as @a dealVersionHandle. See @ref resource.
 *   For broker it contains the error message if the resubmission to clearing operation is unsuccessful otherwise it contains empty string.
 * @return @ref ErrorCodes, @ref SWERR_DealNotEligibleToClear.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealUpdate(SW_LoginID           lh,
                                        const char*          dealIdentifier,
                                        SW_XML               inputXML,
                                        SW_DealUpdateResult* dealUpdateResult_out);
/**
 * @ingroup api
 * @brief Check eligibility to submit the deal to a downstream system.
 * @details This function allows a suitably permissioned application to check whether
 * the specified deal is currently eligible for processing by a downstream
 * system, for example clearing the deal at a clearing house, or publishing
 * credit deals. Note that the result of the most recent eligibility check is also
 * available by looking at the private data in the deals SWML.
 *
 * When called on a deal, the eligibility checks are re-run, and if the deal has
 * become eligible (for example, because the eligibility rules have changed), then
 * the deal will be re-sent to the downstream system. When this occurs, a new
 * version of the deal will be written containing the recalculated private data.
 * Notifications are be sent to all parties upon submittal to the downstream system
 * and their acceptance/rejection of the deal.
 *
 * @note For each eligible destination, the rules checked by MarkitWire may
 *       be a subset of the full rules checked by the downstream system.
 *       It is possible for this call to return empty @a resultXML_out, indicating
 *       that the deal is eligibile, but for the deal to be subsequently
 *       rejected by the downstream system.
 *
 * @param lh Login handle
 * @param dealVersionHandle DVH of the deal to check. See @ref SW_DealVersionHandle.
 * @param eligibilityType eligibility type for given deal to check. See @ref eligibility_types.
 * @param[out] resultXML_out Either <a href="./xmlref.html#ClearingResult">Clearing Result XML</a>
 *  or <a href="./xmlref.html#PublishingResult">Publishing Result XML</a> containing the results
 *  of the eligibility check. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealCheckEligibility(SW_LoginID           lh,
                                                  SW_DealVersionHandle dealVersionHandle,
                                                  const char*          eligibilityType,
                                                  SW_XML*              resultXML_out);
/**
 * @ingroup api
 * @brief Get a list of unacknowledged batches.
 * @details In cases where an internal process has handled a number of customer
 * deals in a number of 'batches', these batches can be requested and
 * acknowledged.
 * This method retrieves the summary of the caller's current unacknowledged
 * batches for a given internal process.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param batchName The internal process name, or blank for all processes.
 * @param[out] resultXML_out Destination for the result XML summarising unacknowledged batches. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_BatchGetOutstanding(SW_LoginID  lh,
                                                 const char* batchName,
                                                 SW_XML*     resultXML_out);
/**
 * @ingroup api
 * @brief Get the details of a specific batch.
 * @details In cases where an internal process has handled a number of customer
 * deals in a number of 'batches', these batches can be requested and
 * acknowledged. This function retrieves the details of a specific batch such
 * as the deals involved and the action carried out.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param batchId integer batch id. If an unknown batch id is passed, the
 *    returned XML will be empty rather than the funtion returning an error.
 * @param[out] resultXML_out Destination for the result XML detailing the batch. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_BatchGetDetails(SW_LoginID lh,
                                             int        batchId,
                                             SW_XML*    resultXML_out);
/**
 * @ingroup api
 * @brief Acknowledge a specific batch.
 * @details In cases where an internal process has handled a number of customer
 * deals in a number of 'batches', these batches can be requested and
 * acknowledged.
 * This method acknowledges a specific batch.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param batchId integer batch id
 * @return @ref ErrorCodes, @ref SWERR_InvalidBatchID
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_BatchAck(SW_LoginID lh,
                                      int        batchId);
/**
 * @ingroup api
 * @brief Update a specific batch.
 * @details In cases where an internal process has handled a number of customer
 * deals in a number of 'batches', these batches can be updated.
 * This method updates a specific batch.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param batchStatusXML See MarkitWire XML format description for
 * further details regarding the format and content of this parameter.
 * @param[out] resultXML_out Destination for the result XML. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_BatchUpdate(SW_LoginID lh,
                                         SW_XML     batchStatusXML,
                                         SW_XML*    resultXML_out);

/**
 * @ingroup api
 * @brief Get Deal SWML.
 * @details Fetches the SWML representation of the callers view of the deal.
 *
 * @note This function is valid for all deals except novation confirmations.
 * The function SW_DealGetSWML() should be used to obtain the SWML for
 * novation confirmation deals since only SW_DealGetSWML() will return the
 * SWML for the novation confirmation.
 * @details Fetches the SWML representation of the callers view of the deal.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param swmlVersion The version of SWML to return. See @ref swmlversions.
 * @param dealID The MarkitWire deal identifier. see @ref SW_DealID.
 * @param majorVersion The contract version of the deal. See @ref dealversionconstants.
 * @param side The side of the deal. See @ref sideconstants.
 * @param[out] resultXML_out Destination for the returned SWML. See @ref resource.
 * @return @ref ErrorCodes
 * @note See @ref SWERR_UnsupportedXmlVersion
 * @see SW_DealGetSWML().
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealSinkGetSWML(SW_LoginID          lh,
                                             const char*         swmlVersion,
                                             SW_DealID           dealID,
                                             SW_DealMajorVersion majorVersion,
                                             SW_DealSide         side,
                                             SW_XML*             resultXML_out);
/**
 * @ingroup api
 * @brief Get Deal SWML.
 * @details Fetches the SWML representation of the callers view of the deal.
 *
 * @note This function is valid for all deals except novation confirmations.
 * The function SW_DealGetSWML() should be used to obtain the SWML for
 * novation confirmation deals since only SW_DealGetSWML() will return the
 * SWML for the novation confirmation.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param swmlVersion The version of SWML to return. See @ref swmlversions.
 * @param dealVersionHandle DVH of the deal to get SWML for. See @ref SW_DealVersionHandle.
 * @param[out] resultXML_out Destination for the returned SWML. See @ref resource.
 * @return @ref ErrorCodes
 * @note See @ref SWERR_UnsupportedXmlVersion
 * @see SW_DealGetSWML().
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealSinkDVHGetSWML(SW_LoginID           lh,
                                                const char*          swmlVersion,
                                                SW_DealVersionHandle dealVersionHandle,
                                                SW_XML*              resultXML_out);
/**
 * @ingroup api
 * @brief Search for deals with given characteristics.
 * @details This function returns the details of deals matching a given set
 * of search criteria. The @a queryXML criteria can be given as
 * either <a href="./xmlref.html#SinkQuery">Sink Query XML</a>
 * or <a href="./xmlref.html#DealInfoQuery">Deal Info Query XML</a>. In each case
 * the data will be returned in a different format, see @a queryResultXML_out.
 *
 * If no matching deals are found, @a queryResultXML_out will contain
 * an empty root element and return @c SWERR_Success. If an error occurs,
 * it will be set to @c NULL and an error code returned.
 *
 * If @a cb is @c NULL then the call will block until the query completes,
 * otherwise callback usage depends on the format of the input query XML:
 *
 * - For Sink Query XML, the call will return immediately and the query will execute
 * asynchronously. @a cb will be called with the results as they become available.
 * If a @c ResultBatchSize element is given in @a queryXML, @a cb will be called
 * repeatedly until all results are returned, with each invocation being passed
 * up to @c ResultBatchSize results. the @c ResultBatch element in the result XML
 * will contain 'Complete' when the last batch of results is delivered.
 * - For Deal Info Query XML, the call will block until the query
 * completes, and then @a cb will be called by this function before it returns.
 * However, if the current callback mode (see @ref SW_SetCallbackMode()) is synchronous,
 * then the callback will be made when SW_Poll() is next called after the query completes.
 *
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param queryXML Search constraints for the query,
 *     in either <a href="./xmlref.html#SinkQuery">Sink Query XML</a>
 *     or <a href="./xmlref.html#DealInfoQuery">Deal Info Query XML</a> format.
 * @param[out] queryResultXML_out Destination for the returned result XML,
 *     in either <a href="./xmlref.html#QueryResult">Query Result XML</a>
 *     or <a href="./xmlref.html#DealState">Deal State XML</a> format. See @ref resource.
 * @param tag User supplied value to pass to the @a cb callback.
 * @param cb The users callback handler, or @c NULL if the results should be returned directly.
 * @return @ref ErrorCodes
 *
 * @note When using <a href="./xmlref.html#SinkQuery">Sink Query XML</a> as the search
 *     criteria, please note the search criteria constraints listed in the XML documentation.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_QueryDeals(SW_LoginID      lh,
                                        SW_XML          queryXML,
                                        SW_XML*         queryResultXML_out,
                                        void*           tag,
                                        PDSQUERYHANDLER cb);
/**
 * @ingroup api
 * @brief Get the list of CSV columns available in an CSV extract.
 * @deprecated This function will be removed in a future release.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_ExtractGetColumns(SW_LoginID   lh,
                                               const char** columnNames_out);

/**
 * @ingroup api
 * @brief Get information about the reporting status of a set of deals.
 * @details Returns information about the status of deals that are eligible
 * for reporting to a downstream repository. Currently this is limited
 * to rates deals eligible for reporting to the DTCC GTR ODRF Rates Repository.
 * The resulting CSV data is returned according to the specification
 * in <a href="http://tools.ietf.org/html/rfc4180">RFC 4180</a>.  In order to
 * keep system performing in the optimum level, the maximum number of deals is
 * limited to 1000. Otherwise, user will receive over 1000 deals request error.
 * @note The data returned by this function may change asynchronously to any
 *       activity on the deal within MarkitWire, since actions such as
 *       accepting and acknowledging deals by downstream systems occur
 *       independently of the movement of the deal through MarkitWire workflows.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param queryXML <a href="./xmlref.html#ReportingStatusQuery">Reporting Status Query XML</a> containing
 *        the deals to return the reporting status of.
 * @param reserved Reserved for future use. You must pass 0 for this parameter.
 * When the capability @ref SW_CAP_REPORTING_STATUS_XMLFORMAT is set then @param[out] csvResults_out Destination
 * contains the resulting XML data else @param[out] csvResults_out Destination contains the resulting CSV data.
 * See <a href="./xmlref.html#ReportingStatusXML">Reporting Status XML</a> and
 * and <a href="./xmlref.html#ReportingStatusCSV">Reporting Status CSV</a> for the appropriate
 * data format. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealGetReportingStatus(SW_LoginID   lh,
                                                    SW_XML       queryXML,
                                                    long long    reserved,
                                                    const char** csvResults_out);

/**
 * @ingroup api
 * @brief Set information about the reporting status of a set of deals.
 * @note The data altered by this function may change asynchronously to any
 *       activity on the deal within MarkitWire, since actions such as
 *       accepting and acknowledging deals by downstream systems occur
 *       independently of the movement of the deal through MarkitWire workflows.
 *       This api function is only available to permissioned users for interacting
 *       with downstream reporting systems.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param reportingStatusUpdateXML <a href="./xmlref.html#ReportingStatusUpdate">Reporting Status Update XML</a> containing
 *        the deals to update the reporting status of.
 * @param reserved Reserved for future use. You must pass 0 for this parameter.
 * @param[out] resultXML_out Destination for the resulting <a href="./xmlref.html#DealResultsXML">Deal Results XML</a> XML. See @ref resource.
 * @return @ref ErrorCodes
 * @note A return code of @ref SWERR_Success does not indicate that all deals were
 * decleared. You must iterate the @c returnCode elements of @a resultXML_out
 * to determine the status of the operation on each deal. Each @c returnCode
 * element is the numeric value of the result setting the reporting status of the deal. This
 * may be one of the following values:
 * - @ref SWERR_Success - The record was successfully written.
 * - @ref SWERR_UnknownDeal - Unable to locate the deal specified.
 * - @ref SWERR_UnknownParticipant - Invalid participant on deal.
 * - @ref SWERR_InvalidLegalEntity - One of the BICs specified is invalid.
 * - @ref SWERR_InvalidDeal - Something was wrong with the deal, or an error occured writing to the DB.
 * - @ref SWERR_InternalError
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealSetReportingStatus(SW_LoginID lh,
                                                    SW_XML     reportingStatusUpdateXML,
                                                    long long  reserved,
                                                    SW_XML*    resultXML_out);

/** @defgroup clearing Clearing Actions */

/**
 * @ingroup clearing
 * @brief Unlock a set of cleared deals.
 * @details This function allows the clearance system to 'unlock' a number of
 * cleared deals so that they can be bilaterally amended or cancelled by
 * the original bilateral parties. It is intended to be used when the
 * original bilateral parties request the clearance system to 'delete'
 * a deal from the clearing service, i.e. to de-register it.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param dealListXML <a href="./xmlref.html#DealList">Deal List XML</a> giving
 *    the list of deal version handles to declear.
 * @param[out] resultXML_out Destination for the resulting <a href="./xmlref.html#DealResultsXML">Deal Results XML</a> XML. See @ref resource.
 * @return @ref ErrorCodes
 * @note A return code of @ref SWERR_Success does not indicate that all deals were
 * decleared. You must iterate the @c returnCode elements of @a resultXML_out
 * to determine the status of the operation on each deal. Each @c returnCode
 * element is the numeric value of the result of declearing the deal. This
 * may be one of the following values:
 * - @ref SWERR_Success
 * - @ref SWERR_AlreadyDeCleared
 * - @ref SWERR_UnknownDeal
 * - @ref SWERR_DealNotEligibleToClear
 * - @ref SWERR_InternalError
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealAllowDeClearingEx(SW_LoginID lh,
                                                   SW_XML     dealListXML,
                                                   SW_XML*    resultXML_out);

/** @defgroup util Utility Functions */

/**
 * @ingroup util
 * @brief Return the API version.
 * @details The version is returned as a 32-bit integer.
 * The 16 most significant bits contain the major and minor version numbers,
 * and the 16 least significant bits contain the build number modulo 65536.
 * The major and minor version numbers are returned in the 8 most and least
 * significant bits respectively.
 * So, for example, when running against API version 5.1, this call returns
 * @a 0x0501nnnn where @a nnnn is the API build number.
 * @deprecated Deprecated in favour of @ref SW_GetLibraryVersionEx, since
 * build numbers may cycle through 16 bits and therefore appear to go backwards
 * when extracted using this function.
 * @return The API version number.
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetLibraryVersion();

/**
 * @ingroup util
 * @brief Return a string representing the of the API version number.
 * @details This function returns the API version as a string of the form @c SW_X_Y_ZZZZ,
 * where @c X is the major version, @c Y is the minor version and @c ZZZZ is the
 * change number.
 * @param[out] result_out Destination for the version string. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetLibraryVersionEx(const char** result_out);

/**
 * @ingroup util
 * @brief Determine if the supplied XML is valid.
 * @details This function validates one of the following XML representations:
 * - SWDML
 * - SWBML
 * - <a href="./xmlref.html#AddressList">Address List XML</a>.
 * - <a href="./xmlref.html#AddressListQuery">Address List Query XML</a>.
 * - <a href="./xmlref.html#Cancellation">Cancellation XML</a>.
 * - <a href="./xmlref.html#CancellationFee">Cancellation Fee XML</a>.
 * - <a href="./xmlref.html#DealList">Deal List XML</a>.
 * - <a href="./xmlref.html#Exercise">Exercise XML</a>.
 * - <a href="./xmlref.html#Exit">Exit XML</a>.
 * - <a href="./xmlref.html#PrivateData">Private Data XML</a>.
 * - <a href="./xmlref.html#Recipient">Recipient XML</a>.
 * - <a href="./xmlref.html#SinkUpdate">Update XML</a>.
 * - Position Change XML.
 * - <a href="./xmlref.html#NettingInstructionXML">Netting Instruction XML</a>.
 *
 * @note The validation performed by this function is a subset of the
 * full validation performed when @a inputXML is passed to other calls.
 * The third parameter errorString_out is not used in Thin API infrastructure. For error description, please use:
 * SW_ErrCode SW_GetLastErrorSpecificsEx(const char ** result_out) as a workaround.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param inputXML The XML to check.
 * @param[out] errorString_out (Deprecated, not used in ThinAPI) Destination for warnings or errors. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_ValidateXML(SW_LoginID   lh,
                                         SW_XML       inputXML,
                                         const char** errorString_out);

/**
 * @ingroup util
 * @brief Transform XML using a stylesheet.
 * @details This function allows transformation of XML to another textual
 * format using a stylesheet provided by the caller.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param xsltPath The filesystem path to the users xslt file.
 * @param xsltKey A string containing a unique key for xsltPath.
 * @param inputXML The input XML to be transformed.
 * @param[out] output_out Destination for the transformed result. See @ref resource.
 * @note The implementation caches compiled stylesheets according to the
 * @a xsltKey provided by the user. If different xslt files are given with
 * the same key value, the behaviour of this function is undefined.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_TransformXML(SW_LoginID   lh,
                                          const char*  xsltPath,
                                          const char*  xsltKey,
                                          SW_XML       inputXML,
                                          const char** output_out);

/**
 * @ingroup util
 * @brief Internal function for MarkitWire use only.
 * @internal
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_SendTelemetry(SW_LoginID lh,
                                           SW_XML     commandXML,
                                           SW_XML*    resultXML_out);

/**
 * @ingroup api
 * @brief Take a deal and transfer it to the current user affirming at the same time.
 * @details This is intended for use in matching. It allows a trade to
 * be transferred from an AI user to a PI and affirmed at the same
 * time. ie it takes the trade out of the matching process and makes
 * it into a direct deal. The actioning user must have super transfer
 * user permision. Also the trade must be in a state where it can be
 * affirmed - ie unilateral fields such as Book, LE etc must be
 * defaultable. This was primarily implemented for novation
 * consent. It replicates the actions of the tc_client unmatched deals
 * folder affirm button.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealTransferAffirm(SW_LoginID            lh,
                                                SW_DealVersionHandle  oldDealVersionHandle,
                                                SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup api
 * @brief Return the differences between two deals
 * @brief This function returns an XML specifying the differences between two deals.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param dealVersionHandle DVH of the first deal
 * @param dealVersionHandle2 DVH of the second deal
 * @param[out] resultXML_out Destination for the <a href="./xmlref.html">result XML</a> summarising differences between two deals. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealCompare(SW_LoginID           lh,
                                         SW_DealVersionHandle dealVersionHandle,
                                         SW_DealVersionHandle dealVersionHandle2,
                                         SW_XML*              resultXML_out);
/**
 * @ingroup matching
 * @brief Return the differences between the deal and its closest matching deal to @a dealVersionHandle
 * @brief Return the differences between the passed deal and its closest matching deal
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param dealVersionHandle DVH of the deal to compare. See @ref SW_DealVersionHandle
 * @param[out] resultXML_out Destination for the <a href="./xmlref.html">result XML</a> summarising differences between the deal and its closest matching deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealCompareClosestMatch(SW_LoginID           lh,
                                                     SW_DealVersionHandle dealVersionHandle,
                                                     SW_XML*              resultXML_out);
/**
 * @ingroup matching
 * @brief Returns the close matches to a deal.
 * @details This function returns an XML specifying the close matches to a deal,
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param[out] resultXML_out Destination for the <a href="./xmlref.html#MatchInfoXML">Match Info XML</a> summarising the close matches. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealGetMatchInfo(SW_LoginID           lh,
                                              SW_DealVersionHandle oldDealVersionHandle,
                                              SW_XML*              resultXML_out);
/**
 * @ingroup matching
 * @brief Returns the close matches to a deal.
 * @details This function returns all close matches to the user's pending deals in XML format.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param[out] resultXML_out Destination for the <a href="./xmlref.html#MatchInfoXML">Match Info XML</a> summarising the close matches. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GetMatchInfo(SW_LoginID lh,
                                          SW_XML*    resultXML_out);

/**
 * @ingroup matching
 * @brief Sends a suggestion for a pair of deals which could match.
 * @details During Equity Swap Matching allows a Matcher/Affirmer to suggest a trade pair which could match with a revision.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal the counterparty is requested to revise their deal to match, see @ref SW_DealVersionHandle.
 * @param cptyDealVersionHandle The counterparty's deal which is being requested to be revised, see @ref SW_DealVersionHandle.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealSuggestMatch(SW_LoginID            lh,
                                              SW_DealVersionHandle  oldDealVersionHandle,
                                              SW_DealVersionHandle  cptyDealVersionHandle,
                                              SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup matching
 * @brief Withdraws a suggestion for a match for a trade pair.
 * @details During Equity Swap Matching allows a Matcher/Affirmer to withdraw their suggestion of a match for a trade pair.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal the counterparty was requested to revise their deal to match, see @ref SW_DealVersionHandle.
 * @param cptyDealVersionHandle The counterparty's deal which was being requested to be revised, see @ref SW_DealVersionHandle.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_DealWithdrawSuggestMatch(SW_LoginID            lh,
                                                      SW_DealVersionHandle  oldDealVersionHandle,
                                                      SW_DealVersionHandle  cptyDealVersionHandle,
                                                      SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup matching
 * @brief Rejects/Excludes a counterparty's trade from matching.
 * @details Where the counterparty is a matcher the trade is put into hibernation and is not eligible for matching.
 *     Where the counterparty is an affirmer, the trade is rejected.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param cptyDealVersionHandle The counterparty's deal which is being rejected/excluded, see @ref SW_DealVersionHandle.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_MatchPush(SW_LoginID            lh,
                                       SW_DealVersionHandle  cptyDealVersionHandle,
                                       SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup matching
 * @brief Puts a trade into hibernation.
 * @details Once the trade is in hibernation although the counterparty can still see it,
 *     they are unable to affirm or match against it.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal which is being put into hibernation, see @ref SW_DealVersionHandle.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_MatchPull(SW_LoginID            lh,
                                       SW_DealVersionHandle  oldDealVersionHandle,
                                       SW_DealVersionHandle* newDealVersionHandle_out);

/**
 * @ingroup api
 * @brief Send a free-text gate check dispute message.
 * @details Sends a free-text dispute message to the recipient or if recipient is null to the broker on a gate check deal.
 * @param lh The logged in user, see @ref SW_LoginID.
 * @param oldDealVersionHandle The deal to act on, see @ref SW_DealVersionHandle.
 * @param recipientXML <a href="./xmlref.html#Recipient">Recipient XML</a> containing the intended recipient(s). All addressees must be existing parties on the deal.
 * @param messageText Description of the reason for the dispute.
 * @param[out] newDealVersionHandle_out Destination for the @ref SW_DealVersionHandle of the resulting deal. See @ref resource.
 * @return @ref ErrorCodes
 */
SW_CLIENT_API
SW_ErrCode STDAPICALLTYPE SW_GateCheckDispute(SW_LoginID            lh,
                                              SW_DealVersionHandle  oldDealVersionHandle,
                                              SW_XML                recipientXML,
                                              const char*           messageText,
                                              SW_DealVersionHandle* newDealVersionHandle_out);

#ifdef __cplusplus
}
#endif

#endif /* SW_API_H */
