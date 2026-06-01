// Capture HTML diagrams to PNG using puppeteer (bundled with mermaid-cli)
// Usage: node capture.js <input.html> <output.png>

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const npmRoot = execSync('npm root -g', { encoding: 'utf-8' }).trim();
const puppeteer = require(path.join(npmRoot, '@mermaid-js/mermaid-cli/node_modules/puppeteer'));

const inputHtml = process.argv[2];
const outputPng = process.argv[3];

if (!inputHtml || !outputPng) {
  console.error('Usage: node capture.js <input.html> <output.png>');
  process.exit(1);
}

(async () => {
  const browser = await puppeteer.launch({
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 1400, height: 900, deviceScaleFactor: 2 });
  await page.goto(`file://${path.resolve(inputHtml)}`, { waitUntil: 'networkidle0' });

  // Wait a bit for font rendering
  await new Promise(r => setTimeout(r, 500));

  // Find container and capture only it
  const element = await page.$('.container');
  if (element) {
    await element.screenshot({ path: outputPng, omitBackground: false });
  } else {
    await page.screenshot({ path: outputPng, fullPage: true });
  }

  await browser.close();
  console.log(`✓ Captured: ${outputPng}`);
})();
