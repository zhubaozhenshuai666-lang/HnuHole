const fs = require('node:fs');
const path = require('node:path');
const { pathToFileURL } = require('node:url');
const { chromium } = require('/Users/zewbao/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
(async () => {
  const browser = await chromium.launch({executablePath:'/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge',headless:true});
  try {
    const page = await browser.newPage({viewport:{width:402,height:874},deviceScaleFactor:2});
    await page.goto(pathToFileURL(path.join(__dirname,'message-home.html')).href);
    await page.evaluate(() => document.fonts.ready);
    const report = await page.evaluate(() => {
      const rect = e => {const r=e.getBoundingClientRect();return {x:r.x,y:r.y,width:r.width,height:r.height};};
      const texts = [...document.querySelectorAll('.quick-label,.name,.summary,.time')].map(e => ({text:e.textContent.trim(),clipped:e.scrollWidth>e.clientWidth,rect:rect(e)}));
      return {canvas:{width:innerWidth,height:innerHeight},labels:[...document.querySelectorAll('.quick-label')].map(e=>e.textContent),texts,identityButton:rect(document.querySelector('.identity-switch')),identityDot:rect(document.querySelector('.identity-dot')),rows:[...document.querySelectorAll('.conversation')].map(e=>({name:e.querySelector('.name').textContent,...rect(e)})),horizontalOverflow:document.documentElement.scrollWidth>innerWidth};
    });
    fs.writeFileSync(path.join(__dirname,'verification.json'),JSON.stringify(report,null,2));
    if(report.horizontalOverflow || report.texts.some(t=>t.clipped)) throw new Error('Unexpected text or viewport clipping');
    await page.screenshot({path:path.join(__dirname,'消息首页.png')});
    console.log(JSON.stringify({png:path.join(__dirname,'消息首页.png'),pixelSize:[804,1748],textClipping:report.texts.filter(t=>t.clipped),rowCount:report.rows.length,labels:report.labels}));
  } finally { await browser.close(); }
})().catch(error=>{console.error(error);process.exitCode=1;});
