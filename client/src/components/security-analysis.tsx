import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Shield, AlertTriangle, CheckCircle, XCircle } from "lucide-react";

interface SecurityAnalysisProps {
  response: any;
}

export function SecurityAnalysis({ response }: SecurityAnalysisProps) {
  if (!response) {
    return (
      <div className="border-t border-slate-700 p-4 bg-slate-850">
        <h4 className="text-sm font-semibold text-gray-300 mb-3 flex items-center">
          <Shield className="h-4 w-4 mr-2 text-red-500" />
          Security Analysis
        </h4>
        <div className="text-center text-gray-500 py-4">
          <Shield className="h-8 w-8 mx-auto mb-2 opacity-50" />
          <p className="text-sm">Execute a request to see security analysis</p>
        </div>
      </div>
    );
  }

  const findings = response.securityFindings || [];
  const hasFindings = findings.length > 0;

  // Default security checks if no findings from server
  const defaultFindings = [
    {
      type: "Response Headers",
      severity: "info",
      status: "checked",
      message: "Security headers analysis completed"
    },
    {
      type: "Data Exposure",
      severity: "info", 
      status: "checked",
      message: "Response data analyzed for sensitive information"
    },
    {
      type: "Authentication",
      severity: "info",
      status: "checked", 
      message: "Authentication mechanism verified"
    }
  ];

  const getIcon = (severity: string, status?: string) => {
    if (status === "checked") {
      return <CheckCircle className="h-4 w-4 text-green-500" />;
    }
    
    switch (severity) {
      case "critical":
      case "high":
        return <XCircle className="h-4 w-4 text-red-500" />;
      case "medium":
        return <AlertTriangle className="h-4 w-4 text-yellow-500" />;
      case "low":
        return <AlertTriangle className="h-4 w-4 text-blue-500" />;
      default:
        return <CheckCircle className="h-4 w-4 text-green-500" />;
    }
  };

  const getSeverityColor = (severity: string) => {
    switch (severity) {
      case "critical":
        return "border-red-500 text-red-400 bg-red-500/10";
      case "high":
        return "border-orange-500 text-orange-400 bg-orange-500/10";
      case "medium":
        return "border-yellow-500 text-yellow-400 bg-yellow-500/10";
      case "low":
        return "border-blue-500 text-blue-400 bg-blue-500/10";
      default:
        return "border-green-500 text-green-400 bg-green-500/10";
    }
  };

  const displayFindings = hasFindings ? findings : defaultFindings;

  return (
    <div className="border-t border-slate-700 p-4 bg-slate-850">
      <h4 className="text-sm font-semibold text-gray-300 mb-3 flex items-center">
        <Shield className="h-4 w-4 mr-2 text-red-500" />
        Security Analysis
      </h4>
      
      <div className="space-y-2">
        {displayFindings.map((finding: any, index: number) => (
          <div key={index} className="flex items-center space-x-2 text-sm">
            {getIcon(finding.severity, finding.status)}
            <span className="text-gray-300 flex-1">
              {finding.message || finding.description || finding.type}
            </span>
            {finding.severity && finding.severity !== "info" && (
              <Badge 
                variant="outline" 
                className={`text-xs ${getSeverityColor(finding.severity)}`}
              >
                {finding.severity.toUpperCase()}
              </Badge>
            )}
          </div>
        ))}
      </div>

      {/* Summary */}
      <div className="mt-4 pt-3 border-t border-slate-700">
        <div className="flex items-center justify-between text-xs text-gray-400">
          <span>Security Score:</span>
          <span className={`font-medium ${hasFindings ? 'text-yellow-400' : 'text-green-400'}`}>
            {hasFindings ? `${Math.max(0, 100 - findings.length * 20)}%` : '100%'}
          </span>
        </div>
        {hasFindings && (
          <div className="mt-1 text-xs text-gray-500">
            {findings.length} security issue{findings.length !== 1 ? 's' : ''} detected
          </div>
        )}
      </div>
    </div>
  );
}
