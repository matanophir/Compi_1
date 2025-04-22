%{
#include "tokens.hpp"
#include "output.hpp"
#include <iostream>
using namespace std;
%}

%option noyywrap
%option yylineno


digit        [0-9]
letter       [a-zA-Z]
id           {letter}({letter}|{digit})*
num          0|([1-9]{digit}*)
num_b        {num}b
whitespace   [ \t\r\n]
comment      \/\/[^\r\n]*
string_content (([^\\\"\n\r])|(\\([\\\"nrt0]))|(\\.))*

%%

{whitespace}     { /* skip */ }

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

{comment}        { return COMMENT; }

{num_b}          { return NUM_B; }
{num}            { return NUM; }
{id}             { return ID; }

\"{string_content}\" { return STRING; }
\"{string_content}  { output::errorUnclosedString(); }

.                 { output::errorUnknownChar(yytext[0]); }

%%

