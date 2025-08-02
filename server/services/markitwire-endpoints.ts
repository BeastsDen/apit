import { MarkitWireApiEndpoint } from "@shared/schema";

/**
 * MarkitWire API endpoints based on the DealSink Cookbook PDF
 */
export const markitWireApiEndpoints: Omit<MarkitWireApiEndpoint, 'id'>[] = [
  // Session Management
  {
    name: "SW_Connect",
    category: "Session Management",
    functionName: "SW_Connect",
    description: "Connect to MarkitWire server",
    parameters: [
      { name: "server", type: "string", description: "Server hostname:port", required: true, example: "training.swapswire.com:9009" },
      { name: "timeout", type: "number", description: "Connection timeout in seconds", required: true, example: 120 }
    ],
    sampleCode: `long sessionHandle = -1;
int rc = SW_Connect("training.swapswire.com:9009", 120, null, &sessionHandle);
if (rc < SWERR_Success) {
    System.out.println("Failed connection: " + getError(rc));
}`,
    isActive: true
  },
  {
    name: "SW_Login",
    category: "Session Management", 
    functionName: "SW_Login",
    description: "Login to MarkitWire with credentials",
    parameters: [
      { name: "sessionHandle", type: "number", description: "Session handle from SW_Connect", required: true },
      { name: "username", type: "string", description: "MarkitWire username", required: true },
      { name: "password", type: "string", description: "MarkitWire password", required: true }
    ],
    sampleCode: `long loginHandle = -1;
int rc = SW_Login(sessionHandle, "MyUserName", "MyPassword", &loginHandle);
if (rc < SWERR_Success) {
    System.out.println("Failed to login: " + getError(rc));
} else {
    System.out.println("Successful login: " + getError(rc));
}`,
    isActive: true
  },
  {
    name: "SW_Logout",
    category: "Session Management",
    functionName: "SW_Logout", 
    description: "Logout from MarkitWire",
    parameters: [
      { name: "loginHandle", type: "number", description: "Login handle from SW_Login", required: true }
    ],
    sampleCode: `SW_Logout(loginHandle);`,
    isActive: true
  },
  {
    name: "SW_Disconnect", 
    category: "Session Management",
    functionName: "SW_Disconnect",
    description: "Disconnect from MarkitWire server",
    parameters: [
      { name: "sessionHandle", type: "number", description: "Session handle from SW_Connect", required: true }
    ],
    sampleCode: `SW_Disconnect(sessionHandle);`,
    isActive: true
  },

  // Deal Management
  {
    name: "SW_SendDeal",
    category: "Deal Management",
    functionName: "SW_SendDeal",
    description: "Send a new deal to counterparty",
    parameters: [
      { name: "loginHandle", type: "number", description: "Login handle", required: true },
      { name: "dealXML", type: "string", description: "Deal data in SWML format", required: true },
      { name: "addressee", type: "string", description: "Counterparty address", required: true }
    ],
    sampleCode: `String dealXML = "<?xml version=\\"1.0\\"?>\\n<trade>...</trade>";
long dealHandle = -1;
int rc = SW_SendDeal(loginHandle, dealXML, "COUNTERPARTY", &dealHandle);
if (rc < SWERR_Success) {
    System.out.println("Failed to send deal: " + getError(rc));
}`,
    isActive: true
  },
  {
    name: "SW_AffirmDeal",
    category: "Deal Management",
    functionName: "SW_AffirmDeal",
    description: "Affirm a received deal",
    parameters: [
      { name: "loginHandle", type: "number", description: "Login handle", required: true },
      { name: "dealVersionHandle", type: "number", description: "Deal version handle", required: true }
    ],
    sampleCode: `int rc = SW_AffirmDeal(loginHandle, dealVersionHandle);
if (rc < SWERR_Success) {
    System.out.println("Failed to affirm deal: " + getError(rc));
}`,
    isActive: true
  },
  {
    name: "SW_RejectDeal",
    category: "Deal Management", 
    functionName: "SW_RejectDeal",
    description: "Reject a received deal",
    parameters: [
      { name: "loginHandle", type: "number", description: "Login handle", required: true },
      { name: "dealVersionHandle", type: "number", description: "Deal version handle", required: true },
      { name: "reason", type: "string", description: "Rejection reason", required: false }
    ],
    sampleCode: `int rc = SW_RejectDeal(loginHandle, dealVersionHandle, "Pricing disagreement");
if (rc < SWERR_Success) {
    System.out.println("Failed to reject deal: " + getError(rc));
}`,
    isActive: true
  },
  {
    name: "SW_WithdrawDeal",
    category: "Deal Management",
    functionName: "SW_WithdrawDeal", 
    description: "Withdraw a previously sent deal",
    parameters: [
      { name: "loginHandle", type: "number", description: "Login handle", required: true },
      { name: "dealVersionHandle", type: "number", description: "Deal version handle", required: true }
    ],
    sampleCode: `int rc = SW_WithdrawDeal(loginHandle, dealVersionHandle);
if (rc < SWERR_Success) {
    System.out.println("Failed to withdraw deal: " + getError(rc));
}`,
    isActive: true
  },

  // Deal Information
  {
    name: "SW_GetDealList",
    category: "Deal Information",
    functionName: "SW_GetDealList",
    description: "Get list of deals for the logged in user",
    parameters: [
      { name: "loginHandle", type: "number", description: "Login handle", required: true },
      { name: "criteria", type: "string", description: "Search criteria (optional)", required: false }
    ],
    sampleCode: `String dealList = null;
int rc = SW_GetDealList(loginHandle, "", &dealList);
if (rc < SWERR_Success) {
    System.out.println("Failed to get deal list: " + getError(rc));
} else {
    System.out.println("Deal list: " + dealList);
}`,
    isActive: true
  },
  {
    name: "SW_GetDealInfo",
    category: "Deal Information", 
    functionName: "SW_GetDealInfo",
    description: "Get detailed information about a specific deal",
    parameters: [
      { name: "loginHandle", type: "number", description: "Login handle", required: true },
      { name: "dealHandle", type: "number", description: "Deal handle", required: true }
    ],
    sampleCode: `String dealInfo = null;
int rc = SW_GetDealInfo(loginHandle, dealHandle, &dealInfo);
if (rc < SWERR_Success) {
    System.out.println("Failed to get deal info: " + getError(rc));
} else {
    System.out.println("Deal info: " + dealInfo);
}`,
    isActive: true
  },

  // Notifications
  {
    name: "SW_RegisterDealNotifyExCallback",
    category: "Notifications",
    functionName: "SW_RegisterDealNotifyExCallback",
    description: "Register callback for deal notifications",
    parameters: [
      { name: "loginHandle", type: "number", description: "Login handle", required: true },
      { name: "context", type: "string", description: "User context data", required: false }
    ],
    sampleCode: `// Define callback function
public static void dealNotifyCallback(long handle, String notification, Object context) {
    System.out.println("Deal notification: " + notification);
}

// Register callback
long retval = SW_RegisterDealNotifyExCallback(loginHandle, "context", dealNotifyCallback);
if (retval < SWERR_Success) {
    System.out.println("Failed to register notify callback: " + getError(retval));
}`,
    isActive: true
  },
  {
    name: "SW_Poll",
    category: "Notifications",
    functionName: "SW_Poll", 
    description: "Poll for notifications and events",
    parameters: [
      { name: "loginHandle", type: "number", description: "Login handle", required: true },
      { name: "timeout", type: "number", description: "Poll timeout in milliseconds", required: true, example: 1000 }
    ],
    sampleCode: `int rc = SW_Poll(loginHandle, 1000);
if (rc < SWERR_Success) {
    System.out.println("Poll failed: " + getError(rc));
}`,
    isActive: true
  },

  // DealSink Specific 
  {
    name: "SW_GetBookList",
    category: "DealSink",
    functionName: "SW_GetBookList",
    description: "Get list of available books (DealSink)",
    parameters: [
      { name: "loginHandle", type: "number", description: "Login handle", required: true }
    ],
    sampleCode: `String bookList = null;
int rc = SW_GetBookList(loginHandle, &bookList);
if (rc < SWERR_Success) {
    System.out.println("Failed to get book list: " + getError(rc));
} else {
    System.out.println("Book list: " + bookList);
}`,
    isActive: true
  },
  {
    name: "SW_GetUserList", 
    category: "DealSink",
    functionName: "SW_GetUserList",
    description: "Get list of users in organization (DealSink)",
    parameters: [
      { name: "loginHandle", type: "number", description: "Login handle", required: true }
    ],
    sampleCode: `String userList = null;
int rc = SW_GetUserList(loginHandle, &userList);
if (rc < SWERR_Success) {
    System.out.println("Failed to get user list: " + getError(rc));
} else {
    System.out.println("User list: " + userList);
}`,
    isActive: true
  }
];