#!/usr/bin/env node
var util = require('util');
var fs = require('fs');
var PEG = require("./grammar.js");
var fileName = process.argv[2] || 'input2';
var genCode = function(tree) {
  var translation = "module.exports = () = > {";
  // traverse the tree producing translation
  return translation;
}
fs.readFile(fileName, 'utf8', function (err,input) {
  if (err) {
    return console.log(err);
  }
  console.log(`Processing <\n${input}\n>`);
  var r = PEG.parse(input);
  var js = genCode(r);
  console.log(util.inspect(r));
});
