import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useToast } from "@/hooks/use-toast";
import { Box, CheckCircle, Plus, Upload } from "lucide-react";
import { apiRequest } from "@/lib/queryClient";
import type { LibraryFile } from "@shared/schema";

interface LibraryManagerProps {
  libraries: LibraryFile[];
}

export function LibraryManager({ libraries }: LibraryManagerProps) {
  const [isDragOver, setIsDragOver] = useState(false);
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const uploadLibraryMutation = useMutation({
    mutationFn: async (file: File) => {
      const formData = new FormData();
      formData.append('library', file);
      formData.append('version', 'unknown');
      
      const response = await fetch('/api/libraries/upload', {
        method: 'POST',
        body: formData,
      });
      
      if (!response.ok) {
        throw new Error('Failed to upload library');
      }
      
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/libraries"] });
      toast({
        title: "Library Uploaded",
        description: "Library file has been uploaded successfully",
      });
    },
    onError: (error) => {
      toast({
        title: "Upload Failed",
        description: error.message,
        variant: "destructive",
      });
    },
  });

  const handleFileUpload = (files: FileList | null) => {
    if (!files || files.length === 0) return;
    
    const file = files[0];
    uploadLibraryMutation.mutate(file);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragOver(false);
    handleFileUpload(e.dataTransfer.files);
  };

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragOver(true);
  };

  const handleDragLeave = () => {
    setIsDragOver(false);
  };

  const triggerFileInput = () => {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = '.zip,.dll,.lib,.so';
    input.onchange = (e) => {
      const target = e.target as HTMLInputElement;
      handleFileUpload(target.files);
    };
    input.click();
  };

  return (
    <div>
      <h3 className="text-sm font-semibold text-gray-300 mb-3 flex items-center">
        <Box className="h-4 w-4 mr-2" />
        API Libraries
      </h3>
      
      <div className="space-y-2">
        {/* Default Libraries */}
        <div className="flex items-center justify-between p-2 bg-slate-750 rounded">
          <span className="text-sm text-green-400 flex items-center">
            <CheckCircle className="h-4 w-4 mr-2" />
            MarkitWire.dll
          </span>
          <Badge variant="secondary" className="text-xs">
            v20.1
          </Badge>
        </div>
        
        <div className="flex items-center justify-between p-2 bg-slate-750 rounded">
          <span className="text-sm text-green-400 flex items-center">
            <CheckCircle className="h-4 w-4 mr-2" />
            DealSink.lib
          </span>
          <Badge variant="secondary" className="text-xs">
            v20.1
          </Badge>
        </div>

        {/* Uploaded Libraries */}
        {libraries.map((library) => (
          <div key={library.id} className="flex items-center justify-between p-2 bg-slate-750 rounded">
            <span className="text-sm text-green-400 flex items-center">
              <CheckCircle className="h-4 w-4 mr-2" />
              {library.filename}
            </span>
            <Badge variant="secondary" className="text-xs">
              {library.version}
            </Badge>
          </div>
        ))}

        {/* Upload Area */}
        <div
          className={`border-2 border-dashed rounded p-3 text-center transition-colors cursor-pointer ${
            isDragOver 
              ? 'border-blue-500 bg-blue-500/10' 
              : 'border-slate-600 hover:border-slate-500'
          }`}
          onDrop={handleDrop}
          onDragOver={handleDragOver}
          onDragLeave={handleDragLeave}
          onClick={triggerFileInput}
        >
          {uploadLibraryMutation.isPending ? (
            <div className="flex items-center justify-center space-x-2 text-blue-400">
              <div className="animate-spin h-4 w-4 border-2 border-blue-400 border-t-transparent rounded-full" />
              <span className="text-sm">Uploading...</span>
            </div>
          ) : (
            <div className="flex items-center justify-center space-x-2 text-gray-400 hover:text-gray-300">
              <Plus className="h-4 w-4" />
              <span className="text-sm">Load Additional Libraries</span>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
