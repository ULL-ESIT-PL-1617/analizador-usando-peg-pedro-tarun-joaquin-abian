{
  var util = require('util');
  var variables = [];
  var constants = [];
  var functions = [];
}

start
  = stat:statements
  { console.log("Constants: " + util.inspect(constants) + "\n");
    console.log("Variables: " + util.inspect(variables) + "\n");
    console.log("Functions: " + util.inspect(functions) + "\n"); return stat; }

statements =
      left:statement right:(SC statements)* SC?
      { return left; }

statement =
      IF c:condition THEN LEFTBRAC content:statements RIGHTBRAC {
        return {
          "type": "IF",
          "condition": c,
          "content": content
        };
      }
      / WHILE c:condition LEFTBRAC content:statements RIGHTBRAC {
        return {
          "type": "WHILE",
          "condition": c,
          "content": content
        };
      }
      / id:ID LEFTPAR param:parameters? RIGHTPAR {
        return {
          "type": "FUNCTIONCALL",
          "ID": id,
          "paramaters": param
        }
      }
      / a:assign { return a; }
      / add:additive { return add; }


/*functionCall
  = id:ID LEFTPAR (parameters (COMMA parameters)*)* RIGHTPAR*/

parameters
  = id:ID LEFTPAR first:parameters rest:(COMMA parameters)* RIGHTPAR {
    let args = [];
    args.push(id.value);
    rest.forEach(function(item){
      args.push(item[1].value);
    });
    return args;
  }
    / a:additive { return a; }

condition
  = LEFTPAR left:additive comp:COMPARISON right:additive RIGHTPAR {
    return {
      "type": comp,
      "left": left,
      "right": right
    };
  }

assign
  = id:ID ASSIGN FUNCTION LEFTPAR args:arguments? RIGHTPAR LEFTBRAC st:statements RIGHTBRAC {
    let funct = {
      "type": "FUNCTION",
      "arguments": args,
      "content": st
    };
    let tmp = {
      "type": "=",
      "left": id.value,
      "right": funct
    };
    let tmp1 = {
      "FUNCTION": id.value,
      "Value": funct
    };
    functions.push(tmp1);
    return tmp;
  }
  / cons:CONST? id:ID ASSIGN result:additive {
    let tmp = {
      "type": "=",
      "left": id.value,
      "right": result.value
    };
    let tmp1 = {
      "ID": id.value,
      "Value": result.value
    };
    if(cons != null) {
      constants.push(tmp1);
    }
    else {
      variables.push(tmp1);
    }
    return tmp;
  }

arguments
  = id:ID rest:(COMMA ID)* {
    let args = [];
    args.push(id.value);
    rest.forEach(function(item){
      args.push(item[1].value);
    });
    return args;
  }

additive
  = left:multiplicative right:(ADDOP multiplicative)*
  {
    if(right.length == 0){
      return left;
    } else {
      let arr = {};
      let tmp = left;
      right.forEach(function(item){
        let newTmp = {
          "type": (item[0])[1],
          "left": tmp,
          "right": item[1]
        };
        tmp = newTmp;
      });
      return tmp;
    }
  }

multiplicative
  = left:primary right:(MULOP primary)*
  {
    if(right.length == 0){
      return left;
    } else {
      let arr = {};
      let tmp = left;
      right.forEach(function(item){
        let newTmp = {
          "type": (item[0])[1],
          "left": tmp,
          "right": item[1]
        };
        tmp = newTmp;
      });
      return tmp;
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
ID = _ id:$([a-z_]i$([a-z0-9_]i*)) { return {'type' : 'ID', 'value' : id}; }
ASSIGN = _ '=' _
