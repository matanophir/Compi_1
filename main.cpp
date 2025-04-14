#include "tokens.hpp"
#include "output.hpp"
#include <iostream>
#include <string>

using namespace std;

int main() {
    enum tokentype token;

    // read tokens until the end of file is reached
    while ((token = static_cast<tokentype>(yylex()))) {
        // your code here
        switch (token)
        {
        case STRING: {
            string parsed;
            string str(yytext);

            for (size_t i = 1; i < str.length() - 1; i++)
            { // skip first and last "
                if (str[i] == '\\')
                {
                    i++; // look at next char
                    switch (str[i])
                    {
                    case 'n':
                        parsed += '\n';
                        break;
                    case 'r':
                        parsed += '\r';
                        break;
                    case 't':
                        parsed += '\t';
                        break;
                    case '0':
                        parsed += '\0';
                        break;
                    case '\\':
                        parsed += '\\';
                        break;
                    case '\"':
                        parsed += '\"';
                        break;
                    case 'x':
                    {
                        string hex = str.substr(i + 1, 2);
                        char c = (char)stoi(hex, nullptr, 16);
                        parsed += c;
                        i += 2; // skip the 2 hex digits
                        break;
                    }
                    default:
                        cout << "Unknown escape sequence: \\" << str[i] << endl;
                        parsed += str[i]; // shouldn't happen
                    }
                }
                else
                {
                    parsed += str[i];
                }
            }

            output::printToken(yylineno, STRING, parsed.c_str());
            break;
        }

        case COMMENT:
            output::printToken(yylineno, COMMENT, "//");
            break;
        default:
            output::printToken(yylineno, (tokentype)token, yytext);
            break;
        }
    }
    return 0;
}