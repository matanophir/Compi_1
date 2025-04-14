%{
#include "tokens.hpp"
#include "output.hpp"
%}

%option noyywrap
%option yylineno


DIGIT        [0-9]
LETTER       [a-zA-Z]
ID           {LETTER}({LETTER}|{DIGIT})*
NUM          0|([1-9]{DIGIT}*)
NUM_B        {NUM}b
WHITESPACE   [ \t\r\n]
COMMENT      \/\/[^\r\n]*

%%

{WHITESPACE}     { /* skip */ }

"void"           { return VOID; }
"int"            { return INT; }
"byte"           { return BYTE; }
"bool"           { return BOOL; }
"and"            { return AND; }
"or"             { return OR; }
"not"            { return NOT; }
"true"           { return TRUE; }
"false"          { return FALSE; }
"return"         { return RETURN; }
"if"             { return IF; }
"else"           { return ELSE; }
"while"          { return WHILE; }
"break"          { return BREAK; }
"continue"       { return CONTINUE; }

";"              { return SC; }
","              { return COMMA; }
"("              { return LPAREN; }
")"              { return RPAREN; }
"{"              { return LBRACE; }
"}"              { return RBRACE; }
"["              { return LBRACK; }
"]"              { return RBRACK; }
"="              { return ASSIGN; }
"=="|"!="|"<="|">="|"<"|">" { return RELOP; }
"+"|"-"|"*"|"/"  { return BINOP; }

{COMMENT}        { return COMMENT; }

{NUM_B}          { return NUM_B; }
{NUM}            { return NUM; }
{ID}             { return ID; }
\"([^\"\n]*)\" { return STRING; }

\"([^\"\n]*)(\n)?  { output::errorUnclosedString(); }
.                 { output::errorUnknownChar(yytext[0]); }

%%

