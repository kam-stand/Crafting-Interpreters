module lox.token;
import lox.tokentype;
import std.variant;
import std.format;
import std.stdio;
import std.conv : to;

enum LiteralType
{
    STRING,
    NUMBER,
    BOOLEAN,
    NULL
}

struct Literal
{

    LiteralType type;

    union
    {

        string str;
        double number;
        bool boolean;
    }

}

struct Token
{
    TokenType type;
    string lexeme;
    Literal* literal;
    int line;

}

Literal* createLiteral(string s)
{
    auto lit = new Literal;
    lit.type = LiteralType.STRING;
    lit.str = s;
    return lit;
}

Literal* createLiteral(double n)
{
    auto lit = new Literal;
    lit.type = LiteralType.NUMBER;
    lit.number = n;
    return lit;
}

Literal* createLiteral(bool b)
{
    auto lit = new Literal;
    lit.type = LiteralType.BOOLEAN;
    lit.boolean = b;
    return lit;
}

Literal* createLiteral() // null literal
{
    auto lit = new Literal;
    lit.type = LiteralType.NULL;
    return lit;
}

Token* createToken(string lexeme, TokenType type, int line, Literal* lit = null)
{
    if (lit is null)
        lit = createLiteral(); // default to NULL literal
    return new Token(type, lexeme, lit, line);
}

string literalToString(Literal* lit)
{
    if (lit is null)
        return "null";

    final switch (lit.type)
    {
    case LiteralType.STRING:
        return format("\"%s\"", lit.str);
    case LiteralType.NUMBER:
        return lit.number.to!string;
    case LiteralType.BOOLEAN:
        return lit.boolean.to!string;
    case LiteralType.NULL:
        return "null";
    }

    return "unknown"; // fallback
}

void printToken(Token* t)
{
    auto literalStr = t.literal ? literalToString(t.literal) : "null";
    writeln("TOKEN: ", tokenTypeToString(t.type),
        ", Lexeme: '", t.lexeme,
        "', Literal: ", literalStr,
        ", Line: ", t.line);
}
