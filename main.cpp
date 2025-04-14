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
        case STRING:
        {
            string raw(yytext);
            string parsed;

            // Remove the quotes
            for (size_t i = 1; i < raw.length() - 1; i++)
            {
                if (raw[i] == '\\')
                {
                    i++;
                    if (i >= raw.length() - 1)
                    { // string ends with backslash
                        output::errorUnknownChar('\\');
                    }

                    switch (raw[i])
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
                        string hexDigits;
                        if (i + 2 >= raw.length() - 1)
                        {                                  // Not enough chars for 2 hex
                            hexDigits = raw.substr(i - 1); // include \x
                            output::errorUndefinedEscape(hexDigits.c_str());
                        }
                        if (isxdigit(raw[i + 1]) && isxdigit(raw[i + 2]))
                        {
                            hexDigits = raw.substr(i + 1, 2);
                            char c = (char)stoi(hexDigits, nullptr, 16);
                            parsed += c;
                            i += 2; // skip hex digits
                        }
                        else
                        {
                            hexDigits = raw.substr(i - 1, 3); // \x + bad char(s)
                            output::errorUndefinedEscape(hexDigits.c_str());
                        }
                        break;
                    }

                    default:
                    {
                        output::errorUndefinedEscape(string(1,raw[i]).c_str());
                    }
                    }
                }
                else
                {
                    if (raw[i] >= 0x20 && raw[i] <= 0x7E)
                    { // printable ASCII
                        parsed += raw[i];
                    }
                    else
                    {
                        output::errorUnknownChar(raw[i]);
                    }
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