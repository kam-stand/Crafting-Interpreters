module lox.token;
import lox.tokentype;
import std.variant;
import std.format;

struct Token
{
    TokenType type;
    string lexeme;
    union Literal
    {
        string str;
        double number;
    }

    Literal literal;
    int line;

}
