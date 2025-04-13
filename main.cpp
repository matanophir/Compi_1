#include "tokens.hpp"
#include "output.hpp"

int main() {
    enum tokentype token;

    // read tokens until the end of file is reached
    while ((token = static_cast<tokentype>(yylex()))) {
        // your code here
        switch (token)
        {
        case -1: // illegal char
            output::errorUnknownChar(yytext[0]);
            break;
        case -2: // unclosed string
            output::errorUnclosedString();
            break;
        case -3: // undefined escape
            output::errorUndefinedEscape(yytext);
            break;
        case COMMENT:
            output::printToken(yylineno, COMMENT, "");
            break;
        default:
            output::printToken(yylineno, (tokentype)token, yytext);
            break;
        }
    }
    return 0;
}