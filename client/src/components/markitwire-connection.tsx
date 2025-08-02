import { useState } from "react";
import { useMutation, useQuery } from "@tanstack/react-query";
import { apiRequest } from "@/lib/queryClient";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Textarea } from "@/components/ui/textarea";
import { Separator } from "@/components/ui/separator";
import { CheckCircle, XCircle, Loader2, Terminal, Shield, Info } from "lucide-react";

interface ConnectionSettings {
  host: string;
  username: string;
  password: string;
}

interface MarkitWireConnectionProps {
  onConnectionSuccess?: (settings: ConnectionSettings) => void;
}

export function MarkitWireConnection({ onConnectionSuccess }: MarkitWireConnectionProps) {
  const [connectionSettings, setConnectionSettings] = useState<ConnectionSettings>({
    host: "training.swapswire.com:9009",
    username: "",
    password: ""
  });

  const [selectedCommand, setSelectedCommand] = useState("");
  const [commandParams, setCommandParams] = useState<string[]>([]);
  const [newParam, setNewParam] = useState("");

  // Test connection mutation
  const connectionMutation = useMutation({
    mutationFn: async (settings: ConnectionSettings) => {
      const response = await apiRequest("/api/markitwire/connect", {
        method: "POST",
        body: settings
      });
      return response;
    },
    onSuccess: (data: any) => {
      if (data?.success && onConnectionSuccess) {
        onConnectionSuccess(connectionSettings);
      }
    }
  });

  // Execute command mutation
  const commandMutation = useMutation({
    mutationFn: async (payload: any) => {
      const response = await apiRequest("/api/markitwire/execute", {
        method: "POST",
        body: payload
      });
      return response;
    }
  });

  // Get available commands
  const { data: commandsData } = useQuery({
    queryKey: ["/api/markitwire/commands"],
    enabled: connectionMutation.isSuccess && connectionMutation.data?.success
  });

  // Get API info
  const { data: apiInfo } = useQuery({
    queryKey: ["/api/markitwire/info"]
  });

  const handleConnect = () => {
    connectionMutation.mutate(connectionSettings);
  };

  const handleExecuteCommand = () => {
    if (!selectedCommand) return;

    commandMutation.mutate({
      ...connectionSettings,
      command: selectedCommand,
      params: commandParams,
      apiType: "dealer"
    });
  };

  const addParameter = () => {
    if (newParam.trim()) {
      setCommandParams([...commandParams, newParam.trim()]);
      setNewParam("");
    }
  };

  const removeParameter = (index: number) => {
    setCommandParams(commandParams.filter((_, i) => i !== index));
  };

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Terminal className="h-5 w-5" />
            MarkitWire API Connection
          </CardTitle>
          <CardDescription>
            Connect to MarkitWire APIs using the native Java libraries for comprehensive security testing
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="space-y-2">
              <Label htmlFor="host">Host</Label>
              <Input
                id="host"
                value={connectionSettings.host}
                onChange={(e) => setConnectionSettings(prev => ({ ...prev, host: e.target.value }))}
                placeholder="training.swapswire.com:9009"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="username">Username</Label>
              <Input
                id="username"
                value={connectionSettings.username}
                onChange={(e) => setConnectionSettings(prev => ({ ...prev, username: e.target.value }))}
                placeholder="Your username"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password">Password</Label>
              <Input
                id="password"
                type="password"
                value={connectionSettings.password}
                onChange={(e) => setConnectionSettings(prev => ({ ...prev, password: e.target.value }))}
                placeholder="Your password"
              />
            </div>
          </div>

          <Button 
            onClick={handleConnect} 
            disabled={!connectionSettings.host || !connectionSettings.username || !connectionSettings.password || connectionMutation.isPending}
            className="w-full"
          >
            {connectionMutation.isPending ? (
              <>
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                Testing Connection...
              </>
            ) : (
              "Test Connection"
            )}
          </Button>

          {connectionMutation.data && (
            <Alert className={(connectionMutation.data as any)?.success ? "border-green-500" : "border-red-500"}>
              <div className="flex items-center gap-2">
                {(connectionMutation.data as any)?.success ? (
                  <CheckCircle className="h-4 w-4 text-green-500" />
                ) : (
                  <XCircle className="h-4 w-4 text-red-500" />
                )}
                <AlertDescription>
                  {(connectionMutation.data as any)?.message || 'Connection test completed'}
                </AlertDescription>
              </div>
            </Alert>
          )}
        </CardContent>
      </Card>

      {apiInfo && (
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Info className="h-5 w-5" />
              API Information
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <Label className="text-sm font-medium">Version</Label>
                <p className="text-sm text-muted-foreground">{(apiInfo as any)?.version || 'Unknown'}</p>
              </div>
              <div>
                <Label className="text-sm font-medium">Available Commands</Label>
                <p className="text-sm text-muted-foreground">
                  {(apiInfo as any)?.availableCommands?.length || 0} commands loaded
                </p>
              </div>
            </div>
            <div>
              <Label className="text-sm font-medium">Supported Features</Label>
              <div className="flex flex-wrap gap-2 mt-2">
                {((apiInfo as any)?.supportedFeatures || []).map((feature: string, index: number) => (
                  <Badge key={index} variant="secondary">
                    {feature}
                  </Badge>
                ))}
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      {connectionMutation.isSuccess && (connectionMutation.data as any)?.success && (
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Shield className="h-5 w-5" />
              Command Execution
            </CardTitle>
            <CardDescription>
              Execute MarkitWire API commands for security testing
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <Tabs defaultValue="basic" className="w-full">
              <TabsList className="grid w-full grid-cols-2">
                <TabsTrigger value="basic">Basic Commands</TabsTrigger>
                <TabsTrigger value="advanced">Advanced Testing</TabsTrigger>
              </TabsList>

              <TabsContent value="basic" className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="command">Select Command</Label>
                  <Select value={selectedCommand} onValueChange={setSelectedCommand}>
                    <SelectTrigger>
                      <SelectValue placeholder="Select a command to execute" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="GetUserInfoCmd">Get User Info</SelectItem>
                      <SelectItem value="GetBookListCmd">Get Book List</SelectItem>
                      <SelectItem value="GetLegalEntityListCmd">Get Legal Entity List</SelectItem>
                      <SelectItem value="GetParticipantsCmd">Get Participants</SelectItem>
                      <SelectItem value="QueryDealsCmd">Query Deals</SelectItem>
                      <SelectItem value="InfiniteLoopCmd">Infinite Loop (Testing)</SelectItem>
                      {((commandsData as any)?.commands || []).map((cmd: string) => (
                        <SelectItem key={cmd} value={cmd}>
                          {cmd}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-2">
                  <Label>Command Parameters</Label>
                  <div className="flex gap-2">
                    <Input
                      value={newParam}
                      onChange={(e) => setNewParam(e.target.value)}
                      placeholder="Add parameter"
                      onKeyPress={(e) => e.key === 'Enter' && addParameter()}
                    />
                    <Button onClick={addParameter} variant="outline">
                      Add
                    </Button>
                  </div>
                  {commandParams.length > 0 && (
                    <div className="flex flex-wrap gap-2 mt-2">
                      {commandParams.map((param, index) => (
                        <Badge key={index} variant="outline" className="cursor-pointer" onClick={() => removeParameter(index)}>
                          {param} ×
                        </Badge>
                      ))}
                    </div>
                  )}
                </div>

                <Button 
                  onClick={handleExecuteCommand} 
                  disabled={!selectedCommand || commandMutation.isPending}
                  className="w-full"
                >
                  {commandMutation.isPending ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      Executing...
                    </>
                  ) : (
                    "Execute Command"
                  )}
                </Button>
              </TabsContent>

              <TabsContent value="advanced" className="space-y-4">
                <Alert>
                  <Shield className="h-4 w-4" />
                  <AlertDescription>
                    Advanced penetration testing features will be available here, including payload injection, 
                    vulnerability scanning, and automated security analysis.
                  </AlertDescription>
                </Alert>
              </TabsContent>
            </Tabs>

            {commandMutation.data && (
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    Command Results
                    <Badge variant={(commandMutation.data as any)?.success ? "default" : "destructive"}>
                      {(commandMutation.data as any)?.success ? "Success" : "Error"}
                    </Badge>
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    {(commandMutation.data as any)?.stdout && (
                      <div>
                        <Label className="text-sm font-medium">Output</Label>
                        <Textarea
                          value={(commandMutation.data as any).stdout}
                          readOnly
                          className="mt-2 font-mono text-sm"
                          rows={6}
                        />
                      </div>
                    )}
                    {(commandMutation.data as any)?.stderr && (
                      <div>
                        <Label className="text-sm font-medium text-red-600">Error Output</Label>
                        <Textarea
                          value={(commandMutation.data as any).stderr}
                          readOnly
                          className="mt-2 font-mono text-sm border-red-200"
                          rows={4}
                        />
                      </div>
                    )}
                  </div>
                </CardContent>
              </Card>
            )}
          </CardContent>
        </Card>
      )}
    </div>
  );
}