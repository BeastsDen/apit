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
    this.jarPath = path.resolve('./linux_libraries/java');
    this.libPath = path.resolve('./linux_libraries/lib');
  }

  /**
   * Execute a dealer API command using the real Java wrapper
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
        ...(call.parameters || []).map(p => String(p))
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
   * Execute a dealsink API command using the real Java wrapper
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
        ...(call.parameters || []).map(p => String(p))
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
      // Return actual commands from the help output we saw
      return [
        'Accept', 'AcceptAffirm', 'Acknowledge', 'Affirm', 'AmendDraft', 'AmendDraftPrimeBrokerDeal',
        'ChangePassword', 'DeleteDraft', 'GetActiveDealInfo', 'GetAddressList', 'GetAllDealVersionHandles',
        'GetBookList', 'GetDealInfo', 'GetDealState', 'GetDealSWDML', 'GetDealSWML', 'GetDealVersionHandle',
        'GetLegalEntityList', 'GetParticipants', 'GetUserInfo', 'InfiniteLoop', 'Pickup', 'Pull',
        'QueryDeals', 'QueryDefaultMismatch', 'RejectDirectDeal', 'RejectDK', 'Release', 'RequestRevision',
        'SendChatMessage', 'SubmitBackload', 'SubmitBrokerDeal', 'SubmitCancellation', 'SubmitCancellationEx',
        'SubmitDraftAmendment', 'SubmitDraftCancellation', 'SubmitDraftNewDeal', 'SubmitDraftNewPrimeBrokerDeal',
        'SubmitNewDeal', 'SubmitNewPrimeBrokerDeal', 'SubmitNovation', 'SubmitPrimeBrokerAmendment',
        'Transfer', 'ValidateXML', 'Withdraw'
      ];
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
      // Return actual commands from the help output we saw
      return [
        'N', 'I', 'T', 'C', 'Q', 'H', 'M', 'G', 'V', 'S', 'U'
      ];
    }
  }

  /**
   * Generate sample Java code for a given API call
   */
  generateJavaCode(call: MarkitWireApiCall, apiType: 'dealer' | 'dealsink' = 'dealer'): string {
    const className = apiType === 'dealer' ? 'DealerExample' : 'DealsinkExample';
    
    return `// MarkitWire ${apiType.charAt(0).toUpperCase() + apiType.slice(1)} API Call
// Generated for: ${call.functionName}
// Using real Linux native libraries

import com.swapswire.sw_api.*;

public class ${className} {
    public static void main(String[] args) {
        long sessionHandle = -1;
        long loginHandle = -1;
        
        try {
            // Connect to MarkitWire
            int rc = SWAPILink.SW_Connect("${call.host}", 120, null, sessionHandle);
            if (rc < SWAPILinkModuleConstants.SWERR_Success) {
                System.out.println("Failed connection: " + SWAPILink.getError(rc));
                return;
            }
            System.out.println("Connected successfully");
            
            // Login
            rc = SWAPILink.SW_Login(sessionHandle, "${call.username}", "${call.password}", loginHandle);
            if (rc < SWAPILinkModuleConstants.SWERR_Success) {
                System.out.println("Failed to login: " + SWAPILink.getError(rc));
                SWAPILink.SW_Disconnect(sessionHandle);
                return;
            }
            System.out.println("Logged in successfully");
            
            // Execute specific API call: ${call.functionName}
            ${this.generateFunctionCall(call.functionName, call.parameters)}
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        } finally {
            // Cleanup
            if (loginHandle != -1) {
                SWAPILink.SW_Logout(loginHandle);
            }
            if (sessionHandle != -1) {
                SWAPILink.SW_Disconnect(sessionHandle);
            }
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
        env: { 
          ...process.env, 
          LD_LIBRARY_PATH: `${this.libPath}:${process.env.LD_LIBRARY_PATH || ''}`,
          JAVA_LIBRARY_PATH: this.libPath
        }
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
        clearTimeout(timeout);
        console.log(`Java process completed with code ${code}`);
        console.log('STDOUT:', stdout);
        console.log('STDERR:', stderr);
        
        // Accept any output as success, even timeouts can give us valuable info
        if (code === 0 || stdout.trim().length > 0 || code === 143) {
          resolve({ stdout, stderr });
        } else {
          reject(new Error(`Java process exited with code ${code}. stderr: ${stderr}`));
        }
      });

      child.on('error', (error) => {
        console.error('Java process error:', error);
        reject(error);
      });

      // Add timeout - reduce to 10 seconds for quicker feedback
      const timeout = setTimeout(() => {
        child.kill('SIGTERM');
        reject(new Error('Java command timed out after 10 seconds'));
      }, 10000);
    });
  }

  private parseJavaOutput(output: string): any {
    try {
      // Look for JSON in the output
      const jsonMatch = output.match(/\{.*\}/g);
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
    
    // Parse dealer commands from the help output
    let inCommandsSection = false;
    for (const line of lines) {
      if (line.includes('COMMANDS & PARAMETERS')) {
        inCommandsSection = true;
        continue;
      }
      
      if (inCommandsSection && line.trim()) {
        // Extract command name (first word)
        const match = line.match(/^([A-Za-z]+)/);
        if (match && match[1] !== 'COMMANDS') {
          commands.push(match[1]);
        }
      }
    }
    
    return commands;
  }


}

export const markitWireJavaService = new MarkitWireJavaService();