const process = require('process');
const fs = require('fs');
const filecss = process.argv[2];
const filehtml = process.argv[3];

const html = fs.readFileSync(filehtml, 'utf8');
const css = fs.readFileSync(filecss, 'utf8');

var spattern = new RegExp("<link .*href='" + filecss + "'.*>");
const rpattern = "<style type='text/css'>\n\n<!--\n" + css + "\n\n-->\n</style>";

const injectedHtml = html.replace(spattern,rpattern);
if (injectedHtml) { fs.writeFileSync(filehtml, injectedHtml); }


