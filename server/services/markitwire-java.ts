import { spawn } from 'child_process';
import path from 'path';
import { markitWireSimulator } from './markitwire-simulator';

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
   * Falls back to simulation since Windows DLLs cannot run on Linux
   */
  async executeDealerCommand(call: MarkitWireApiCall): Promise<MarkitWireApiResponse> {
    // Check if we're on Linux with Windows DLLs (which won't work)
    if (process.platform === 'linux' && this.hasOnlyWindowsDlls()) {
      console.log('Falling back to simulation: Windows DLLs cannot run on Linux');
      return await markitWireSimulator.simulateApiCall(call);
    }

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
      console.log('Java execution failed, falling back to simulation:', error);
      return await markitWireSimulator.simulateApiCall(call);
    }
  }

  /**
   * Execute a dealsink API command using the Java wrapper
   * Falls back to simulation since Windows DLLs cannot run on Linux
   */
  async executeDealsinkCommand(call: MarkitWireApiCall): Promise<MarkitWireApiResponse> {
    // Check if we're on Linux with Windows DLLs (which won't work)
    if (process.platform === 'linux' && this.hasOnlyWindowsDlls()) {
      console.log('Falling back to simulation: Windows DLLs cannot run on Linux');
      return await markitWireSimulator.simulateApiCall(call);
    }

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
      console.log('Java execution failed, falling back to simulation:', error);
      return await markitWireSimulator.simulateApiCall(call);
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
    // Use the simulator's more comprehensive code generation
    return markitWireSimulator.generateJavaCode(call, apiType);
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

  /**
   * Check if we only have Windows DLL files (which won't work on Linux)
   */
  private hasOnlyWindowsDlls(): boolean {
    try {
      const fs = require('fs');
      const files = fs.readdirSync(this.libPath);
      const hasDlls = files.some((file: string) => file.endsWith('.dll'));
      const hasSoFiles = files.some((file: string) => file.endsWith('.so'));
      return hasDlls && !hasSoFiles;
    } catch (e) {
      return true; // Assume we need simulation if we can't check
    }
  }
}

export const markitWireJavaService = new MarkitWireJavaService();