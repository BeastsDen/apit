/**
 * MarkitWire API Simulator
 * 
 * Since we're on Linux but only have Windows DLL files, this simulator provides
 * realistic responses for MarkitWire API calls based on the PDF documentation.
 * This allows testing the interface and understanding API behavior without
 * requiring the native Windows libraries.
 */

interface MarkitWireApiCall {
  functionName: string;
  host: string;
  username: string;
  password: string;
  parameters: any[];
}

interface MarkitWireApiResponse {
  success: boolean;
  data?: any;
  error?: string;
  executionTime: number;
  javaOutput?: string;
  simulationNote?: string;
}

class MarkitWireSimulator {
  /**
   * Simulate a MarkitWire API call with realistic responses
   */
  async simulateApiCall(call: MarkitWireApiCall): Promise<MarkitWireApiResponse> {
    const startTime = Date.now();
    
    // Simulate network delay
    await new Promise(resolve => setTimeout(resolve, 100 + Math.random() * 200));
    
    try {
      // Validate basic parameters
      if (!call.host || !call.username || !call.password) {
        return {
          success: false,
          error: "Missing required connection parameters",
          executionTime: Date.now() - startTime,
          simulationNote: "Simulated validation error"
        };
      }

      // Simulate connection test for basic auth
      if (call.username === "demo" && call.password === "demo") {
        // Allow demo credentials to pass
      } else if (call.username.length < 3 || call.password.length < 3) {
        return {
          success: false,
          error: "Authentication failed - invalid credentials",
          executionTime: Date.now() - startTime,
          javaOutput: "SW_Login failed: SWERR_Login_Failed (-1002)",
          simulationNote: "Simulated authentication failure"
        };
      }

      const response = this.generateResponseForFunction(call);
      return {
        ...response,
        executionTime: Date.now() - startTime,
        simulationNote: "Simulated response - using Windows DLLs on Linux not supported"
      };

    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        executionTime: Date.now() - startTime,
        simulationNote: "Simulated error response"
      };
    }
  }

  private generateResponseForFunction(call: MarkitWireApiCall): Omit<MarkitWireApiResponse, 'executionTime' | 'simulationNote'> {
    const { functionName, parameters } = call;

    switch (functionName) {
      case 'SW_Connect':
        return {
          success: true,
          data: {
            sessionHandle: 12345,
            status: "Connected"
          },
          javaOutput: `SW_Connect(${parameters[0]}, ${parameters[1]}) = SWERR_Success (0)\nSession Handle: 12345`
        };

      case 'SW_Login':
        return {
          success: true,
          data: {
            loginHandle: 67890,
            status: "Logged in",
            userInfo: {
              username: call.username,
              organization: "Demo Organization",
              permissions: ["DEALER", "VIEW_DEALS"]
            }
          },
          javaOutput: `SW_Login(${call.username}) = SWERR_Success (0)\nLogin Handle: 67890\nUser authenticated successfully`
        };

      case 'SW_GetDealList':
        return {
          success: true,
          data: {
            deals: [
              {
                dealId: "DEAL001",
                counterparty: "GOLDMAN_SACHS",
                instrument: "USD_IRS_5Y",
                notional: 10000000,
                status: "PENDING_AFFIRMATION",
                tradeDate: "2025-08-02"
              },
              {
                dealId: "DEAL002", 
                counterparty: "JP_MORGAN",
                instrument: "EUR_IRS_10Y",
                notional: 5000000,
                status: "AFFIRMED",
                tradeDate: "2025-08-01"
              }
            ],
            totalCount: 2
          },
          javaOutput: `SW_GetDealList() = SWERR_Success (0)\nFound 2 deals:\nDEAL001 - GOLDMAN_SACHS - USD_IRS_5Y - PENDING\nDEAL002 - JP_MORGAN - EUR_IRS_10Y - AFFIRMED`
        };

      case 'SW_SendDeal':
        const dealId = `DEAL${Date.now().toString().slice(-6)}`;
        return {
          success: true,
          data: {
            dealId,
            status: "SENT",
            dealHandle: Math.floor(Math.random() * 100000),
            counterparty: parameters[2] || "UNKNOWN_COUNTERPARTY"
          },
          javaOutput: `SW_SendDeal() = SWERR_Success (0)\nDeal sent successfully\nDeal ID: ${dealId}\nCounterparty: ${parameters[2] || 'UNKNOWN'}`
        };

      case 'SW_AffirmDeal':
        return {
          success: true,
          data: {
            dealVersionHandle: parameters[1],
            status: "AFFIRMED",
            confirmationId: `CONF${Date.now().toString().slice(-6)}`
          },
          javaOutput: `SW_AffirmDeal(${parameters[1]}) = SWERR_Success (0)\nDeal affirmed successfully\nConfirmation ID: CONF${Date.now().toString().slice(-6)}`
        };

      case 'SW_RejectDeal':
        return {
          success: true,
          data: {
            dealVersionHandle: parameters[1],
            status: "REJECTED",
            reason: parameters[2] || "No reason provided"
          },
          javaOutput: `SW_RejectDeal(${parameters[1]}) = SWERR_Success (0)\nDeal rejected: ${parameters[2] || 'No reason'}`
        };

      case 'SW_WithdrawDeal':
        return {
          success: true,
          data: {
            dealVersionHandle: parameters[1],
            status: "WITHDRAWN"
          },
          javaOutput: `SW_WithdrawDeal(${parameters[1]}) = SWERR_Success (0)\nDeal withdrawn successfully`
        };

      case 'SW_GetDealInfo':
        return {
          success: true,
          data: {
            dealHandle: parameters[1],
            dealInfo: {
              dealId: "DEAL001",
              tradeDate: "2025-08-02",
              instrument: "USD_IRS_5Y",
              notional: 10000000,
              fixedRate: 4.125,
              counterparty: "GOLDMAN_SACHS",
              status: "PENDING_AFFIRMATION",
              legs: [
                {
                  legType: "FIXED",
                  rate: 4.125,
                  paymentFrequency: "SEMI_ANNUAL"
                },
                {
                  legType: "FLOATING", 
                  index: "USD-LIBOR-3M",
                  paymentFrequency: "QUARTERLY"
                }
              ]
            }
          },
          javaOutput: `SW_GetDealInfo(${parameters[1]}) = SWERR_Success (0)\nDeal ID: DEAL001\nInstrument: USD_IRS_5Y\nNotional: $10,000,000\nFixed Rate: 4.125%`
        };

      case 'SW_Poll':
        return {
          success: true,
          data: {
            notifications: [
              {
                type: "DEAL_RECEIVED",
                dealId: "DEAL003",
                counterparty: "MORGAN_STANLEY",
                timestamp: new Date().toISOString()
              }
            ],
            eventCount: 1
          },
          javaOutput: `SW_Poll(${parameters[1]}) = SWERR_Success (0)\n1 notification received:\nDEAL_RECEIVED - DEAL003 from MORGAN_STANLEY`
        };

      case 'SW_GetBookList':
        return {
          success: true,
          data: {
            books: [
              { bookId: "RATES_TRADING", name: "Rates Trading Book", active: true },
              { bookId: "CREDIT_TRADING", name: "Credit Trading Book", active: true },
              { bookId: "FX_TRADING", name: "FX Trading Book", active: false }
            ]
          },
          javaOutput: `SW_GetBookList() = SWERR_Success (0)\nFound 3 books:\nRATES_TRADING - Active\nCREDIT_TRADING - Active\nFX_TRADING - Inactive`
        };

      case 'SW_GetUserList':
        return {
          success: true,
          data: {
            users: [
              { userId: "trader1", name: "John Smith", role: "TRADER", active: true },
              { userId: "trader2", name: "Jane Doe", role: "TRADER", active: true },
              { userId: "admin1", name: "Admin User", role: "ADMIN", active: true }
            ]
          },
          javaOutput: `SW_GetUserList() = SWERR_Success (0)\nFound 3 users:\ntrader1 - John Smith (TRADER)\ntrader2 - Jane Doe (TRADER)\nadmin1 - Admin User (ADMIN)`
        };

      case 'SW_Logout':
        return {
          success: true,
          data: { status: "LOGGED_OUT" },
          javaOutput: `SW_Logout(${parameters[0]}) = SWERR_Success (0)\nSuccessfully logged out`
        };

      case 'SW_Disconnect':
        return {
          success: true,
          data: { status: "DISCONNECTED" },
          javaOutput: `SW_Disconnect(${parameters[0]}) = SWERR_Success (0)\nSuccessfully disconnected`
        };

      default:
        return {
          success: false,
          error: `Unknown function: ${functionName}`,
          javaOutput: `${functionName}() = SWERR_Invalid_Function (-1001)\nFunction not recognized`
        };
    }
  }

  /**
   * Generate Java code for the given API call
   */
  generateJavaCode(call: MarkitWireApiCall, apiType: 'dealer' | 'dealsink' = 'dealer'): string {
    const className = apiType === 'dealer' ? 'DealerExample' : 'DealsinkExample';
    const parameterList = call.parameters.map((p, i) => `"${p}"`).join(', ');
    
    return `// MarkitWire ${apiType.charAt(0).toUpperCase() + apiType.slice(1)} API Call
// Generated for: ${call.functionName}
// Note: This is simulated since Windows DLLs cannot run on Linux

import com.swapswire.sw_api.*;

public class ${className} {
    public static void main(String[] args) {
        long sessionHandle = -1;
        long loginHandle = -1;
        
        try {
            // Connect to MarkitWire
            int rc = SWAPILink.SW_Connect("${call.host}", 120, null, sessionHandle);
            if (rc < SWAPIConstants.SWERR_Success) {
                System.out.println("Failed connection: " + SWAPILink.getError(rc));
                return;
            }
            System.out.println("Connected successfully");
            
            // Login
            rc = SWAPILink.SW_Login(sessionHandle, "${call.username}", "${call.password}", loginHandle);
            if (rc < SWAPIConstants.SWERR_Success) {
                System.out.println("Failed to login: " + SWAPILink.getError(rc));
                SWAPILink.SW_Disconnect(sessionHandle);
                return;
            }
            System.out.println("Logged in successfully");
            
            // Execute specific API call: ${call.functionName}
            ${this.generateFunctionCall(call.functionName, call.parameters)}
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        } finally {
            // Cleanup
            if (loginHandle != -1) {
                SWAPILink.SW_Logout(loginHandle);
            }
            if (sessionHandle != -1) {
                SWAPILink.SW_Disconnect(sessionHandle);
            }
        }
    }
}`;
  }

  private generateFunctionCall(functionName: string, parameters: any[]): string {
    switch (functionName) {
      case 'SW_Connect':
      case 'SW_Login':
      case 'SW_Logout':
      case 'SW_Disconnect':
        return `// ${functionName} is handled in the main connection flow above`;
        
      case 'SW_GetDealList':
        return `            String dealList = null;
            rc = SWAPILink.SW_GetDealList(loginHandle, "", dealList);
            if (rc >= SWAPIConstants.SWERR_Success) {
                System.out.println("Deal list retrieved:");
                System.out.println(dealList);
            } else {
                System.out.println("Failed to get deal list: " + SWAPILink.getError(rc));
            }`;

      case 'SW_SendDeal':
        return `            String dealXML = "${parameters[1] || '<?xml version="1.0"?><trade>...</trade>'}";
            String addressee = "${parameters[2] || 'COUNTERPARTY'}";
            long dealHandle = -1;
            rc = SWAPILink.SW_SendDeal(loginHandle, dealXML, addressee, dealHandle);
            if (rc >= SWAPIConstants.SWERR_Success) {
                System.out.println("Deal sent successfully, handle: " + dealHandle);
            } else {
                System.out.println("Failed to send deal: " + SWAPILink.getError(rc));
            }`;

      case 'SW_AffirmDeal':
        return `            long dealVersionHandle = ${parameters[1] || '12345'};
            rc = SWAPILink.SW_AffirmDeal(loginHandle, dealVersionHandle);
            if (rc >= SWAPIConstants.SWERR_Success) {
                System.out.println("Deal affirmed successfully");
            } else {
                System.out.println("Failed to affirm deal: " + SWAPILink.getError(rc));
            }`;

      case 'SW_RejectDeal':
        return `            long dealVersionHandle = ${parameters[1] || '12345'};
            String reason = "${parameters[2] || 'Pricing disagreement'}";
            rc = SWAPILink.SW_RejectDeal(loginHandle, dealVersionHandle, reason);
            if (rc >= SWAPIConstants.SWERR_Success) {
                System.out.println("Deal rejected successfully");
            } else {
                System.out.println("Failed to reject deal: " + SWAPILink.getError(rc));
            }`;

      case 'SW_Poll':
        return `            int timeout = ${parameters[1] || '1000'};
            rc = SWAPILink.SW_Poll(loginHandle, timeout);
            if (rc >= SWAPIConstants.SWERR_Success) {
                System.out.println("Poll completed, events received");
            } else {
                System.out.println("Poll failed: " + SWAPILink.getError(rc));
            }`;

      default:
        const paramList = parameters.map((p, i) => `param${i}`).join(', ');
        let paramDeclarations = '';
        
        parameters.forEach((p, i) => {
          if (typeof p === 'string') {
            paramDeclarations += `            String param${i} = "${p}";\\n`;
          } else if (typeof p === 'number') {
            paramDeclarations += `            long param${i} = ${p};\\n`;
          } else {
            paramDeclarations += `            String param${i} = "${JSON.stringify(p)}";\\n`;
          }
        });

        return `${paramDeclarations}            rc = SWAPILink.${functionName}(${paramList});
            if (rc >= SWAPIConstants.SWERR_Success) {
                System.out.println("${functionName} completed successfully");
            } else {
                System.out.println("${functionName} failed: " + SWAPILink.getError(rc));
            }`;
    }
  }
}

export const markitWireSimulator = new MarkitWireSimulator();