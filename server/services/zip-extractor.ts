import AdmZip from 'adm-zip';
import path from 'path';
import fs from 'fs';

export async function extractZipFile(zipPath: string): Promise<string> {
  try {
    const zip = new AdmZip(zipPath);
    const extractPath = path.join(path.dirname(zipPath), 'extracted', path.basename(zipPath, '.zip'));
    
    // Create extraction directory
    if (!fs.existsSync(extractPath)) {
      fs.mkdirSync(extractPath, { recursive: true });
    }
    
    // Extract all files
    zip.extractAllTo(extractPath, true);
    
    return extractPath;
  } catch (error) {
    console.error('Failed to extract ZIP file:', error);
    throw new Error('Failed to extract ZIP file');
  }
}

export function getExtractedFiles(extractPath: string): string[] {
  try {
    if (!fs.existsSync(extractPath)) {
      return [];
    }
    
    const files: string[] = [];
    const scanDirectory = (dir: string) => {
      const items = fs.readdirSync(dir);
      for (const item of items) {
        const fullPath = path.join(dir, item);
        const stat = fs.statSync(fullPath);
        if (stat.isDirectory()) {
          scanDirectory(fullPath);
        } else {
          files.push(fullPath);
        }
      }
    };
    
    scanDirectory(extractPath);
    return files;
  } catch (error) {
    console.error('Failed to read extracted files:', error);
    return [];
  }
}
