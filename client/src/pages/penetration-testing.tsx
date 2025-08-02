import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { useToast } from "@/hooks/use-toast";
import { apiRequest } from "@/lib/queryClient";
import { ApiEndpointTree } from "@/components/api-endpoint-tree";
import { RequestBuilder } from "@/components/request-builder";
import { ResponseViewer } from "@/components/response-viewer";
import { SecurityAnalysis } from "@/components/security-analysis";
import { LibraryManager } from "@/components/library-manager";
import { MarkitWireConnection } from "@/components/markitwire-connection";
import { AdvancedPentest } from "@/components/advanced-pentest";
import { 
  Shield, 
  Download, 
  Settings, 
  Database, 
  Bug, 
  Clock, 
  HelpCircle, 
  Info,
  Rocket,
  History 
} from "lucide-react";
import type { ApiEndpoint, TestSession, ApiRequest } from "@shared/schema";

export default function PenetrationTesting() {
  const [selectedEndpoint, setSelectedEndpoint] = useState<ApiEndpoint | null>(null);
  const [currentSession, setCurrentSession] = useState<TestSession | null>(null);
  const [lastResponse, setLastResponse] = useState<any>(null);
  const [sessionStats, setSessionStats] = useState({
    totalRequests: 0,
    vulnerabilitiesFound: 0,
    sessionDuration: 0
  });
  const [markitWireConnected, setMarkitWireConnected] = useState(false);
  const [connectionSettings, setConnectionSettings] = useState<any>(null);

  const { toast } = useToast();
  const queryClient = useQueryClient();

  // Fetch API endpoints
  const { data: endpoints, isLoading: endpointsLoading } = useQuery({
    queryKey: ["/api/endpoints"],
  });

  // Fetch test sessions
  const { data: sessions } = useQuery({
    queryKey: ["/api/sessions"],
    queryFn: () => apiRequest("GET", "/api/sessions?userId=default"),
  });

  // Fetch library files
  const { data: libraries } = useQuery({
    queryKey: ["/api/libraries"],
  });

  // Create new test session
  const createSessionMutation = useMutation({
    mutationFn: (sessionData: any) => apiRequest("POST", "/api/sessions", sessionData),
    onSuccess: (response) => {
      const session = response.json();
      setCurrentSession(session);
      queryClient.invalidateQueries({ queryKey: ["/api/sessions"] });
      toast({
        title: "Session Created",
        description: "New penetration testing session started",
      });
    },
  });

  // Execute API request
  const executeRequestMutation = useMutation({
    mutationFn: (requestData: any) => apiRequest("POST", "/api/requests/execute", requestData),
    onSuccess: (response) => {
      const result = response.json();
      setLastResponse(result.response);
      setSessionStats(prev => ({
        ...prev,
        totalRequests: prev.totalRequests + 1,
        vulnerabilitiesFound: prev.vulnerabilitiesFound + (result.response.securityFindings?.length || 0)
      }));
      queryClient.invalidateQueries({ queryKey: ["/api/requests"] });
      toast({
        title: "Request Executed",
        description: `Response: ${result.response.status}`,
      });
    },
    onError: (error) => {
      toast({
        title: "Request Failed",
        description: error.message,
        variant: "destructive",
      });
    },
  });

  // Start new session
  const handleNewSession = () => {
    createSessionMutation.mutate({
      userId: "default",
      name: `Pentest Session ${new Date().toISOString()}`,
      status: "active"
    });
  };

  // Session duration timer
  useEffect(() => {
    if (!currentSession) return;

    const timer = setInterval(() => {
      if (currentSession.createdAt) {
        const duration = Math.floor((Date.now() - new Date(currentSession.createdAt).getTime()) / 1000);
        const minutes = Math.floor(duration / 60);
        const seconds = duration % 60;
        setSessionStats(prev => ({
          ...prev,
          sessionDuration: duration
        }));
      }
    }, 1000);

    return () => clearInterval(timer);
  }, [currentSession]);

  const formatDuration = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <div className="min-h-screen bg-slate-900 text-gray-100">
      {/* Header */}
      <header className="bg-slate-800 border-b border-slate-700 px-6 py-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-4">
            <div className="flex items-center space-x-2">
              <Shield className="text-blue-500 h-6 w-6" />
              <h1 className="text-xl font-semibold text-white">MarkitWire API PenTest Suite</h1>
            </div>
            <div className="flex items-center space-x-2 text-sm text-gray-400">
              <div className="w-2 h-2 bg-green-500 rounded-full"></div>
              <span>Connected to UAT Environment</span>
            </div>
          </div>
          <div className="flex items-center space-x-4">
            <Button variant="outline" size="sm" className="bg-blue-600 text-white hover:bg-blue-700">
              <Download className="h-4 w-4 mr-2" />
              Export Session
            </Button>
            <Button variant="outline" size="sm" className="bg-slate-700 text-gray-300 hover:bg-slate-600">
              <Settings className="h-4 w-4 mr-2" />
              Settings
            </Button>
          </div>
        </div>
      </header>

      <div className="flex h-[calc(100vh-73px)]">
        {/* Sidebar */}
        <div className="w-80 bg-slate-800 border-r border-slate-700 flex flex-col">
          {/* Library Manager */}
          <div className="p-4 border-b border-slate-700">
            <LibraryManager libraries={libraries || []} />
          </div>

          {/* API Endpoints */}
          <div className="flex-1 p-4 overflow-y-auto scrollbar-thin">
            <h3 className="text-sm font-semibold text-gray-300 mb-3 flex items-center">
              <Database className="h-4 w-4 mr-2" />
              API Endpoints
            </h3>
            <ApiEndpointTree 
              endpoints={endpoints || []} 
              onEndpointSelect={setSelectedEndpoint}
              selectedEndpoint={selectedEndpoint}
              isLoading={endpointsLoading}
            />
          </div>

          {/* Quick Actions */}
          <div className="p-4 border-t border-slate-700">
            <h3 className="text-sm font-semibold text-gray-300 mb-3">Quick Actions</h3>
            <div className="space-y-2">
              <Button 
                onClick={handleNewSession}
                disabled={createSessionMutation.isPending}
                className="w-full bg-blue-600 text-white hover:bg-blue-700"
              >
                <Rocket className="h-4 w-4 mr-2" />
                New Pentest Session
              </Button>
              <Button variant="outline" className="w-full bg-slate-700 text-gray-300 hover:bg-slate-600">
                <History className="h-4 w-4 mr-2" />
                Load Test History
              </Button>
            </div>
          </div>
        </div>

        {/* Main Content */}
        <div className="flex-1 flex flex-col">
          {/* Tab Navigation */}
          <Tabs defaultValue="markitwire-connection" className="flex-1 flex flex-col">
            <div className="bg-slate-800 border-b border-slate-700">
              <TabsList className="bg-transparent border-none">
                <TabsTrigger 
                  value="markitwire-connection" 
                  className="bg-slate-750 text-white border-b-2 border-blue-500 data-[state=active]:bg-slate-750 data-[state=active]:text-white"
                >
                  <Rocket className="h-4 w-4 mr-2" />
                  MarkitWire API
                </TabsTrigger>
                <TabsTrigger 
                  value="advanced-pentest" 
                  className="text-gray-400 hover:text-white hover:bg-slate-750"
                  disabled={!markitWireConnected}
                >
                  <Shield className="h-4 w-4 mr-2" />
                  Advanced PenTest
                </TabsTrigger>
                <TabsTrigger 
                  value="request-builder" 
                  className="text-gray-400 hover:text-white hover:bg-slate-750"
                >
                  <Settings className="h-4 w-4 mr-2" />
                  Request Builder
                </TabsTrigger>
                <TabsTrigger 
                  value="response-analyzer" 
                  className="text-gray-400 hover:text-white hover:bg-slate-750"
                >
                  <Database className="h-4 w-4 mr-2" />
                  Response Analyzer
                </TabsTrigger>
                <TabsTrigger 
                  value="test-history" 
                  className="text-gray-400 hover:text-white hover:bg-slate-750"
                >
                  <History className="h-4 w-4 mr-2" />
                  Test History
                </TabsTrigger>
              </TabsList>
            </div>

            <TabsContent value="markitwire-connection" className="flex-1 m-0 p-6 overflow-y-auto">
              <MarkitWireConnection 
                onConnectionSuccess={(settings) => {
                  setMarkitWireConnected(true);
                  setConnectionSettings(settings);
                  toast({
                    title: "MarkitWire Connected",
                    description: "Successfully connected to MarkitWire API",
                  });
                }}
              />
            </TabsContent>

            <TabsContent value="advanced-pentest" className="flex-1 m-0 p-6 overflow-y-auto">
              {markitWireConnected && connectionSettings ? (
                <AdvancedPentest connectionSettings={connectionSettings} />
              ) : (
                <Card className="bg-slate-800 border-slate-700">
                  <CardContent className="p-6 text-center">
                    <Shield className="h-16 w-16 mx-auto text-gray-400 mb-4" />
                    <h3 className="text-lg font-semibold mb-2">MarkitWire Connection Required</h3>
                    <p className="text-gray-400 mb-4">
                      Please connect to MarkitWire API first before running advanced penetration tests.
                    </p>
                    <Button onClick={() => window.location.hash = '#markitwire-connection'}>
                      Go to Connection
                    </Button>
                  </CardContent>
                </Card>
              )}
            </TabsContent>

            <TabsContent value="request-builder" className="flex-1 flex m-0">
              <div className="flex-1 flex">
                {/* Request Configuration */}
                <div className="flex-1 p-6 overflow-y-auto scrollbar-thin">
                  <RequestBuilder 
                    selectedEndpoint={selectedEndpoint}
                    onExecuteRequest={(requestData) => {
                      if (!currentSession) {
                        toast({
                          title: "No Active Session",
                          description: "Please start a new penetration testing session first",
                          variant: "destructive",
                        });
                        return;
                      }
                      executeRequestMutation.mutate({
                        ...requestData,
                        sessionId: currentSession.id
                      });
                    }}
                    isExecuting={executeRequestMutation.isPending}
                  />
                </div>

                {/* Response Panel */}
                <div className="w-1/2 border-l border-slate-700 flex flex-col">
                  <ResponseViewer response={lastResponse} />
                  <SecurityAnalysis response={lastResponse} />
                </div>
              </div>
            </TabsContent>

            <TabsContent value="response-analyzer" className="flex-1 m-0 p-6">
              <Card className="bg-slate-800 border-slate-700">
                <CardContent className="p-6">
                  <h3 className="text-lg font-semibold mb-4">Response Analysis Tools</h3>
                  <p className="text-gray-400">Advanced response analysis features coming soon...</p>
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="test-history" className="flex-1 m-0 p-6">
              <Card className="bg-slate-800 border-slate-700">
                <CardContent className="p-6">
                  <h3 className="text-lg font-semibold mb-4">Test History</h3>
                  <p className="text-gray-400">Request/response history will be displayed here...</p>
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>
      </div>

      {/* Bottom Status Bar */}
      <div className="bg-slate-800 border-t border-slate-700 px-6 py-2">
        <div className="flex items-center justify-between text-sm">
          <div className="flex items-center space-x-6">
            <div className="flex items-center space-x-2">
              <Database className="h-4 w-4 text-blue-500" />
              <span className="text-gray-400">Total Requests:</span>
              <span className="text-white font-medium">{sessionStats.totalRequests}</span>
            </div>
            <div className="flex items-center space-x-2">
              <Bug className="h-4 w-4 text-red-500" />
              <span className="text-gray-400">Vulnerabilities Found:</span>
              <span className="text-red-400 font-medium">{sessionStats.vulnerabilitiesFound}</span>
            </div>
            <div className="flex items-center space-x-2">
              <Clock className="h-4 w-4 text-yellow-500" />
              <span className="text-gray-400">Session Duration:</span>
              <span className="text-white font-medium">{formatDuration(sessionStats.sessionDuration)}</span>
            </div>
          </div>
          <div className="flex items-center space-x-4">
            <Button variant="ghost" size="sm" className="text-gray-400 hover:text-white">
              <HelpCircle className="h-4 w-4 mr-1" />
              Help
            </Button>
            <Button variant="ghost" size="sm" className="text-gray-400 hover:text-white">
              <Info className="h-4 w-4 mr-1" />
              About
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
