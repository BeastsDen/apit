import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Copy, Terminal, Clock } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

interface ResponseViewerProps {
  response: any;
}

export function ResponseViewer({ response }: ResponseViewerProps) {
  const [activeTab, setActiveTab] = useState("body");
  const { toast } = useToast();

  const copyToClipboard = () => {
    if (response) {
      navigator.clipboard.writeText(JSON.stringify(response, null, 2));
      toast({
        title: "Copied",
        description: "Response copied to clipboard",
      });
    }
  };

  const getStatusColor = (status: number) => {
    if (status >= 200 && status < 300) return "bg-green-600";
    if (status >= 300 && status < 400) return "bg-yellow-600";
    if (status >= 400 && status < 500) return "bg-orange-600";
    if (status >= 500) return "bg-red-600";
    return "bg-gray-600";
  };

  const formatResponseTime = (time: number) => {
    if (time < 1000) return `${time}ms`;
    return `${(time / 1000).toFixed(2)}s`;
  };

  const highlightJSON = (jsonString: string) => {
    try {
      const obj = JSON.parse(jsonString);
      return JSON.stringify(obj, null, 2)
        .replace(/"([^"]+)":/g, '<span class="json-key">"$1":</span>')
        .replace(/: "([^"]+)"/g, ': <span class="json-string">"$1"</span>')
        .replace(/: (\d+)/g, ': <span class="json-number">$1</span>')
        .replace(/: (true|false)/g, ': <span class="json-boolean">$1</span>');
    } catch {
      return jsonString;
    }
  };

  if (!response) {
    return (
      <div className="w-1/2 border-l border-slate-700 flex flex-col">
        <div className="bg-slate-800 p-4 border-b border-slate-700">
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-semibold flex items-center">
              <Terminal className="h-5 w-5 mr-2 text-green-500" />
              Response
            </h3>
            <div className="text-sm text-gray-400">
              Execute a request to see the response
            </div>
          </div>
        </div>
        <div className="flex-1 flex items-center justify-center text-gray-500">
          <div className="text-center">
            <Terminal className="h-12 w-12 mx-auto mb-4 opacity-50" />
            <p>No response yet</p>
            <p className="text-sm">Send a request to see the response here</p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="w-1/2 border-l border-slate-700 flex flex-col">
      {/* Response Header */}
      <div className="bg-slate-800 p-4 border-b border-slate-700">
        <div className="flex items-center justify-between">
          <h3 className="text-lg font-semibold flex items-center">
            <Terminal className="h-5 w-5 mr-2 text-green-500" />
            Response
          </h3>
          <div className="flex items-center space-x-4">
            <div className="flex items-center space-x-2 text-sm">
              <span className="text-gray-400">Status:</span>
              <Badge className={`text-white text-xs font-medium ${getStatusColor(response.status)}`}>
                {response.status} {getStatusText(response.status)}
              </Badge>
            </div>
            {response.responseTime && (
              <div className="flex items-center space-x-2 text-sm">
                <Clock className="h-4 w-4 text-gray-400" />
                <span className="text-green-400 font-mono">
                  {formatResponseTime(response.responseTime)}
                </span>
              </div>
            )}
            <Button
              variant="outline"
              size="sm"
              onClick={copyToClipboard}
              className="bg-slate-700 text-gray-300 hover:bg-slate-600"
            >
              <Copy className="h-4 w-4 mr-1" />
              Copy
            </Button>
          </div>
        </div>
      </div>

      {/* Response Tabs */}
      <Tabs value={activeTab} onValueChange={setActiveTab} className="flex-1 flex flex-col">
        <div className="bg-slate-850 border-b border-slate-700">
          <TabsList className="bg-transparent border-none">
            <TabsTrigger 
              value="body" 
              className="data-[state=active]:bg-slate-750 data-[state=active]:text-white"
            >
              Body
            </TabsTrigger>
            <TabsTrigger 
              value="headers" 
              className="data-[state=active]:bg-slate-750 data-[state=active]:text-white"
            >
              Headers
            </TabsTrigger>
            <TabsTrigger 
              value="security" 
              className="data-[state=active]:bg-slate-750 data-[state=active]:text-white"
            >
              Security
            </TabsTrigger>
          </TabsList>
        </div>

        {/* Response Content */}
        <div className="flex-1 overflow-hidden">
          <TabsContent value="body" className="h-full m-0">
            <div className="h-full p-4 overflow-y-auto scrollbar-thin">
              <div className="syntax-highlight rounded-lg p-4 font-mono text-sm h-full">
                <pre 
                  className="whitespace-pre-wrap"
                  dangerouslySetInnerHTML={{
                    __html: highlightJSON(JSON.stringify(response.data, null, 2))
                  }}
                />
              </div>
            </div>
          </TabsContent>

          <TabsContent value="headers" className="h-full m-0">
            <div className="h-full p-4 overflow-y-auto scrollbar-thin">
              <div className="space-y-2">
                {response.headers && Object.entries(response.headers).map(([key, value]) => (
                  <div key={key} className="flex items-start space-x-2 p-2 bg-slate-800 rounded">
                    <span className="font-mono text-blue-400 min-w-0 flex-shrink-0">{key}:</span>
                    <span className="font-mono text-gray-300 break-all">{String(value)}</span>
                  </div>
                ))}
                {(!response.headers || Object.keys(response.headers).length === 0) && (
                  <div className="text-center text-gray-500 py-8">
                    No response headers available
                  </div>
                )}
              </div>
            </div>
          </TabsContent>

          <TabsContent value="security" className="h-full m-0">
            <div className="h-full p-4 overflow-y-auto scrollbar-thin">
              <Card className="bg-slate-800 border-slate-700">
                <CardHeader>
                  <CardTitle className="text-sm">Security Analysis Summary</CardTitle>
                </CardHeader>
                <CardContent>
                  {response.securityFindings && response.securityFindings.length > 0 ? (
                    <div className="space-y-3">
                      {response.securityFindings.map((finding: any, index: number) => (
                        <div key={index} className="p-3 bg-slate-750 rounded-lg">
                          <div className="flex items-center justify-between mb-2">
                            <span className="font-medium text-white">{finding.type}</span>
                            <Badge 
                              variant="outline"
                              className={getSeverityColor(finding.severity)}
                            >
                              {finding.severity?.toUpperCase()}
                            </Badge>
                          </div>
                          <p className="text-sm text-gray-300 mb-2">{finding.description}</p>
                          {finding.evidence && (
                            <div className="text-xs text-gray-400 font-mono bg-slate-900 p-2 rounded">
                              {finding.evidence}
                            </div>
                          )}
                        </div>
                      ))}
                    </div>
                  ) : (
                    <div className="text-center text-gray-500 py-8">
                      No security findings detected
                    </div>
                  )}
                </CardContent>
              </Card>
            </div>
          </TabsContent>
        </div>
      </Tabs>
    </div>
  );
}

function getStatusText(status: number): string {
  const statusTexts: Record<number, string> = {
    200: "OK",
    201: "Created",
    400: "Bad Request",
    401: "Unauthorized",
    403: "Forbidden",
    404: "Not Found",
    500: "Internal Server Error",
    502: "Bad Gateway",
    503: "Service Unavailable",
  };
  return statusTexts[status] || "Unknown";
}

function getSeverityColor(severity: string): string {
  switch (severity?.toLowerCase()) {
    case "critical":
      return "border-red-500 text-red-400";
    case "high":
      return "border-orange-500 text-orange-400";
    case "medium":
      return "border-yellow-500 text-yellow-400";
    case "low":
      return "border-blue-500 text-blue-400";
    default:
      return "border-gray-500 text-gray-400";
  }
}
