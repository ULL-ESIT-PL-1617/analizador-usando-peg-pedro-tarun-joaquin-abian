# Analizador DPR usando PEGJS
---
* [Repositorio Github](//github.com/ULL-ESIT-PL-1617/analizador-usando-peg-pedro-tarun-joaquin-abian)
* [Descripcion de la Práctica](//casianorodriguezleon.gitbooks.io/ull-esit-1617/content/practicas/practicapegparser.html)

---

# Participantes

| Nombre | Correo Electrónico | Página personal Github |
| --- | --- | --- |
| Abián Torres Torres | alu0100887686@ull.edu.es | [alu0100887686](//alu0100887686.github.io/) |
| Tarun Mohandas Daryanani | alu0100891782@ull.edu.es | [alu0100891782](//alu0100891782.github.io/) |
| Pedro Miguel Lagüera Cabrera | alu0100891485@ull.edu.es | [plaguera](//plaguera.github.io/) |
| Joaquín Sanchiz Navarro | alu0100893755@ull.edu.es | [joaquinsanchiz](//joaquinsanchiz.github.io/) |

---
# Gramática:

```
start
  = statements

statements
  = statement+

statement
  = conditional
  / loop
  / call SC
  / assign SC
  / additive SC

conditional
  = IF condition THEN block

loop
  = WHILE condition block

call
  = ID LEFTPAR parameters? RIGHTPAR

parameters
  = parameter (COMMA parameter)*

parameter
  = call
  / additive

condition
  = LEFTPAR additive COMPARISON additive RIGHTPAR

assign
  = TYPE? ID ASSIGN function
  / TYPE? ID ASSIGN additive

function
  = FUNCTION LEFTPAR arguments? RIGHTPAR block

arguments
  = ID (COMMA ID)*

block
  = LEFTBRACE statements RIGHTBRACE

additive
  = multiplicative (ADDOP multiplicative)*
  / multiplicative

multiplicative
  = primary (MULOP primary)*
  / primary

primary
  = NUMBER
  / ID
  / LEFTPAR statements RIGHTPAR

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
COMPARISON = _ $[<>!=][=]? _
NUMBER = _ $[0-9]+ _
ID = _ $([a-z_]i$([a-z0-9_]i*)) _
TYPE = _ "var"i _
     / _ "const"i _
ASSIGN = _ "=" _

```

### Ejemplos de Uso

```
if (3 < 5) then {
  var a = 4;
}
b = function(hola, hola1, hola2, hola3){
  var c = 6;
  var d = 4;
  var a = 1;
};
b(1+2, 4/4);
while(a > 8) {
  var c = 6;
  var d = 7;
  var a = 1;
  const a = 56;
  b(3+2, 66*4, fun(1+2, 5, 67));
}
```
### Resultado de la Ejecución
 * Lista de variables y sus valores
 * Lista de constantes y sus valores
 * Lista de funciones y sus argumentos
 * Árbol de Análisis Sintáctico

### ¿Cómo Ejecutar el Programa?
```bash
[~/srcPLgrado/pegjs-calc-translate(master)]$ rake -T
rake clean    # rm grammar.js
rake compile  # Compile grammar.pegjs
rake exe      # Run main.js
rake run      # Run mainfromfile.js input1
```
