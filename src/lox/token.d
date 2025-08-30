module lox.token;
import lox.tokentype;
import std.variant;
import std.format;

enum LiteralType
{
    STRING,
    NUMBER,
    BOOLEAN,
    NULL
}

union Literal
{
    string str;
    double number;
    bool boolean;
}

struct Token
{
    TokenType type;
    string lexeme;
    LiteralType literal_type;
    Literal literal;
    int line;

}
