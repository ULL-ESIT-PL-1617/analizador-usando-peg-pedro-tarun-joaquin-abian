{
  var util = require('util');
  var variables = [];
  var constants = [];
  var functions = [];
}

statements =
      left:statement right:(SC statements)*
      { return left; }

statement =
      IF c:condition /*&{ console.log(c); }*/ THEN LEFTBRAC statements RIGHTBRAC
      / WHILE c:condition LEFTBRAC statements RIGHTBRAC
      / id:ID LEFTPAR (parameters (COMMA parameters)*)* RIGHTPAR
      / a:assign { return a; }
      / add:additive { return add; }


/*functionCall
  = id:ID LEFTPAR (parameters (COMMA parameters)*)* RIGHTPAR*/

parameters
  = id:ID LEFTPAR (parameters (COMMA parameters)*)* RIGHTPAR
    / a:additive

condition
  = LEFTPAR left:additive COMPARISON right:additive RIGHTPAR

assign
  = CONST id:ID ASSIGN result:additive
  / id:ID ASSIGN result:FUNCTION LEFTPAR args:arguments RIGHTPAR LEFTBRAC st:statements RIGHTBRAC
  / id:ID ASSIGN result:additive

function
  = FUNCTION LEFTPAR args:arguments RIGHTPAR LEFTBRAC st:statements RIGHTBRAC

arguments
  = (id:ID (COMMA ID)*)*

additive
  = left:multiplicative right:(ADDOP multiplicative)*
  {
    if(right.length == 0){
      return left;
    } else {
      let arr = {};
      let tmp = {"left": left};
      right.forEach(function(item){
        tmp["left"]: tmp;
        arr.push({type:item[0], left: left, right: item[1]});
      });
      return arr;
    }
  }

multiplicative
  = left:primary right:(MULOP primary)*
  {
    if(right.length == 0){
      return left;
    } else {
      let arr = [];
      arr.push({"type": "MULTIPL", "left": left})
      right.forEach(function(item){
        arr.push({type:item[0], right: item[1]});
      });
      return arr;
    }
  }

primary
  = int:integer { return int; }
  / id:ID { return { "type": "ID", "name": id }; }
  / left:LEFTPAR comma:statements right:RIGHTPAR { return comma; }

integer "integer"
  = NUMBER

_ = $[ \t\n\r]*

ADDOP = PLUS / MINUS
MULOP = MULT / DIV
COMMA = _","_
PLUS = _"+"_
MINUS = _"-"_
MULT = _"*"_
DIV = _"/"_
LEFTPAR = _"("_
RIGHTPAR = _")"_
LEFTBRAC = _"{"_
RIGHTBRAC  = _"}"_
FUNCTION = _"function"_
IF = _"if"_
THEN = _"then"_
WHILE = _"while"_
CONST = _"const"_
SC = _";"_
COMPARISON = _ comp:$[<>!=][=]? _ { return comp ; }
NUMBER = _ digits:$[0-9]+ _ { return {'type' : 'NUM', 'value' : parseInt(digits, 10)}; }
ID = _ $([a-z_]i$([a-z0-9_]i*)) _
ASSIGN = _ '=' _
