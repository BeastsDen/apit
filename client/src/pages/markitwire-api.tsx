import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Code, Play, Settings, Copy, CheckCircle, XCircle, Info } from "lucide-react";
import { useToast } from "@/hooks/use-toast";
import { Alert, AlertDescription } from "@/components/ui/alert";

interface MarkitWireApiEndpoint {
  name: string;
  category: string;
  functionName: string;
  description: string;
  parameters?: Array<{
    name: string;
    type: string;
    description: string;
    required: boolean;
    example?: any;
  }>;
  sampleCode?: string;
  isActive: boolean;
}

interface ConnectionSettings {
  host: string;
  username: string;
  password: string;
  apiType: 'dealer' | 'dealsink';
}

export default function MarkitWireApiPage() {
  const [selectedEndpoint, setSelectedEndpoint] = useState<MarkitWireApiEndpoint | null>(null);
  const [connectionSettings, setConnectionSettings] = useState<ConnectionSettings>({
    host: 'training.swapswire.com:9009',
    username: '',
    password: '',
    apiType: 'dealer'
  });
  const [parameters, setParameters] = useState<Record<string, any>>({});
  const [javaCode, setJavaCode] = useState<string>('');
  const { toast } = useToast();
  const queryClient = useQueryClient();

  // Fetch available API endpoints
  const { data: endpoints = [], isLoading: loadingEndpoints } = useQuery({
    queryKey: ['/api/endpoints'],
    select: (data: MarkitWireApiEndpoint[]) => data
  });

  // Generate Java code for selected endpoint
  const { data: codeData, refetch: regenerateCode } = useQuery({
    queryKey: ['/api/markitwire/java-code', selectedEndpoint?.functionName],
    enabled: !!selectedEndpoint,
    queryFn: async () => {
      if (!selectedEndpoint) return null;
      const response = await fetch(`/api/markitwire/java-code/${selectedEndpoint.functionName}?apiType=${connectionSettings.apiType}&host=${connectionSettings.host}&username=${connectionSettings.username}&password=${connectionSettings.password}`);
      return response.json();
    }
  });

  // Execute API call
  const executeApiMutation = useMutation({
    mutationFn: async () => {
      const response = await fetch('/api/markitwire/execute', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          functionName: selectedEndpoint?.functionName,
          host: connectionSettings.host,
          username: connectionSettings.username,
          password: connectionSettings.password,
          parameters: Object.values(parameters),
          apiType: connectionSettings.apiType
        })
      });
      if (!response.ok) throw new Error('API call failed');
      return response.json();
    },
    onSuccess: (data) => {
      toast({
        title: "API Call Successful",
        description: `${selectedEndpoint?.functionName} executed successfully`
      });
    },
    onError: (error) => {
      toast({
        title: "API Call Failed",
        description: error instanceof Error ? error.message : "Unknown error",
        variant: "destructive"
      });
    }
  });

  // Test connection
  const testConnectionMutation = useMutation({
    mutationFn: async () => {
      const response = await fetch('/api/markitwire/test-connection', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          host: connectionSettings.host,
          username: connectionSettings.username,
          password: connectionSettings.password
        })
      });
      return response.json();
    },
    onSuccess: (data) => {
      toast({
        title: data.success ? "Connection Successful" : "Connection Failed",
        description: data.message,
        variant: data.success ? "default" : "destructive"
      });
    }
  });

  // Update parameters when endpoint changes
  useEffect(() => {
    if (selectedEndpoint) {
      const newParams: Record<string, any> = {};
      selectedEndpoint.parameters?.forEach(param => {
        newParams[param.name] = param.example || '';
      });
      setParameters(newParams);
    }
  }, [selectedEndpoint]);

  // Update Java code when code data changes
  useEffect(() => {
    if (codeData?.javaCode) {
      setJavaCode(codeData.javaCode);
    }
  }, [codeData]);

  const groupedEndpoints = endpoints.reduce((acc, endpoint) => {
    if (!acc[endpoint.category]) {
      acc[endpoint.category] = [];
    }
    acc[endpoint.category].push(endpoint);
    return acc;
  }, {} as Record<string, MarkitWireApiEndpoint[]>);

  const copyJavaCode = () => {
    navigator.clipboard.writeText(javaCode);
    toast({
      title: "Code Copied",
      description: "Java code copied to clipboard"
    });
  };

  return (
    <div className="container mx-auto p-6 space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold">MarkitWire API Interface</h1>
          <p className="text-muted-foreground">
            Execute MarkitWire API calls using the extracted Java libraries
          </p>
        </div>
      </div>

      <Alert>
        <Info className="h-4 w-4" />
        <AlertDescription>
          <strong>Real API Mode:</strong> This interface uses the actual MarkitWire Linux native libraries 
          to make real API calls. Connection testing shows that `mw.uat.api.markit.com` is reachable 
          but may have SSL certificate issues in this environment. Use proper HTTPS URLs like 
          `https://mw.uat.api.markit.com` for better compatibility.
        </AlertDescription>
      </Alert>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Connection Settings */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Settings className="h-5 w-5" />
              Connection Settings
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <Label htmlFor="host">Host</Label>
              <Input
                id="host"
                value={connectionSettings.host}
                onChange={(e) => setConnectionSettings(prev => ({ ...prev, host: e.target.value }))}
                placeholder="https://mw.uat.api.markit.com"
              />
            </div>
            <div>
              <Label htmlFor="username">Username</Label>
              <Input
                id="username"
                value={connectionSettings.username}
                onChange={(e) => setConnectionSettings(prev => ({ ...prev, username: e.target.value }))}
                placeholder="Your MarkitWire username"
              />
            </div>
            <div>
              <Label htmlFor="password">Password</Label>
              <Input
                id="password"
                type="password"
                value={connectionSettings.password}
                onChange={(e) => setConnectionSettings(prev => ({ ...prev, password: e.target.value }))}
                placeholder="Your MarkitWire password"
              />
            </div>
            <div>
              <Label htmlFor="apiType">API Type</Label>
              <Select 
                value={connectionSettings.apiType} 
                onValueChange={(value) => setConnectionSettings(prev => ({ ...prev, apiType: value as 'dealer' | 'dealsink' }))}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="dealer">Dealer API</SelectItem>
                  <SelectItem value="dealsink">DealSink API</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <Button 
              onClick={() => testConnectionMutation.mutate()}
              disabled={testConnectionMutation.isPending}
              className="w-full"
            >
              Test Connection
            </Button>
          </CardContent>
        </Card>

        {/* API Endpoints List */}
        <Card>
          <CardHeader>
            <CardTitle>Available API Functions</CardTitle>
            <CardDescription>
              Select a MarkitWire API function to execute
            </CardDescription>
          </CardHeader>
          <CardContent>
            <ScrollArea className="h-[600px]">
              {Object.entries(groupedEndpoints).map(([category, categoryEndpoints]) => (
                <div key={category} className="mb-4">
                  <h3 className="font-semibold text-sm mb-2">{category}</h3>
                  <div className="space-y-2">
                    {categoryEndpoints.map((endpoint) => (
                      <Button
                        key={endpoint.functionName}
                        variant={selectedEndpoint?.functionName === endpoint.functionName ? "default" : "outline"}
                        className="w-full justify-start text-left h-auto p-3"
                        onClick={() => setSelectedEndpoint(endpoint)}
                      >
                        <div>
                          <div className="font-medium">{endpoint.name}</div>
                          <div className="text-xs text-muted-foreground mt-1">
                            {endpoint.description}
                          </div>
                        </div>
                      </Button>
                    ))}
                  </div>
                  <Separator className="mt-4" />
                </div>
              ))}
            </ScrollArea>
          </CardContent>
        </Card>

        {/* API Call Configuration */}
        <Card>
          <CardHeader>
            <CardTitle>
              {selectedEndpoint ? selectedEndpoint.name : "Select an API Function"}
            </CardTitle>
            {selectedEndpoint && (
              <CardDescription>{selectedEndpoint.description}</CardDescription>
            )}
          </CardHeader>
          <CardContent>
            {selectedEndpoint ? (
              <Tabs defaultValue="parameters" className="w-full">
                <TabsList className="grid w-full grid-cols-3">
                  <TabsTrigger value="parameters">Parameters</TabsTrigger>
                  <TabsTrigger value="code">Java Code</TabsTrigger>
                  <TabsTrigger value="response">Response</TabsTrigger>
                </TabsList>

                <TabsContent value="parameters" className="space-y-4">
                  {selectedEndpoint.parameters && selectedEndpoint.parameters.length > 0 ? (
                    <>
                      {selectedEndpoint.parameters.map((param) => (
                        <div key={param.name}>
                          <Label htmlFor={param.name}>
                            {param.name}
                            {param.required && <span className="text-red-500">*</span>}
                          </Label>
                          <Input
                            id={param.name}
                            value={parameters[param.name] || ''}
                            onChange={(e) => setParameters(prev => ({ ...prev, [param.name]: e.target.value }))}
                            placeholder={param.example || param.description}
                          />
                          <p className="text-xs text-muted-foreground mt-1">
                            {param.description} ({param.type})
                          </p>
                        </div>
                      ))}
                      <Button 
                        onClick={() => executeApiMutation.mutate()}
                        disabled={executeApiMutation.isPending}
                        className="w-full"
                      >
                        <Play className="h-4 w-4 mr-2" />
                        Execute API Call
                      </Button>
                    </>
                  ) : (
                    <p className="text-muted-foreground">No parameters required for this function</p>
                  )}
                </TabsContent>

                <TabsContent value="code" className="space-y-4">
                  <div className="flex items-center justify-between">
                    <Label>Generated Java Code</Label>
                    <Button size="sm" variant="outline" onClick={copyJavaCode}>
                      <Copy className="h-4 w-4 mr-2" />
                      Copy
                    </Button>
                  </div>
                  <Textarea
                    value={javaCode}
                    onChange={(e) => setJavaCode(e.target.value)}
                    className="font-mono text-sm min-h-[400px]"
                    placeholder="Java code will appear here..."
                  />
                  <Button 
                    onClick={() => regenerateCode()}
                    variant="outline"
                    size="sm"
                  >
                    <Code className="h-4 w-4 mr-2" />
                    Regenerate Code
                  </Button>
                </TabsContent>

                <TabsContent value="response" className="space-y-4">
                  {executeApiMutation.data ? (
                    <div className="space-y-4">
                      <div className="flex items-center gap-2">
                        {executeApiMutation.data.success ? (
                          <CheckCircle className="h-5 w-5 text-green-500" />
                        ) : (
                          <XCircle className="h-5 w-5 text-red-500" />
                        )}
                        <span className="font-medium">
                          {executeApiMutation.data.success ? "Success" : "Error"}
                        </span>
                        {executeApiMutation.data.executionTime && (
                          <Badge variant="secondary">
                            {executeApiMutation.data.executionTime}ms
                          </Badge>
                        )}
                      </div>
                      
                      {executeApiMutation.data.data && (
                        <div>
                          <Label>Response Data</Label>
                          <Textarea
                            value={JSON.stringify(executeApiMutation.data.data, null, 2)}
                            readOnly
                            className="font-mono text-sm min-h-[200px]"
                          />
                        </div>
                      )}
                      
                      {executeApiMutation.data.javaOutput && (
                        <div>
                          <Label>Java Output</Label>
                          <Textarea
                            value={executeApiMutation.data.javaOutput}
                            readOnly
                            className="font-mono text-sm min-h-[150px]"
                          />
                        </div>
                      )}
                      
                      {executeApiMutation.data.error && (
                        <div>
                          <Label>Error Details</Label>
                          <Textarea
                            value={executeApiMutation.data.error}
                            readOnly
                            className="font-mono text-sm text-red-600"
                          />
                        </div>
                      )}
                    </div>
                  ) : (
                    <p className="text-muted-foreground">
                      Execute an API call to see the response here
                    </p>
                  )}
                </TabsContent>
              </Tabs>
            ) : (
              <p className="text-muted-foreground">
                Select an API function from the list to configure and execute it
              </p>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}