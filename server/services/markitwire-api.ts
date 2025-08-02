import axios, { AxiosResponse } from 'axios';

interface SecurityOptions {
  sqlInjection?: boolean;
  parameterFuzzing?: boolean;
  authBypass?: boolean;
  rateLimitTesting?: boolean;
  dataExposureAnalysis?: boolean;
  sessionManagement?: boolean;
}

interface ApiRequestOptions {
  method: string;
  url: string;
  headers?: Record<string, string>;
  body?: any;
  securityOptions?: SecurityOptions;
}

interface SecurityFinding {
  type: string;
  severity: 'low' | 'medium' | 'high' | 'critical';
  description: string;
  evidence?: string;
}

interface ApiResponse {
  status: number;
  headers: Record<string, string>;
  data: any;
  securityFindings?: SecurityFinding[];
}

export async function makeApiRequest(options: ApiRequestOptions): Promise<ApiResponse> {
  const { method, url, headers = {}, body, securityOptions } = options;
  
  const securityFindings: SecurityFinding[] = [];
  
  try {
    // Execute the primary request
    const response: AxiosResponse = await axios({
      method: method.toLowerCase() as any,
      url,
      headers,
      data: body,
      timeout: 30000,
      validateStatus: () => true, // Don't throw on HTTP error codes
    });

    // Perform security analysis
    if (securityOptions) {
      securityFindings.push(...await performSecurityAnalysis(response, options, securityOptions));
    }

    return {
      status: response.status,
      headers: response.headers as Record<string, string>,
      data: response.data,
      securityFindings
    };
    
  } catch (error) {
    console.error('API request failed:', error);
    
    if (axios.isAxiosError(error)) {
      return {
        status: error.response?.status || 0,
        headers: error.response?.headers as Record<string, string> || {},
        data: { error: error.message },
        securityFindings
      };
    }
    
    throw error;
  }
}

async function performSecurityAnalysis(
  response: AxiosResponse, 
  originalOptions: ApiRequestOptions, 
  securityOptions: SecurityOptions
): Promise<SecurityFinding[]> {
  const findings: SecurityFinding[] = [];
  
  // Analyze response headers for security issues
  analyzeResponseHeaders(response, findings);
  
  // Analyze response body for data exposure
  if (securityOptions.dataExposureAnalysis) {
    analyzeDataExposure(response, findings);
  }
  
  // Test for SQL injection if enabled
  if (securityOptions.sqlInjection) {
    await testSqlInjection(originalOptions, findings);
  }
  
  // Test authentication bypass if enabled
  if (securityOptions.authBypass) {
    await testAuthenticationBypass(originalOptions, findings);
  }
  
  // Test rate limiting if enabled
  if (securityOptions.rateLimitTesting) {
    await testRateLimiting(originalOptions, findings);
  }
  
  return findings;
}

function analyzeResponseHeaders(response: AxiosResponse, findings: SecurityFinding[]) {
  const headers = response.headers;
  
  // Check for missing security headers
  if (!headers['x-content-type-options']) {
    findings.push({
      type: 'Missing Security Header',
      severity: 'medium',
      description: 'X-Content-Type-Options header is missing',
      evidence: 'Response lacks X-Content-Type-Options: nosniff header'
    });
  }
  
  if (!headers['x-frame-options'] && !headers['content-security-policy']) {
    findings.push({
      type: 'Missing Security Header',
      severity: 'medium',
      description: 'X-Frame-Options or CSP header is missing',
      evidence: 'Response lacks clickjacking protection'
    });
  }
  
  if (!headers['strict-transport-security']) {
    findings.push({
      type: 'Missing Security Header',
      severity: 'high',
      description: 'Strict-Transport-Security header is missing',
      evidence: 'HTTPS connections are not enforced'
    });
  }
  
  // Check for information disclosure in headers
  if (headers['server']) {
    findings.push({
      type: 'Information Disclosure',
      severity: 'low',
      description: 'Server information disclosed in headers',
      evidence: `Server: ${headers['server']}`
    });
  }
}

function analyzeDataExposure(response: AxiosResponse, findings: SecurityFinding[]) {
  const responseText = JSON.stringify(response.data);
  
  // Check for common sensitive data patterns
  const sensitivePatterns = [
    { pattern: /password/i, type: 'Password field exposed' },
    { pattern: /secret/i, type: 'Secret value exposed' },
    { pattern: /token/i, type: 'Token exposed' },
    { pattern: /key/i, type: 'API key exposed' },
    { pattern: /credit.*card/i, type: 'Credit card information' },
    { pattern: /ssn|social.*security/i, type: 'SSN exposed' },
  ];
  
  sensitivePatterns.forEach(({ pattern, type }) => {
    if (pattern.test(responseText)) {
      findings.push({
        type: 'Data Exposure',
        severity: 'high',
        description: type,
        evidence: 'Sensitive data found in API response'
      });
    }
  });
  
  // Check for excessive data exposure (large response size)
  if (responseText.length > 100000) {
    findings.push({
      type: 'Excessive Data Exposure',
      severity: 'medium',
      description: 'API response contains large amount of data',
      evidence: `Response size: ${responseText.length} characters`
    });
  }
}

async function testSqlInjection(options: ApiRequestOptions, findings: SecurityFinding[]) {
  const sqlPayloads = [
    "' OR '1'='1",
    "'; DROP TABLE users; --",
    "' UNION SELECT null --"
  ];
  
  for (const payload of sqlPayloads) {
    try {
      // Test payload in different parts of the request
      const testOptions = { ...options };
      
      // Test in URL parameters
      if (testOptions.url.includes('?')) {
        testOptions.url += `&test=${encodeURIComponent(payload)}`;
      } else {
        testOptions.url += `?test=${encodeURIComponent(payload)}`;
      }
      
      const response = await axios({
        method: testOptions.method.toLowerCase() as any,
        url: testOptions.url,
        headers: testOptions.headers,
        data: testOptions.body,
        timeout: 5000,
        validateStatus: () => true,
      });
      
      // Check for SQL error messages in response
      const responseText = JSON.stringify(response.data).toLowerCase();
      const sqlErrorPatterns = [
        /sql syntax/,
        /mysql_fetch/,
        /ora-\d{5}/,
        /microsoft ole db/,
        /sqlite_/
      ];
      
      if (sqlErrorPatterns.some(pattern => pattern.test(responseText))) {
        findings.push({
          type: 'SQL Injection Vulnerability',
          severity: 'critical',
          description: 'SQL injection vulnerability detected',
          evidence: `Payload: ${payload} resulted in SQL error`
        });
        break; // Stop testing once vulnerability is found
      }
    } catch (error) {
      // Ignore errors during security testing
    }
  }
}

async function testAuthenticationBypass(options: ApiRequestOptions, findings: SecurityFinding[]) {
  try {
    // Test with no authentication headers
    const testOptions = { ...options };
    delete testOptions.headers?.['authorization'];
    delete testOptions.headers?.['Authorization'];
    
    const response = await axios({
      method: testOptions.method.toLowerCase() as any,
      url: testOptions.url,
      headers: testOptions.headers,
      data: testOptions.body,
      timeout: 5000,
      validateStatus: () => true,
    });
    
    // If we get a 2xx response without auth, it might be a bypass
    if (response.status >= 200 && response.status < 300) {
      findings.push({
        type: 'Authentication Bypass',
        severity: 'critical',
        description: 'Endpoint accessible without authentication',
        evidence: `HTTP ${response.status} response received without authentication headers`
      });
    }
  } catch (error) {
    // Ignore errors during security testing
  }
}

async function testRateLimiting(options: ApiRequestOptions, findings: SecurityFinding[]) {
  const requestCount = 10;
  let successCount = 0;
  
  try {
    const promises = Array(requestCount).fill(null).map(() => 
      axios({
        method: options.method.toLowerCase() as any,
        url: options.url,
        headers: options.headers,
        data: options.body,
        timeout: 2000,
        validateStatus: () => true,
      })
    );
    
    const responses = await Promise.allSettled(promises);
    
    responses.forEach(result => {
      if (result.status === 'fulfilled' && result.value.status < 400) {
        successCount++;
      }
    });
    
    // If most requests succeed, rate limiting might be missing
    if (successCount > requestCount * 0.8) {
      findings.push({
        type: 'Missing Rate Limiting',
        severity: 'medium',
        description: 'No rate limiting detected',
        evidence: `${successCount}/${requestCount} rapid requests succeeded`
      });
    }
  } catch (error) {
    // Ignore errors during security testing
  }
}
