import { type User, type InsertUser, type ApiEndpoint, type InsertApiEndpoint, type TestSession, type InsertTestSession, type ApiRequest, type InsertApiRequest, type LibraryFile, type InsertLibraryFile } from "@shared/schema";
import { randomUUID } from "crypto";

export interface IStorage {
  // Users
  getUser(id: string): Promise<User | undefined>;
  getUserByUsername(username: string): Promise<User | undefined>;
  createUser(user: InsertUser): Promise<User>;

  // API Endpoints
  getApiEndpoints(): Promise<ApiEndpoint[]>;
  getApiEndpointsByCategory(category: string): Promise<ApiEndpoint[]>;
  createApiEndpoint(endpoint: InsertApiEndpoint): Promise<ApiEndpoint>;
  updateApiEndpoint(id: string, endpoint: Partial<ApiEndpoint>): Promise<ApiEndpoint | undefined>;

  // Test Sessions
  getTestSessions(userId: string): Promise<TestSession[]>;
  getTestSession(id: string): Promise<TestSession | undefined>;
  createTestSession(session: InsertTestSession): Promise<TestSession>;
  updateTestSession(id: string, session: Partial<TestSession>): Promise<TestSession | undefined>;

  // API Requests
  getApiRequests(sessionId: string): Promise<ApiRequest[]>;
  createApiRequest(request: InsertApiRequest): Promise<ApiRequest>;
  updateApiRequest(id: string, request: Partial<ApiRequest>): Promise<ApiRequest | undefined>;

  // Library Files
  getLibraryFiles(): Promise<LibraryFile[]>;
  createLibraryFile(file: InsertLibraryFile): Promise<LibraryFile>;
  updateLibraryFile(id: string, file: Partial<LibraryFile>): Promise<LibraryFile | undefined>;
}

export class MemStorage implements IStorage {
  private users: Map<string, User>;
  private apiEndpoints: Map<string, ApiEndpoint>;
  private testSessions: Map<string, TestSession>;
  private apiRequests: Map<string, ApiRequest>;
  private libraryFiles: Map<string, LibraryFile>;

  constructor() {
    this.users = new Map();
    this.apiEndpoints = new Map();
    this.testSessions = new Map();
    this.apiRequests = new Map();
    this.libraryFiles = new Map();
    this.initializeDefaultData();
  }

  private initializeDefaultData() {
    // Initialize default MarkitWire API endpoints
    const defaultEndpoints: InsertApiEndpoint[] = [
      {
        name: "SW_Connect",
        category: "Session Management",
        method: "POST",
        url: "https://mw.uat.api.markit.com/v1/session/connect",
        description: "Establish connection to MarkitWire server",
        parameters: { server: "string", timeout: "number" },
        headers: { "Content-Type": "application/json" },
        isActive: true,
      },
      {
        name: "SW_Login",
        category: "Session Management",
        method: "POST",
        url: "https://mw.uat.api.markit.com/v1/session/login",
        description: "Login to MarkitWire with credentials",
        parameters: { sessionHandle: "number", username: "string", password: "string" },
        headers: { "Content-Type": "application/json" },
        isActive: true,
      },
      {
        name: "SW_Logout",
        category: "Session Management", 
        method: "POST",
        url: "https://mw.uat.api.markit.com/v1/session/logout",
        description: "Logout from MarkitWire session",
        parameters: { loginHandle: "number" },
        headers: { "Content-Type": "application/json" },
        isActive: true,
      },
      {
        name: "SW_SubmitDeal",
        category: "Deal Management",
        method: "POST",
        url: "https://mw.uat.api.markit.com/v1/deals/submit",
        description: "Submit a new deal to MarkitWire",
        parameters: { loginHandle: "number", dealData: "object" },
        headers: { "Content-Type": "application/json" },
        isActive: true,
      },
      {
        name: "SW_AffirmDeal",
        category: "Deal Management",
        method: "POST",
        url: "https://mw.uat.api.markit.com/v1/deals/affirm",
        description: "Affirm a deal in MarkitWire",
        parameters: { loginHandle: "number", dealVersionHandle: "string" },
        headers: { "Content-Type": "application/json" },
        isActive: true,
      },
      {
        name: "SW_ReleaseDeal",
        category: "Deal Management",
        method: "POST",
        url: "https://mw.uat.api.markit.com/v1/deals/release",
        description: "Release a deal in MarkitWire",
        parameters: { loginHandle: "number", dealVersionHandle: "string" },
        headers: { "Content-Type": "application/json" },
        isActive: true,
      },
      {
        name: "SW_WithdrawDeal",
        category: "Deal Management",
        method: "POST",
        url: "https://mw.uat.api.markit.com/v1/deals/withdraw",
        description: "Withdraw a deal from MarkitWire",
        parameters: { loginHandle: "number", dealVersionHandle: "string" },
        headers: { "Content-Type": "application/json" },
        isActive: true,
      },
      {
        name: "SW_Poll",
        category: "Notifications",
        method: "GET",
        url: "https://mw.uat.api.markit.com/v1/notifications/poll",
        description: "Poll for notifications",
        parameters: { loginHandle: "number" },
        headers: { "Content-Type": "application/json" },
        isActive: true,
      },
      {
        name: "SW_GetNotification",
        category: "Notifications",
        method: "GET",
        url: "https://mw.uat.api.markit.com/v1/notifications/{id}",
        description: "Get specific notification",
        parameters: { loginHandle: "number", notificationId: "string" },
        headers: { "Content-Type": "application/json" },
        isActive: true,
      },
      {
        name: "SW_GetDealByID",
        category: "Data Retrieval",
        method: "GET",
        url: "https://mw.uat.api.markit.com/v1/deals/{id}",
        description: "Retrieve deal by ID",
        parameters: { loginHandle: "number", dealId: "string" },
        headers: { "Content-Type": "application/json" },
        isActive: true,
      },
      {
        name: "SW_GetDealsForBook",
        category: "Data Retrieval",
        method: "GET",
        url: "https://mw.uat.api.markit.com/v1/deals/book/{bookId}",
        description: "Get all deals for a specific book",
        parameters: { loginHandle: "number", bookId: "string" },
        headers: { "Content-Type": "application/json" },
        isActive: true,
      },
    ];

    defaultEndpoints.forEach(endpoint => {
      this.createApiEndpoint(endpoint);
    });
  }

  // Users
  async getUser(id: string): Promise<User | undefined> {
    return this.users.get(id);
  }

  async getUserByUsername(username: string): Promise<User | undefined> {
    return Array.from(this.users.values()).find(user => user.username === username);
  }

  async createUser(insertUser: InsertUser): Promise<User> {
    const id = randomUUID();
    const user: User = { ...insertUser, id };
    this.users.set(id, user);
    return user;
  }

  // API Endpoints
  async getApiEndpoints(): Promise<ApiEndpoint[]> {
    return Array.from(this.apiEndpoints.values());
  }

  async getApiEndpointsByCategory(category: string): Promise<ApiEndpoint[]> {
    return Array.from(this.apiEndpoints.values()).filter(endpoint => endpoint.category === category);
  }

  async createApiEndpoint(insertEndpoint: InsertApiEndpoint): Promise<ApiEndpoint> {
    const id = randomUUID();
    const endpoint: ApiEndpoint = { ...insertEndpoint, id };
    this.apiEndpoints.set(id, endpoint);
    return endpoint;
  }

  async updateApiEndpoint(id: string, updateData: Partial<ApiEndpoint>): Promise<ApiEndpoint | undefined> {
    const endpoint = this.apiEndpoints.get(id);
    if (endpoint) {
      const updated = { ...endpoint, ...updateData };
      this.apiEndpoints.set(id, updated);
      return updated;
    }
    return undefined;
  }

  // Test Sessions
  async getTestSessions(userId: string): Promise<TestSession[]> {
    return Array.from(this.testSessions.values()).filter(session => session.userId === userId);
  }

  async getTestSession(id: string): Promise<TestSession | undefined> {
    return this.testSessions.get(id);
  }

  async createTestSession(insertSession: InsertTestSession): Promise<TestSession> {
    const id = randomUUID();
    const session: TestSession = { 
      ...insertSession, 
      id, 
      createdAt: new Date(),
      endedAt: null
    };
    this.testSessions.set(id, session);
    return session;
  }

  async updateTestSession(id: string, updateData: Partial<TestSession>): Promise<TestSession | undefined> {
    const session = this.testSessions.get(id);
    if (session) {
      const updated = { ...session, ...updateData };
      this.testSessions.set(id, updated);
      return updated;
    }
    return undefined;
  }

  // API Requests
  async getApiRequests(sessionId: string): Promise<ApiRequest[]> {
    return Array.from(this.apiRequests.values()).filter(request => request.sessionId === sessionId);
  }

  async createApiRequest(insertRequest: InsertApiRequest): Promise<ApiRequest> {
    const id = randomUUID();
    const request: ApiRequest = { 
      ...insertRequest, 
      id, 
      timestamp: new Date()
    };
    this.apiRequests.set(id, request);
    return request;
  }

  async updateApiRequest(id: string, updateData: Partial<ApiRequest>): Promise<ApiRequest | undefined> {
    const request = this.apiRequests.get(id);
    if (request) {
      const updated = { ...request, ...updateData };
      this.apiRequests.set(id, updated);
      return updated;
    }
    return undefined;
  }

  // Library Files
  async getLibraryFiles(): Promise<LibraryFile[]> {
    return Array.from(this.libraryFiles.values());
  }

  async createLibraryFile(insertFile: InsertLibraryFile): Promise<LibraryFile> {
    const id = randomUUID();
    const file: LibraryFile = { 
      ...insertFile, 
      id, 
      uploadedAt: new Date()
    };
    this.libraryFiles.set(id, file);
    return file;
  }

  async updateLibraryFile(id: string, updateData: Partial<LibraryFile>): Promise<LibraryFile | undefined> {
    const file = this.libraryFiles.get(id);
    if (file) {
      const updated = { ...file, ...updateData };
      this.libraryFiles.set(id, updated);
      return updated;
    }
    return undefined;
  }
}

export const storage = new MemStorage();
