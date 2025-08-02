import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { 
  ChevronDown, 
  ChevronRight, 
  UserCircle, 
  Handshake, 
  Bell, 
  Database,
  Plug,
  LogIn,
  LogOut,
  Send,
  Check,
  Unlock,
  X,
  RefreshCw,
  Mail,
  Search,
  Book
} from "lucide-react";
import { cn } from "@/lib/utils";
import type { ApiEndpoint } from "@shared/schema";

interface ApiEndpointTreeProps {
  endpoints: ApiEndpoint[];
  onEndpointSelect: (endpoint: ApiEndpoint) => void;
  selectedEndpoint: ApiEndpoint | null;
  isLoading: boolean;
}

const categoryIcons = {
  "Session Management": UserCircle,
  "Deal Management": Handshake,
  "Notifications": Bell,
  "Data Retrieval": Database,
};

const endpointIcons: Record<string, any> = {
  "SW_Connect": Plug,
  "SW_Login": LogIn,
  "SW_Logout": LogOut,
  "SW_SubmitDeal": Send,
  "SW_AffirmDeal": Check,
  "SW_ReleaseDeal": Unlock,
  "SW_WithdrawDeal": X,
  "SW_Poll": RefreshCw,
  "SW_GetNotification": Mail,
  "SW_GetDealByID": Search,
  "SW_GetDealsForBook": Book,
};

const endpointColors: Record<string, string> = {
  "SW_Connect": "text-green-500",
  "SW_Login": "text-blue-500",
  "SW_Logout": "text-red-500",
  "SW_SubmitDeal": "text-blue-500",
  "SW_AffirmDeal": "text-green-500",
  "SW_ReleaseDeal": "text-yellow-500",
  "SW_WithdrawDeal": "text-red-500",
  "SW_Poll": "text-blue-500",
  "SW_GetNotification": "text-yellow-500",
  "SW_GetDealByID": "text-blue-500",
  "SW_GetDealsForBook": "text-green-500",
};

export function ApiEndpointTree({ endpoints, onEndpointSelect, selectedEndpoint, isLoading }: ApiEndpointTreeProps) {
  const [expandedCategories, setExpandedCategories] = useState<Set<string>>(new Set([
    "Session Management",
    "Deal Management",
    "Notifications", 
    "Data Retrieval"
  ]));

  if (isLoading) {
    return (
      <div className="space-y-3">
        {Array.from({ length: 4 }).map((_, i) => (
          <div key={i} className="space-y-2">
            <Skeleton className="h-8 w-full bg-slate-700" />
            <div className="ml-6 space-y-1">
              <Skeleton className="h-6 w-3/4 bg-slate-700" />
              <Skeleton className="h-6 w-2/3 bg-slate-700" />
            </div>
          </div>
        ))}
      </div>
    );
  }

  // Group endpoints by category
  const groupedEndpoints = endpoints.reduce((acc, endpoint) => {
    if (!acc[endpoint.category]) {
      acc[endpoint.category] = [];
    }
    acc[endpoint.category].push(endpoint);
    return acc;
  }, {} as Record<string, ApiEndpoint[]>);

  const toggleCategory = (category: string) => {
    const newExpanded = new Set(expandedCategories);
    if (newExpanded.has(category)) {
      newExpanded.delete(category);
    } else {
      newExpanded.add(category);
    }
    setExpandedCategories(newExpanded);
  };

  const getMethodColor = (method: string) => {
    switch (method.toUpperCase()) {
      case 'GET':
        return 'bg-green-600';
      case 'POST':
        return 'bg-blue-600';
      case 'PUT':
        return 'bg-yellow-600';
      case 'DELETE':
        return 'bg-red-600';
      case 'PATCH':
        return 'bg-purple-600';
      default:
        return 'bg-gray-600';
    }
  };

  return (
    <div className="space-y-1">
      {Object.entries(groupedEndpoints).map(([category, categoryEndpoints]) => {
        const isExpanded = expandedCategories.has(category);
        const CategoryIcon = categoryIcons[category as keyof typeof categoryIcons] || Database;

        return (
          <div key={category} className="mb-3">
            <Button
              variant="ghost"
              onClick={() => toggleCategory(category)}
              className="flex items-center w-full text-left p-2 hover:bg-slate-750 rounded transition-colors justify-start"
            >
              {isExpanded ? (
                <ChevronDown className="h-3 w-3 text-gray-400 mr-2" />
              ) : (
                <ChevronRight className="h-3 w-3 text-gray-400 mr-2" />
              )}
              <CategoryIcon className="h-4 w-4 text-blue-400 mr-2" />
              <span className="text-sm font-medium">{category}</span>
              <Badge variant="secondary" className="ml-auto text-xs">
                {categoryEndpoints.length}
              </Badge>
            </Button>

            {isExpanded && (
              <div className="ml-6 space-y-1 mt-1">
                {categoryEndpoints.map((endpoint) => {
                  const EndpointIcon = endpointIcons[endpoint.name] || Database;
                  const iconColor = endpointColors[endpoint.name] || "text-gray-400";
                  const isSelected = selectedEndpoint?.id === endpoint.id;

                  return (
                    <Button
                      key={endpoint.id}
                      variant="ghost"
                      onClick={() => onEndpointSelect(endpoint)}
                      className={cn(
                        "flex items-center w-full text-left p-2 rounded transition-colors justify-start text-sm text-gray-300",
                        isSelected ? "bg-slate-700 text-white" : "hover:bg-slate-750"
                      )}
                    >
                      <EndpointIcon className={cn("h-4 w-4 mr-2", iconColor)} />
                      <span className="flex-1">{endpoint.name}</span>
                      <Badge 
                        variant="outline" 
                        className={cn("text-xs font-mono", getMethodColor(endpoint.method))}
                      >
                        {endpoint.method}
                      </Badge>
                    </Button>
                  );
                })}
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
}
