import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { useQuery } from "@tanstack/react-query";
import { 
  Wrench, 
  Key, 
  List, 
  Code, 
  Bug, 
  Plus, 
  Trash2, 
  Wand2, 
  Play 
} from "lucide-react";
import { cn } from "@/lib/utils";
import type { ApiEndpoint } from "@shared/schema";
import { apiRequest } from "@/lib/queryClient";

interface RequestBuilderProps {
  selectedEndpoint: ApiEndpoint | null;
  onExecuteRequest: (requestData: any) => void;
  isExecuting: boolean;
}

interface SecurityOptions {
  sqlInjection: boolean;
  parameterFuzzing: boolean;
  authBypass: boolean;
  rateLimitTesting: boolean;
  dataExposureAnalysis: boolean;
  sessionManagement: boolean;
}

interface Header {
  key: string;
  value: string;
}

const httpMethods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS', 'HEAD'];

export function RequestBuilder({ selectedEndpoint, onExecuteRequest, isExecuting }: RequestBuilderProps) {
  const [method, setMethod] = useState('GET');
  const [url, setUrl] = useState('');
  const [headers, setHeaders] = useState<Header[]>([
    { key: 'Content-Type', value: 'application/json' },
    { key: 'Authorization', value: 'Bearer token...' }
  ]);
  const [body, setBody] = useState('');
  const [bodyType, setBodyType] = useState('JSON');
  const [credentials, setCredentials] = useState({
    username: '',
    password: '',
    sessionHandle: ''
  });
  const [securityOptions, setSecurityOptions] = useState<SecurityOptions>({
    sqlInjection: false,
    parameterFuzzing: false,
    authBypass: false,
    rateLimitTesting: false,
    dataExposureAnalysis: true,
    sessionManagement: false
  });
  const [selectedPayloadTemplate, setSelectedPayloadTemplate] = useState('');

  // Load payload templates
  const { data: payloadTemplates } = useQuery({
    queryKey: ["/api/payloads", selectedPayloadTemplate],
    enabled: !!selectedPayloadTemplate,
  });

  // Update form when endpoint changes
  useEffect(() => {
    if (selectedEndpoint) {
      setMethod(selectedEndpoint.method);
      setUrl(selectedEndpoint.url);
      
      // Set default body based on endpoint
      if (selectedEndpoint.parameters) {
        const defaultBody = {
          server: "mw.uat.api.markit.com",
          timeout: 120,
          credentials: {
            username: credentials.username || "testuser",
            password: credentials.password || "testpass"
          },
          parameters: selectedEndpoint.parameters
        };
        setBody(JSON.stringify(defaultBody, null, 2));
      }
    }
  }, [selectedEndpoint]);

  const addHeader = () => {
    setHeaders([...headers, { key: '', value: '' }]);
  };

  const updateHeader = (index: number, field: 'key' | 'value', value: string) => {
    const updated = [...headers];
    updated[index][field] = value;
    setHeaders(updated);
  };

  const removeHeader = (index: number) => {
    setHeaders(headers.filter((_, i) => i !== index));
  };

  const formatJSON = () => {
    try {
      const parsed = JSON.parse(body);
      setBody(JSON.stringify(parsed, null, 2));
    } catch (error) {
      // Invalid JSON, keep as is
    }
  };

  const handleMethodSelect = (selectedMethod: string) => {
    setMethod(selectedMethod);
  };

  const handleSecurityOptionChange = (option: keyof SecurityOptions, checked: boolean) => {
    setSecurityOptions(prev => ({
      ...prev,
      [option]: checked
    }));
  };

  const handleExecuteRequest = () => {
    // Prepare headers object
    const headersObj = headers.reduce((acc, header) => {
      if (header.key && header.value) {
        acc[header.key] = header.value;
      }
      return acc;
    }, {} as Record<string, string>);

    // Prepare request body
    let requestBody = body;
    if (bodyType === 'JSON' && body) {
      try {
        requestBody = JSON.parse(body);
      } catch (error) {
        // Keep as string if JSON parsing fails
      }
    }

    const requestData = {
      endpointId: selectedEndpoint?.id,
      method,
      url,
      headers: headersObj,
      body: requestBody,
      securityOptions
    };

    onExecuteRequest(requestData);
  };

  const loadPayloadTemplate = () => {
    if (payloadTemplates?.payloads?.length > 0) {
      const payload = payloadTemplates.payloads[0];
      if (bodyType === 'JSON') {
        try {
          const currentBody = JSON.parse(body || '{}');
          currentBody.testPayload = payload;
          setBody(JSON.stringify(currentBody, null, 2));
        } catch {
          setBody(JSON.stringify({ testPayload: payload }, null, 2));
        }
      } else {
        setBody(payload);
      }
    }
  };

  return (
    <div className="space-y-6">
      {/* Request Configuration */}
      <Card className="bg-slate-800 border-slate-700">
        <CardHeader className="pb-4">
          <CardTitle className="flex items-center text-lg">
            <Wrench className="h-5 w-5 mr-2 text-blue-500" />
            Request Configuration
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          {/* Method Selection */}
          <div>
            <Label className="text-gray-300 mb-2 block">HTTP Method</Label>
            <div className="flex space-x-2">
              {httpMethods.map((httpMethod) => (
                <Button
                  key={httpMethod}
                  variant={method === httpMethod ? "default" : "outline"}
                  size="sm"
                  onClick={() => handleMethodSelect(httpMethod)}
                  className={cn(
                    "font-medium",
                    method === httpMethod 
                      ? "bg-green-600 text-white hover:bg-green-700" 
                      : "bg-slate-700 text-gray-300 hover:bg-slate-600"
                  )}
                >
                  {httpMethod}
                </Button>
              ))}
            </div>
          </div>

          {/* URL Input */}
          <div>
            <Label className="text-gray-300 mb-2 block">API Endpoint</Label>
            <div className="flex">
              <Input
                value={url}
                onChange={(e) => setUrl(e.target.value)}
                placeholder="https://mw.uat.api.markit.com/v1/..."
                className="flex-1 bg-slate-900 border-slate-600 text-gray-100 font-mono text-sm focus:border-blue-500"
              />
              <Button 
                onClick={handleExecuteRequest}
                disabled={isExecuting || !url}
                className="ml-2 bg-blue-600 text-white hover:bg-blue-700"
              >
                {isExecuting ? (
                  <div className="animate-spin h-4 w-4 border-2 border-white border-t-transparent rounded-full" />
                ) : (
                  <Play className="h-4 w-4" />
                )}
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Authentication */}
      <Card className="bg-slate-800 border-slate-700">
        <CardHeader className="pb-4">
          <CardTitle className="flex items-center text-lg">
            <Key className="h-5 w-5 mr-2 text-yellow-500" />
            Authentication
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label className="text-gray-300 mb-2 block">Username</Label>
              <Input
                value={credentials.username}
                onChange={(e) => setCredentials(prev => ({ ...prev, username: e.target.value }))}
                placeholder="Enter username"
                className="bg-slate-900 border-slate-600 text-gray-100 focus:border-blue-500"
              />
            </div>
            <div>
              <Label className="text-gray-300 mb-2 block">Password</Label>
              <Input
                type="password"
                value={credentials.password}
                onChange={(e) => setCredentials(prev => ({ ...prev, password: e.target.value }))}
                placeholder="Enter password"
                className="bg-slate-900 border-slate-600 text-gray-100 focus:border-blue-500"
              />
            </div>
          </div>

          <div>
            <Label className="text-gray-300 mb-2 block">Session Handle</Label>
            <Input
              value={credentials.sessionHandle}
              onChange={(e) => setCredentials(prev => ({ ...prev, sessionHandle: e.target.value }))}
              placeholder="Auto-generated after connection"
              className="bg-slate-900 border-slate-600 text-gray-100 font-mono focus:border-blue-500"
              readOnly
            />
          </div>
        </CardContent>
      </Card>

      {/* Headers */}
      <Card className="bg-slate-800 border-slate-700">
        <CardHeader className="pb-4">
          <div className="flex items-center justify-between">
            <CardTitle className="flex items-center text-lg">
              <List className="h-5 w-5 mr-2 text-purple-500" />
              Headers
            </CardTitle>
            <Button onClick={addHeader} size="sm" className="bg-blue-600 text-white hover:bg-blue-700">
              <Plus className="h-4 w-4 mr-1" />
              Add Header
            </Button>
          </div>
        </CardHeader>
        <CardContent className="space-y-2">
          {headers.map((header, index) => (
            <div key={index} className="grid grid-cols-5 gap-2 items-center">
              <Input
                value={header.key}
                onChange={(e) => updateHeader(index, 'key', e.target.value)}
                placeholder="Header name"
                className="col-span-2 bg-slate-900 border-slate-600 text-gray-100 focus:border-blue-500"
              />
              <Input
                value={header.value}
                onChange={(e) => updateHeader(index, 'value', e.target.value)}
                placeholder="Header value"
                className="col-span-2 bg-slate-900 border-slate-600 text-gray-100 focus:border-blue-500"
              />
              <Button
                variant="ghost"
                size="sm"
                onClick={() => removeHeader(index)}
                className="text-red-400 hover:text-red-300 hover:bg-slate-700"
              >
                <Trash2 className="h-4 w-4" />
              </Button>
            </div>
          ))}
        </CardContent>
      </Card>

      {/* Request Body */}
      <Card className="bg-slate-800 border-slate-700">
        <CardHeader className="pb-4">
          <div className="flex items-center justify-between">
            <CardTitle className="flex items-center text-lg">
              <Code className="h-5 w-5 mr-2 text-green-500" />
              Request Body
            </CardTitle>
            <div className="flex space-x-2">
              <Select value={bodyType} onValueChange={setBodyType}>
                <SelectTrigger className="w-32 bg-slate-700 text-gray-300 border-slate-600">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="JSON">JSON</SelectItem>
                  <SelectItem value="XML">XML</SelectItem>
                  <SelectItem value="Form Data">Form Data</SelectItem>
                  <SelectItem value="Raw">Raw</SelectItem>
                </SelectContent>
              </Select>
              <Button onClick={formatJSON} size="sm" className="bg-blue-600 text-white hover:bg-blue-700">
                <Wand2 className="h-4 w-4 mr-1" />
                Format
              </Button>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <Textarea
            value={body}
            onChange={(e) => setBody(e.target.value)}
            placeholder="Enter request body..."
            className="h-48 bg-slate-900 border-slate-600 text-gray-100 font-mono text-sm focus:border-blue-500 resize-none"
          />
        </CardContent>
      </Card>

      {/* Penetration Testing Options */}
      <Card className="bg-slate-800 border-slate-700">
        <CardHeader className="pb-4">
          <CardTitle className="flex items-center text-lg">
            <Bug className="h-5 w-5 mr-2 text-red-500" />
            Penetration Testing Options
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-3">
              {Object.entries({
                sqlInjection: "SQL Injection Testing",
                parameterFuzzing: "Parameter Fuzzing",
                authBypass: "Authentication Bypass"
              }).map(([key, label]) => (
                <div key={key} className="flex items-center space-x-2">
                  <Checkbox
                    id={key}
                    checked={securityOptions[key as keyof SecurityOptions]}
                    onCheckedChange={(checked) => 
                      handleSecurityOptionChange(key as keyof SecurityOptions, !!checked)
                    }
                    className="border-slate-600"
                  />
                  <Label htmlFor={key} className="text-sm text-gray-300 cursor-pointer">
                    {label}
                  </Label>
                </div>
              ))}
            </div>
            <div className="space-y-3">
              {Object.entries({
                rateLimitTesting: "Rate Limit Testing",
                dataExposureAnalysis: "Data Exposure Analysis",
                sessionManagement: "Session Management"
              }).map(([key, label]) => (
                <div key={key} className="flex items-center space-x-2">
                  <Checkbox
                    id={key}
                    checked={securityOptions[key as keyof SecurityOptions]}
                    onCheckedChange={(checked) => 
                      handleSecurityOptionChange(key as keyof SecurityOptions, !!checked)
                    }
                    className="border-slate-600"
                  />
                  <Label htmlFor={key} className="text-sm text-gray-300 cursor-pointer">
                    {label}
                  </Label>
                </div>
              ))}
            </div>
          </div>

          <Separator className="bg-slate-700" />

          <div>
            <Label className="text-gray-300 mb-2 block">Custom Payload Templates</Label>
            <div className="flex space-x-2">
              <Select value={selectedPayloadTemplate} onValueChange={setSelectedPayloadTemplate}>
                <SelectTrigger className="flex-1 bg-slate-900 border-slate-600 text-gray-100">
                  <SelectValue placeholder="Select a payload template..." />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="sql-injection">OWASP Top 10 - Injection</SelectItem>
                  <SelectItem value="authentication-bypass">Authorization Bypass</SelectItem>
                  <SelectItem value="buffer-overflow">Buffer Overflow</SelectItem>
                  <SelectItem value="xss">Cross-Site Scripting (XSS)</SelectItem>
                  <SelectItem value="parameter-pollution">Parameter Pollution</SelectItem>
                </SelectContent>
              </Select>
              <Button 
                onClick={loadPayloadTemplate}
                disabled={!selectedPayloadTemplate}
                size="sm" 
                className="bg-orange-600 text-white hover:bg-orange-700"
              >
                Load Template
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
