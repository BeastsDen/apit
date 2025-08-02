import type { Express, Request } from "express";
import { createServer, type Server } from "http";
import { storage } from "./storage";
import { insertMarkitWireApiCallSchema, insertTestSessionSchema, insertLibraryFileSchema } from "@shared/schema";
import { z } from "zod";
import multer from "multer";
import { extractZipFile } from "./services/zip-extractor";
import { markitWireJavaService } from "./services/markitwire-java";
import { markitWireApiEndpoints } from "./services/markitwire-endpoints";

interface MulterRequest extends Request {
  file?: Express.Multer.File;
}

const upload = multer({ dest: 'uploads/' });

export async function registerRoutes(app: Express): Promise<Server> {
  
  // MarkitWire API Endpoints
  app.get("/api/endpoints", async (req, res) => {
    try {
      // Return the predefined MarkitWire API endpoints
      res.json(markitWireApiEndpoints);
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch endpoints" });
    }
  });

  app.get("/api/endpoints/category/:category", async (req, res) => {
    try {
      const { category } = req.params;
      const endpoints = markitWireApiEndpoints.filter(ep => 
        ep.category.toLowerCase() === category.toLowerCase()
      );
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

  // MarkitWire API Calls
  app.get("/api/calls/:sessionId", async (req, res) => {
    try {
      const { sessionId } = req.params;
      // Note: storage.getMarkitWireApiCalls would need to be implemented
      res.json([]); // Placeholder for now
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch API calls" });
    }
  });

  app.post("/api/markitwire/execute", async (req, res) => {
    try {
      const { 
        functionName, 
        host, 
        username, 
        password, 
        parameters = [], 
        apiType = 'dealer',
        sessionId 
      } = req.body;
      
      if (!functionName || !host || !username || !password) {
        return res.status(400).json({ 
          error: "Function name, host, username, and password are required" 
        });
      }

      const apiCall = {
        functionName,
        host,
        username,
        password,
        parameters
      };

      let result;
      if (apiType === 'dealsink') {
        result = await markitWireJavaService.executeDealsinkCommand(apiCall);
      } else {
        result = await markitWireJavaService.executeDealerCommand(apiCall);
      }

      // Generate Java code for this call
      const javaCode = markitWireJavaService.generateJavaCode(apiCall, apiType);

      res.json({
        ...result,
        javaCode,
        apiCall
      });
    } catch (error) {
      console.error("MarkitWire API execution failed:", error);
      res.status(500).json({ 
        error: "Failed to execute MarkitWire API call", 
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

  app.post("/api/libraries/upload", upload.single('library'), async (req: MulterRequest, res) => {
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

  // Available Commands
  app.get("/api/markitwire/commands", async (req, res) => {
    try {
      const { apiType = 'dealer' } = req.query;
      
      let commands;
      if (apiType === 'dealsink') {
        commands = await markitWireJavaService.getDealsinkCommands();
      } else {
        commands = await markitWireJavaService.getDealerCommands();
      }
      
      res.json({ commands, apiType });
    } catch (error) {
      res.status(500).json({ error: "Failed to fetch available commands" });
    }
  });

  app.get("/api/markitwire/java-code/:functionName", async (req, res) => {
    try {
      const { functionName } = req.params;
      const { apiType = 'dealer', host = 'example.com:9009', username = 'USERNAME', password = 'PASSWORD' } = req.query;
      
      // Find the endpoint definition
      const endpoint = markitWireApiEndpoints.find(ep => ep.functionName === functionName);
      if (!endpoint) {
        return res.status(404).json({ error: "Function not found" });
      }

      // Generate sample parameters
      const sampleParams = endpoint.parameters?.map((p: any) => p.example || `sample_${p.name}`) || [];
      
      const apiCall = {
        functionName,
        host: String(host),
        username: String(username), 
        password: String(password),
        parameters: sampleParams
      };

      const javaCode = markitWireJavaService.generateJavaCode(apiCall, apiType as 'dealer' | 'dealsink');
      
      res.json({ 
        functionName, 
        javaCode, 
        endpoint,
        sampleParameters: sampleParams
      });
    } catch (error) {
      res.status(500).json({ error: "Failed to generate Java code" });
    }
  });

  // Connection Test
  app.post("/api/markitwire/test-connection", async (req, res) => {
    try {
      const { host, username, password } = req.body;
      if (!host || !username || !password) {
        return res.status(400).json({ error: "Host, username, and password are required" });
      }

      // Test connection using SW_Connect and SW_Login
      const connectCall = {
        functionName: 'SW_Connect',
        host,
        username,
        password,
        parameters: [host, '120']
      };

      const result = await markitWireJavaService.executeDealerCommand(connectCall);
      res.json({
        success: result.success,
        message: result.success ? 'Connection successful' : 'Connection failed',
        details: result
      });
    } catch (error) {
      res.status(500).json({ error: "Connection test failed", details: error?.toString() });
    }
  });

  const httpServer = createServer(app);
  return httpServer;
}
