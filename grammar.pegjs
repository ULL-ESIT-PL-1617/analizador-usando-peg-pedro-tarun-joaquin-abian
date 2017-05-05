{
  var util = require('util');
  var variables = [];
  var constants = [];
  var functions = [];
  var make_var = function(id, value) {
    return {
      "id": id,
      "value": value
    };
  }
  var make_funct = function(id, params) {
    return {
      "id": id,
      "parameters": params
    };
  }
}

start
  = stat:statements
  { console.log("Constants: " + util.inspect(constants));
    console.log("Variables: " + util.inspect(variables));
    console.log("Functions: " + util.inspect(functions)); return stat; }

statements =
      left:statement right:(SC statement)* SC?
      {
        if(right.length == 0)
          return left;
        var result = [];
        result.push(left);
        right.forEach(function(item){
          result.push(item[1]);
        });
        return result;
      }

statement =
      // IF COND THEN STATEMENT
      IF cond:condition THEN LEFTBRACE content:statements RIGHTBRACE {
        return {
          "type": "IF",
          "condition": cond,
          "content": content
        };
      }
      // WHILE LOOP
      / WHILE cond:condition LEFTBRACE content:statements RIGHTBRACE {
        return {
          "type": "WHILE",
          "condition": cond,
          "content": content
        };
      }
      // FUNCTION CALL
      / functCall:functionCall  { return functCall;   }
      // ASSIGNMENT
      / assignment:assign       { return assignment;  }
      // ARITHMETIC OPERATION
      / operation:additive      { return operation;   }

functionCall
  = id:ID LEFTPAR param:parameters? RIGHTPAR {
    return {
      "type": "FUNCTION_CALL",
      "id": id,
      "paramaters": param
    }
  }

parameters
  = first:parameter rest:(COMMA parameter)* {
    let params = [];
    params.push(first);
    rest.forEach(function(item){
      params.push(item[1]);
    });
    return params;
  }

parameter
  = param:functionCall  { return param; }
    / param:additive    { return param; }

condition
  = LEFTPAR left:additive comp:COMPARISON right:additive RIGHTPAR {
    return {
      "type": comp,
      "left": left,
      "right": right
    };
  }

assign
  = id:ID ASSIGN FUNCTION LEFTPAR args:arguments? RIGHTPAR LEFTBRACE st:statements RIGHTBRACE {
    functions[id.value] = args;
    let funct = {
      "type": "FUNCTION",
      "arguments": args,
      "content": st
    };
    return {
      "type": "=",
      "left": id,
      "right": funct
    };
  }
  / cons:CONST? id:ID ASSIGN result:additive {
    let tmp = {
      "type": "=",
      "left": id,
      "right": result
    };
    if(cons != null)
      constants[id.value] = result.value;
    else
      variables[id.value] = result.value;
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
  / multiplicative

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
  / primary

primary
  = num:NUMBER                        { return num;   }
  / id:ID                             { return id;    }
  / LEFTPAR stat:statements RIGHTPAR  { return stat;  }

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
LEFTBRACE = _"{"_
RIGHTBRACE  = _"}"_
FUNCTION = _"function"_
IF = _"if"_
THEN = _"then"_
WHILE = _"while"_
CONST = _"const"_
SC = _";"_
COMPARISON = _ comp:$[<>!=][=]? _ { return comp ; }
NUMBER = _ digits:$[0-9]+ _ { return {'type' : 'NUM', 'value' : parseInt(digits, 10)}; }
ID = _ id:$([a-z_]i$([a-z0-9_]i*)) _ { return {'type' : 'ID', 'value' : id }; }
ASSIGN = _ '=' _
