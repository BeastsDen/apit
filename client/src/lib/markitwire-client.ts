import axios, { AxiosResponse } from 'axios';

export interface MarkitWireCredentials {
  username: string;
  password: string;
  server?: string;
}

export interface SessionInfo {
  sessionHandle: number;
  loginHandle: number;
  status: string;
  timestamp: string;
  serverInfo?: {
    version: string;
    environment: string;
    capabilities: string[];
  };
  user?: {
    id: string;
    organization: string;
    permissions: string[];
  };
}

export interface ApiCallOptions {
  method: string;
  endpoint: string;
  parameters?: Record<string, any>;
  headers?: Record<string, string>;
  timeout?: number;
}

export class MarkitWireClient {
  private baseUrl: string;
  private sessionHandle: number | null = null;
  private loginHandle: number | null = null;
  private defaultTimeout: number = 30000;

  constructor(baseUrl: string = 'https://mw.uat.api.markit.com') {
    this.baseUrl = baseUrl;
  }

  async connect(server: string, timeout: number = 120): Promise<SessionInfo> {
    try {
      const response = await axios.post(`${this.baseUrl}/v1/session/connect`, {
        server,
        timeout
      }, {
        timeout: this.defaultTimeout,
        headers: {
          'Content-Type': 'application/json'
        }
      });

      if (response.data.sessionHandle) {
        this.sessionHandle = response.data.sessionHandle;
      }

      return response.data;
    } catch (error) {
      throw new Error(`Connection failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async login(credentials: MarkitWireCredentials): Promise<SessionInfo> {
    if (!this.sessionHandle) {
      throw new Error('No active session. Please connect first.');
    }

    try {
      const response = await axios.post(`${this.baseUrl}/v1/session/login`, {
        sessionHandle: this.sessionHandle,
        username: credentials.username,
        password: credentials.password
      }, {
        timeout: this.defaultTimeout,
        headers: {
          'Content-Type': 'application/json'
        }
      });

      if (response.data.loginHandle) {
        this.loginHandle = response.data.loginHandle;
      }

      return response.data;
    } catch (error) {
      throw new Error(`Login failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async logout(): Promise<void> {
    if (!this.loginHandle) {
      throw new Error('No active login session.');
    }

    try {
      await axios.post(`${this.baseUrl}/v1/session/logout`, {
        loginHandle: this.loginHandle
      }, {
        timeout: this.defaultTimeout,
        headers: {
          'Content-Type': 'application/json'
        }
      });

      this.loginHandle = null;
    } catch (error) {
      throw new Error(`Logout failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async disconnect(): Promise<void> {
    if (!this.sessionHandle) {
      return; // Already disconnected
    }

    try {
      await axios.post(`${this.baseUrl}/v1/session/disconnect`, {
        sessionHandle: this.sessionHandle
      }, {
        timeout: this.defaultTimeout,
        headers: {
          'Content-Type': 'application/json'
        }
      });

      this.sessionHandle = null;
    } catch (error) {
      throw new Error(`Disconnect failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async makeApiCall(options: ApiCallOptions): Promise<AxiosResponse> {
    const { method, endpoint, parameters = {}, headers = {}, timeout = this.defaultTimeout } = options;

    // Add authentication parameters if logged in
    const requestParams = {
      ...parameters,
      ...(this.loginHandle && { loginHandle: this.loginHandle }),
      ...(this.sessionHandle && { sessionHandle: this.sessionHandle })
    };

    const url = endpoint.startsWith('http') ? endpoint : `${this.baseUrl}${endpoint}`;

    try {
      const response = await axios({
        method: method.toLowerCase() as any,
        url,
        data: ['GET', 'DELETE'].includes(method.toUpperCase()) ? undefined : requestParams,
        params: ['GET', 'DELETE'].includes(method.toUpperCase()) ? requestParams : undefined,
        headers: {
          'Content-Type': 'application/json',
          ...headers
        },
        timeout
      });

      return response;
    } catch (error) {
      if (axios.isAxiosError(error)) {
        throw new Error(`API call failed: ${error.response?.statusText || error.message}`);
      }
      throw error;
    }
  }

  // Deal Management Methods
  async submitDeal(dealData: Record<string, any>): Promise<any> {
    return this.makeApiCall({
      method: 'POST',
      endpoint: '/v1/deals/submit',
      parameters: { dealData }
    });
  }

  async affirmDeal(dealVersionHandle: string): Promise<any> {
    return this.makeApiCall({
      method: 'POST',
      endpoint: '/v1/deals/affirm',
      parameters: { dealVersionHandle }
    });
  }

  async releaseDeal(dealVersionHandle: string): Promise<any> {
    return this.makeApiCall({
      method: 'POST',
      endpoint: '/v1/deals/release',
      parameters: { dealVersionHandle }
    });
  }

  async withdrawDeal(dealVersionHandle: string): Promise<any> {
    return this.makeApiCall({
      method: 'POST',
      endpoint: '/v1/deals/withdraw',
      parameters: { dealVersionHandle }
    });
  }

  // Data Retrieval Methods
  async getDealById(dealId: string): Promise<any> {
    return this.makeApiCall({
      method: 'GET',
      endpoint: `/v1/deals/${dealId}`,
      parameters: {}
    });
  }

  async getDealsForBook(bookId: string): Promise<any> {
    return this.makeApiCall({
      method: 'GET',
      endpoint: `/v1/deals/book/${bookId}`,
      parameters: {}
    });
  }

  // Notification Methods
  async poll(): Promise<any> {
    return this.makeApiCall({
      method: 'GET',
      endpoint: '/v1/notifications/poll',
      parameters: {}
    });
  }

  async getNotification(notificationId: string): Promise<any> {
    return this.makeApiCall({
      method: 'GET',
      endpoint: `/v1/notifications/${notificationId}`,
      parameters: {}
    });
  }

  // Session state getters
  get isConnected(): boolean {
    return this.sessionHandle !== null;
  }

  get isLoggedIn(): boolean {
    return this.loginHandle !== null;
  }

  get currentSessionHandle(): number | null {
    return this.sessionHandle;
  }

  get currentLoginHandle(): number | null {
    return this.loginHandle;
  }
}

// Export singleton instance
export const markitWireClient = new MarkitWireClient();
