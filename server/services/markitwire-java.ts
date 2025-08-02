import { spawn } from 'child_process';
import path from 'path';

interface MarkitWireApiCall {
  functionName: string;
  host: string;
  username: string;
  password: string;
  parameters: any[];
}

interface MarkitWireApiResponse {
  success: boolean;
  data?: any;
  error?: string;
  executionTime: number;
  javaOutput?: string;
}

class MarkitWireJavaService {
  private readonly jarPath: string;
  private readonly libPath: string;

  constructor() {
    this.jarPath = path.resolve('./extracted_libraries/java');
    this.libPath = path.resolve('./extracted_libraries/lib');
  }

  /**
   * Execute a dealer API command using the Java wrapper
   */
  async executeDealerCommand(call: MarkitWireApiCall): Promise<MarkitWireApiResponse> {
    const startTime = Date.now();
    
    try {
      const args = [
        '-Djava.library.path=' + this.libPath,
        '-jar', 
        path.join(this.jarPath, 'java_dealer_example.jar'),
        call.host,
        call.username,
        call.password,
        call.functionName,
        ...call.parameters.map(p => String(p))
      ];

      const result = await this.executeJavaCommand(args);
      const executionTime = Date.now() - startTime;

      return {
        success: true,
        data: this.parseJavaOutput(result.stdout),
        javaOutput: result.stdout,
        executionTime
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        executionTime: Date.now() - startTime
      };
    }
  }

  /**
   * Execute a dealsink API command using the Java wrapper
   */
  async executeDealsinkCommand(call: MarkitWireApiCall): Promise<MarkitWireApiResponse> {
    const startTime = Date.now();
    
    try {
      const args = [
        '-Djava.library.path=' + this.libPath,
        '-jar', 
        path.join(this.jarPath, 'java_dealsink_example.jar'),
        call.host,
        call.username,
        call.password,
        call.functionName,
        ...call.parameters.map(p => String(p))
      ];

      const result = await this.executeJavaCommand(args);
      const executionTime = Date.now() - startTime;

      return {
        success: true,
        data: this.parseJavaOutput(result.stdout),
        javaOutput: result.stdout,
        executionTime
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        executionTime: Date.now() - startTime
      };
    }
  }

  /**
   * Get available commands for dealer API
   */
  async getDealerCommands(): Promise<string[]> {
    try {
      const args = [
        '-Djava.library.path=' + this.libPath,
        '-jar', 
        path.join(this.jarPath, 'java_dealer_example.jar')
      ];

      const result = await this.executeJavaCommand(args);
      return this.parseCommandList(result.stdout);
    } catch (error) {
      console.error('Failed to get dealer commands:', error);
      return [];
    }
  }

  /**
   * Get available commands for dealsink API
   */
  async getDealsinkCommands(): Promise<string[]> {
    try {
      const args = [
        '-Djava.library.path=' + this.libPath,
        '-jar', 
        path.join(this.jarPath, 'java_dealsink_example.jar')
      ];

      const result = await this.executeJavaCommand(args);
      return this.parseCommandList(result.stdout);
    } catch (error) {
      console.error('Failed to get dealsink commands:', error);
      return [];
    }
  }

  /**
   * Generate sample Java code for a given API call
   */
  generateJavaCode(call: MarkitWireApiCall, apiType: 'dealer' | 'dealsink' = 'dealer'): string {
    const className = apiType === 'dealer' ? 'DealerExample' : 'DealsinkExample';
    const parameterList = call.parameters.map((p, i) => `"${p}"`).join(', ');
    
    return `
// MarkitWire ${apiType.charAt(0).toUpperCase() + apiType.slice(1)} API Call
import com.swapswire.sw_api.*;

public class ${className} {
    public static void main(String[] args) {
        try {
            // Connect to MarkitWire
            long sessionHandle = -1;
            long loginHandle = -1;
            
            int rc = SW_Connect("${call.host}", 120, null, sessionHandle);
            if (rc < SWERR_Success) {
                System.out.println("Failed connection: " + rc);
                return;
            }
            
            rc = SW_Login(sessionHandle, "${call.username}", "${call.password}", loginHandle);
            if (rc < SWERR_Success) {
                System.out.println("Failed to login: " + rc);
                return;
            }
            
            // Execute API call
            ${this.generateFunctionCall(call.functionName, call.parameters)}
            
            // Cleanup
            SW_Logout(loginHandle);
            SW_Disconnect(sessionHandle);
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }
    }
}`;
  }

  private generateFunctionCall(functionName: string, parameters: any[]): string {
    const paramList = parameters.map((p, i) => `param${i}`).join(', ');
    let paramDeclarations = '';
    
    parameters.forEach((p, i) => {
      if (typeof p === 'string') {
        paramDeclarations += `            String param${i} = "${p}";\n`;
      } else if (typeof p === 'number') {
        paramDeclarations += `            long param${i} = ${p};\n`;
      } else {
        paramDeclarations += `            String param${i} = "${JSON.stringify(p)}";\n`;
      }
    });

    return `${paramDeclarations}            int result = ${functionName}(${paramList});
            System.out.println("Result: " + result);`;
  }

  private async executeJavaCommand(args: string[]): Promise<{stdout: string, stderr: string}> {
    return new Promise((resolve, reject) => {
      const child = spawn('java', args, {
        cwd: this.jarPath,
        env: { ...process.env, LD_LIBRARY_PATH: this.libPath }
      });

      let stdout = '';
      let stderr = '';

      child.stdout.on('data', (data) => {
        stdout += data.toString();
      });

      child.stderr.on('data', (data) => {
        stderr += data.toString();
      });

      child.on('close', (code) => {
        if (code === 0) {
          resolve({ stdout, stderr });
        } else {
          reject(new Error(`Java process exited with code ${code}. stderr: ${stderr}`));
        }
      });

      child.on('error', (error) => {
        reject(error);
      });

      // Add timeout
      setTimeout(() => {
        child.kill();
        reject(new Error('Java command timed out'));
      }, 30000);
    });
  }

  private parseJavaOutput(output: string): any {
    try {
      // Look for JSON in the output
      const jsonMatch = output.match(/\{.*\}/s);
      if (jsonMatch) {
        return JSON.parse(jsonMatch[0]);
      }
      
      // Otherwise return structured output
      const lines = output.split('\n').filter(line => line.trim());
      return {
        raw: output,
        lines: lines,
        summary: lines[lines.length - 1] || 'No output'
      };
    } catch (e) {
      return { raw: output };
    }
  }

  private parseCommandList(output: string): string[] {
    const lines = output.split('\n');
    const commands: string[] = [];
    
    for (const line of lines) {
      // Look for command patterns in the help output
      if (line.includes('Command:') || line.includes('Function:')) {
        const match = line.match(/\b([A-Z][a-zA-Z_]+)\b/);
        if (match) {
          commands.push(match[1]);
        }
      }
    }
    
    // If no commands found in help, return common MarkitWire functions
    if (commands.length === 0) {
      return [
        'SW_Connect',
        'SW_Login', 
        'SW_Logout',
        'SW_Disconnect',
        'SW_GetDealList',
        'SW_SendDeal',
        'SW_AffirmDeal',
        'SW_RejectDeal',
        'SW_WithdrawDeal',
        'SW_RegisterDealNotifyExCallback',
        'SW_Poll'
      ];
    }
    
    return commands;
  }
}

export const markitWireJavaService = new MarkitWireJavaService();