var chai = require('chai');
var PEG = require('./parser.js');
var expect = chai.expect;

function removeSpaces(str){
  return str.replace(/\s/g,'');;
}

describe("Aritmethics expressions", function () {
  it("# a = 5 + 5", function(){
    var tree = `[{"type": "=", "left": {"type": "ID", "value": "a"}, "right": [{"type": "+", "left":
                  {"type": "NUM", "value": 5}, "right": {"type": "NUM", "value": 5} }] }]
                `;
    tree = removeSpaces(tree);
    var res = removeSpaces(JSON.stringify(PEG.parse('a = 5 + 5;'), null, 2))
    expect(res).to.equal(tree);
  });
  it("# a = 5 * 5 - 10", function(){
    var tree = `[{"type": "=", "left": {"type": "ID","value": "a" },"right": [{"type": "-","left": [{
                "type": "*","left": { "type": "NUM", "value": 5},"right": {"type": "NUM", "value": 5}
                }],"right": {"type": "NUM", "value": 10} } ]}]
                `;
    tree = removeSpaces(tree);
    var res = removeSpaces(JSON.stringify(PEG.parse('a = 5 * 5 - 10;'), null, 2))
    expect(res).to.equal(tree);
  });
});
