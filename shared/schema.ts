import { sql } from "drizzle-orm";
import { pgTable, text, varchar, jsonb, timestamp, integer, boolean } from "drizzle-orm/pg-core";
import { createInsertSchema } from "drizzle-zod";
import { z } from "zod";

export const users = pgTable("users", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  username: text("username").notNull().unique(),
  password: text("password").notNull(),
});

export const apiEndpoints = pgTable("api_endpoints", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  name: text("name").notNull(),
  category: text("category").notNull(),
  method: text("method").notNull(),
  url: text("url").notNull(),
  description: text("description"),
  parameters: jsonb("parameters"),
  headers: jsonb("headers"),
  isActive: boolean("is_active").default(true),
});

export const testSessions = pgTable("test_sessions", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  userId: varchar("user_id").references(() => users.id),
  name: text("name").notNull(),
  status: text("status").notNull().default("active"),
  createdAt: timestamp("created_at").defaultNow(),
  endedAt: timestamp("ended_at"),
});

export const apiRequests = pgTable("api_requests", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  sessionId: varchar("session_id").references(() => testSessions.id),
  endpointId: varchar("endpoint_id").references(() => apiEndpoints.id),
  method: text("method").notNull(),
  url: text("url").notNull(),
  headers: jsonb("headers"),
  body: text("body"),
  responseStatus: integer("response_status"),
  responseHeaders: jsonb("response_headers"),
  responseBody: text("response_body"),
  responseTime: integer("response_time"),
  securityFindings: jsonb("security_findings"),
  timestamp: timestamp("timestamp").defaultNow(),
});

export const libraryFiles = pgTable("library_files", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  filename: text("filename").notNull(),
  version: text("version"),
  status: text("status").notNull().default("loaded"),
  extractedPath: text("extracted_path"),
  uploadedAt: timestamp("uploaded_at").defaultNow(),
});

// Insert schemas
export const insertUserSchema = createInsertSchema(users).pick({
  username: true,
  password: true,
});

export const insertApiEndpointSchema = createInsertSchema(apiEndpoints).omit({
  id: true,
});

export const insertTestSessionSchema = createInsertSchema(testSessions).omit({
  id: true,
  createdAt: true,
});

export const insertApiRequestSchema = createInsertSchema(apiRequests).omit({
  id: true,
  timestamp: true,
});

export const insertLibraryFileSchema = createInsertSchema(libraryFiles).omit({
  id: true,
  uploadedAt: true,
});

// Types
export type User = typeof users.$inferSelect;
export type InsertUser = z.infer<typeof insertUserSchema>;
export type ApiEndpoint = typeof apiEndpoints.$inferSelect;
export type InsertApiEndpoint = z.infer<typeof insertApiEndpointSchema>;
export type TestSession = typeof testSessions.$inferSelect;
export type InsertTestSession = z.infer<typeof insertTestSessionSchema>;
export type ApiRequest = typeof apiRequests.$inferSelect;
export type InsertApiRequest = z.infer<typeof insertApiRequestSchema>;
export type LibraryFile = typeof libraryFiles.$inferSelect;
export type InsertLibraryFile = z.infer<typeof insertLibraryFileSchema>;
