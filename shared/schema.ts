import { sql } from "drizzle-orm";
import { pgTable, text, varchar, jsonb, timestamp, integer, boolean } from "drizzle-orm/pg-core";
import { createInsertSchema } from "drizzle-zod";
import { z } from "zod";

export const users = pgTable("users", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  username: text("username").notNull().unique(),
  password: text("password").notNull(),
});

export const markitWireApiEndpoints = pgTable("markitwire_api_endpoints", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  name: text("name").notNull(),
  category: text("category").notNull(),
  functionName: text("function_name").notNull(),
  description: text("description"),
  parameters: jsonb("parameters"),
  sampleCode: text("sample_code"),
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

export const markitWireApiCalls = pgTable("markitwire_api_calls", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  sessionId: varchar("session_id").references(() => testSessions.id),
  endpointId: varchar("endpoint_id").references(() => markitWireApiEndpoints.id),
  functionName: text("function_name").notNull(),
  host: text("host").notNull(),
  username: text("username").notNull(),
  parameters: jsonb("parameters"),
  javaCode: text("java_code"),
  response: jsonb("response"),
  responseTime: integer("response_time"),
  errorMessage: text("error_message"),
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

export const insertMarkitWireApiEndpointSchema = createInsertSchema(markitWireApiEndpoints).omit({
  id: true,
});

export const insertTestSessionSchema = createInsertSchema(testSessions).omit({
  id: true,
  createdAt: true,
});

export const insertMarkitWireApiCallSchema = createInsertSchema(markitWireApiCalls).omit({
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
export type MarkitWireApiEndpoint = typeof markitWireApiEndpoints.$inferSelect;
export type InsertMarkitWireApiEndpoint = z.infer<typeof insertMarkitWireApiEndpointSchema>;
export type TestSession = typeof testSessions.$inferSelect;
export type InsertTestSession = z.infer<typeof insertTestSessionSchema>;
export type MarkitWireApiCall = typeof markitWireApiCalls.$inferSelect;
export type InsertMarkitWireApiCall = z.infer<typeof insertMarkitWireApiCallSchema>;
export type LibraryFile = typeof libraryFiles.$inferSelect;
export type InsertLibraryFile = z.infer<typeof insertLibraryFileSchema>;
