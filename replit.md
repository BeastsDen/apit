# MarkitWire API Penetration Testing Tool

## Overview

This is a comprehensive penetration testing application specifically designed for security testing of MarkitWire APIs. The application provides a specialized interface for security professionals to conduct thorough API security assessments, including SQL injection testing, parameter fuzzing, authentication bypass attempts, and other security vulnerability detection techniques. Built as a full-stack web application, it combines a React-based frontend with an Express.js backend, utilizing PostgreSQL for data persistence and Drizzle ORM for database operations.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture
The frontend is built using React with TypeScript and follows a component-based architecture. The application uses Vite as the build tool and development server, providing fast hot module replacement and optimized builds. The UI is constructed using shadcn/ui components built on top of Radix UI primitives, styled with Tailwind CSS for a modern, accessible interface optimized for security testing workflows.

Key architectural decisions:
- **State Management**: Uses TanStack Query (React Query) for server state management, providing caching, synchronization, and background updates
- **Routing**: Implements Wouter for lightweight client-side routing
- **Component Library**: Adopts shadcn/ui for consistent, accessible UI components
- **Styling**: Utilizes Tailwind CSS with custom CSS variables for theming, particularly optimized for dark mode penetration testing interfaces

### Backend Architecture
The backend follows a RESTful API design using Express.js with TypeScript. The server implements a clean separation of concerns with dedicated modules for routing, storage abstraction, and external service integration.

Core architectural patterns:
- **Route Handler Pattern**: Centralized route registration in `server/routes.ts`
- **Storage Abstraction**: Interface-based storage layer (`IStorage`) with in-memory implementation for development
- **Service Layer**: Dedicated services for MarkitWire API integration and file processing
- **Middleware Pipeline**: Request logging, error handling, and JSON parsing middleware

### Data Storage Architecture
The application uses PostgreSQL as the primary database with Drizzle ORM for type-safe database operations. The schema is designed to support penetration testing workflows with entities for API endpoints, test sessions, requests, and security findings.

Database design decisions:
- **UUID Primary Keys**: Uses PostgreSQL's `gen_random_uuid()` for secure, distributed-friendly identifiers
- **JSONB Storage**: Leverages PostgreSQL's JSONB for flexible storage of API parameters, headers, and security findings
- **Temporal Tracking**: Implements timestamps for test sessions and API requests to support time-based analysis

### Security Testing Framework
The application implements a comprehensive security testing framework with configurable test suites:
- **Payload Libraries**: Organized collections of penetration testing payloads for various attack vectors
- **Automated Analysis**: Server-side security analysis of API responses for vulnerability detection
- **Session Management**: Persistent test sessions for organizing and tracking security assessments
- **Real-time Feedback**: Live updates of security findings during testing

### Build and Development Architecture
The project uses a modern build pipeline with separate development and production configurations:
- **Development**: Vite dev server with HMR for frontend, tsx for backend hot reloading
- **Production**: Vite build for static assets, esbuild for backend bundling
- **Type Safety**: Comprehensive TypeScript configuration with strict type checking across frontend, backend, and shared code

## External Dependencies

### Database and ORM
- **PostgreSQL**: Primary database for persistent storage of test data and configurations
- **Neon Database**: Serverless PostgreSQL hosting solution for cloud deployment
- **Drizzle ORM**: Type-safe database toolkit for schema management and queries
- **connect-pg-simple**: PostgreSQL session store for Express sessions

### Frontend Dependencies
- **React Query**: Server state management and caching
- **Radix UI**: Accessible, unstyled UI primitives for component foundation
- **Tailwind CSS**: Utility-first CSS framework for responsive design
- **Wouter**: Minimal routing library for single-page application navigation
- **React Hook Form**: Form state management with validation
- **date-fns**: Date manipulation and formatting utilities

### Backend Dependencies
- **Express.js**: Web framework for API server implementation
- **Multer**: Middleware for handling multipart/form-data file uploads
- **AdmZip**: Library for ZIP file extraction and processing
- **Axios**: HTTP client for external API communication
- **Zod**: Schema validation for request/response data

### Development and Build Tools
- **Vite**: Build tool and development server with HMR support
- **TypeScript**: Static type checking across the entire codebase
- **esbuild**: Fast JavaScript/TypeScript bundler for production builds
- **PostCSS**: CSS processing with Tailwind CSS integration
- **ESLint**: Code linting and style enforcement

### MarkitWire Integration
The application integrates with MarkitWire APIs for comprehensive security testing, including session management, deal processing, and notification systems. The integration supports various MarkitWire endpoints and provides specialized payload generation for financial API security testing.