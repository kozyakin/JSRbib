#!/usr/bin/env node
"use strict";

const filecss = process.argv[2];
const filehtml = process.argv[3];

const fs = require('fs');
const html = fs.readFileSync(filehtml, 'utf8');
const css = fs.readFileSync(filecss, 'utf8');

const spattern = new RegExp(`<link .*href='${filecss}'.*>`);
const rpattern = `<style type='text/css'>\n\n<!--\n${css}\n\n-->\n</style>`;

const injectedHtml = html.replace(spattern, rpattern);

if (injectedHtml) {
	fs.writeFileSync(filehtml, injectedHtml);
	console.log("\n[94mInject-CSS: done![0m");
} else {
	console.log("\n[91mInject-CSS: Sorry! Something went wrong![0m");
}
