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

statements
  = statements:statement+ {
      var result = [];
      statements.forEach(function(item){
        result.push(item);
      });
      return result;
    }

statement
  = c:conditional     { return c; }
  / l:loop            { return l; }
  / f:call        SC  { return f; }
  / a:assign      SC  { return a; }
  / o:additive    SC  { return o; }

conditional
  = IF cond:condition THEN content:block {
      return {
        "type": "IF",
        "condition": cond,
        "content": content
      };
    }

loop
  = WHILE cond:condition content:block {
      return {
        "type": "WHILE",
        "condition": cond,
        "content": content
      };
    }

call
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
  = param:call      { return param; }
  / param:additive  { return param; }

condition
  = LEFTPAR left:additive comp:COMPARISON right:additive RIGHTPAR {
      return {
        "type": comp,
        "left": left,
        "right": right
      };
    }

assign
  = type:TYPE? id:ID ASSIGN funct:function {
      functions[id.value] = funct["arguments"];
      return {
        "type": "=",
        "left": id,
        "right": funct
      };
    }
  / type:TYPE? id:ID ASSIGN result:additive {
      if(type === "const")
        constants[id.value] = result.value;
      else if(type === "var")
        variables[id.value] = result.value;
      return {
        "type": "=",
        "left": id,
        "right": result
      };
    }

function
  = FUNCTION LEFTPAR args:arguments? RIGHTPAR block:block {
      return {
        "type": "FUNCTION",
        "arguments": args,
        "content": block
      };
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

block
  = LEFTBRACE statements:statements RIGHTBRACE {
      return statements;
    }

additive
  = left:multiplicative right:(ADDOP multiplicative)* {
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
  = left:primary right:(MULOP primary)* {
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
TYPE = _ v:"var"i _   { return v; }
     / _ c:"const"i _ { return c; }
ASSIGN = _ "=" _
