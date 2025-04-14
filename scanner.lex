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

PRINTABLE_NO_QUOTE_BACKSLASH  [\x20-\x21]|[\x23-\x5B]|[\x5D-\x7E]
ESC_SEQ                       \\[\\\"nrt0]
HEX_ESC                      \\x[0-9a-fA-F]{2}
STRING_CHAR                  ({PRINTABLE_NO_QUOTE_BACKSLASH}|{ESC_SEQ}|{HEX_ESC})

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
\"{STRING_CHAR}*\"   { return STRING; }


\"([^\"\n]*)\n  { output::errorUnclosedString(); }
\"([^\"\\]|\\[^\"nrt0x])*\\[^\"nrt0x]([^\"\n]*)\"  { output::errorUndefinedEscape(yytext); }
.                 { output::errorUnknownChar(yytext[0]); }

%%

