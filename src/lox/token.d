module lox.token;
import lox.tokentype;
import std.variant;
import std.format;

union Literal
{
    string str;
    double number;
}

struct Token
{
    TokenType type;
    string lexeme;

    Literal literal;
    int line;

}
