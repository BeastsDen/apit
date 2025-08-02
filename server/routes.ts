import type { Express } from "express";
import { createServer, type Server } from "http";
import { storage } from "./storage";
import { insertApiRequestSchema, insertTestSessionSchema, insertLibraryFileSchema } from "@shared/schema";
import { z } from "zod";
import multer from "multer";
import { extractZipFile } from "./services/zip-extractor";
import { makeApiRequest } from "./services/markitwire-api";

const upload = multer({ dest: 'uploads/' });

export async function registerRoutes(app: Express): Promise<Server> {
  
  // API Endpoints
  app.get("/api/endpoints", async (req, res) => {
    try {
      const endpoints = await storage.getApiEndpoints();
      res.json(endpoints);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch endpoints" });
    }
  });

  app.get("/api/endpoints/category/:category", async (req, res) => {
    try {
      const { category } = req.params;
      const endpoints = await storage.getApiEndpointsByCategory(category);
      res.json(endpoints);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch endpoints by category" });
    }
  });

  // Test Sessions
  app.get("/api/sessions", async (req, res) => {
    try {
      const { userId } = req.query;
      if (!userId || typeof userId !== 'string') {
        return res.status(400).json({ error: "User ID is required" });
      }
      const sessions = await storage.getTestSessions(userId);
      res.json(sessions);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch test sessions" });
    }
  });

  app.post("/api/sessions", async (req, res) => {
    try {
      const validatedData = insertTestSessionSchema.parse(req.body);
      const session = await storage.createTestSession(validatedData);
      res.json(session);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: "Invalid session data", details: error.errors });
      }
      res.status(500).json({ error: "Failed to create test session" });
    }
  });

  app.patch("/api/sessions/:id", async (req, res) => {
    try {
      const { id } = req.params;
      const session = await storage.updateTestSession(id, req.body);
      if (!session) {
        return res.status(404).json({ error: "Session not found" });
      }
      res.json(session);
    } catch (error) {
      res.status(500).json({ error: "Failed to update session" });
    }
  });

  // API Requests
  app.get("/api/requests/:sessionId", async (req, res) => {
    try {
      const { sessionId } = req.params;
      const requests = await storage.getApiRequests(sessionId);
      res.json(requests);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch requests" });
    }
  });

  app.post("/api/requests/execute", async (req, res) => {
    try {
      const { endpointId, method, url, headers, body, sessionId, securityOptions } = req.body;
      
      const startTime = Date.now();
      
      // Execute the API request
      const response = await makeApiRequest({
        method,
        url,
        headers,
        body,
        securityOptions
      });

      const responseTime = Date.now() - startTime;

      // Store the request and response
      const requestData = insertApiRequestSchema.parse({
        sessionId,
        endpointId,
        method,
        url,
        headers,
        body: typeof body === 'string' ? body : JSON.stringify(body),
        responseStatus: response.status,
        responseHeaders: response.headers,
        responseBody: response.data,
        responseTime,
        securityFindings: response.securityFindings || {}
      });

      const savedRequest = await storage.createApiRequest(requestData);
      res.json({
        request: savedRequest,
        response: {
          status: response.status,
          headers: response.headers,
          data: response.data,
          responseTime,
          securityFindings: response.securityFindings
        }
      });
    } catch (error) {
      console.error("API request execution failed:", error);
      res.status(500).json({ 
        error: "Failed to execute API request", 
        details: error instanceof Error ? error.message : "Unknown error"
      });
    }
  });

  // Library Management
  app.get("/api/libraries", async (req, res) => {
    try {
      const libraries = await storage.getLibraryFiles();
      res.json(libraries);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch libraries" });
    }
  });

  app.post("/api/libraries/upload", upload.single('library'), async (req, res) => {
    try {
      if (!req.file) {
        return res.status(400).json({ error: "No file uploaded" });
      }

      const { filename, path } = req.file;
      
      // Extract ZIP file if applicable
      let extractedPath = path;
      if (filename.endsWith('.zip')) {
        extractedPath = await extractZipFile(path);
      }

      const libraryData = insertLibraryFileSchema.parse({
        filename,
        version: req.body.version || "unknown",
        status: "loaded",
        extractedPath
      });

      const library = await storage.createLibraryFile(libraryData);
      res.json(library);
    } catch (error) {
      console.error("Library upload failed:", error);
      res.status(500).json({ error: "Failed to upload library" });
    }
  });

  // Security Testing Payloads
  app.get("/api/payloads/:type", async (req, res) => {
    try {
      const { type } = req.params;
      
      const payloadSets: Record<string, string[]> = {
        'sql-injection': [
          "' OR '1'='1",
          "'; DROP TABLE users; --",
          "' UNION SELECT null, username, password FROM users --",
          "1' AND (SELECT COUNT(*) FROM users) > 0 --"
        ],
        'xss': [
          "<script>alert('XSS')</script>",
          "javascript:alert('XSS')",
          "<img src=x onerror=alert('XSS')>",
          "';alert(String.fromCharCode(88,83,83))//';alert(String.fromCharCode(88,83,83))//\";alert(String.fromCharCode(88,83,83))//\";alert(String.fromCharCode(88,83,83))//--></SCRIPT>\">'><SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>"
        ],
        'authentication-bypass': [
          '{"username": "admin", "password": ""}',
          '{"username": "admin\\"--", "password": "anything"}',
          '{"username": {"$ne": null}, "password": {"$ne": null}}',
          '{"username": "admin", "password": {"$regex": ".*"}}'
        ],
        'parameter-pollution': [
          'param=value1&param=value2',
          'array[0]=value1&array[1]=value2&array[0]=overwrite',
          'user[name]=admin&user[role]=user&user[role]=admin'
        ],
        'buffer-overflow': [
          'A'.repeat(1000),
          'A'.repeat(10000),
          '%s%s%s%s%s%s%s%s%s%s',
          '\x00'.repeat(100)
        ]
      };

      const payloads = payloadSets[type] || [];
      res.json({ type, payloads });
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch payloads" });
    }
  });

  const httpServer = createServer(app);
  return httpServer;
}
