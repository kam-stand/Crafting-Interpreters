module lox.scanner;
import lox.token;
import lox.tokentype;

import std.string;

import std.stdio;

void printContent(byte[] source)
{
    writeln(source);
}

class Scanner
{
    byte[] source;
    int line = 1;
    int current;
    int start;
    Token[] tokens;
    this(byte[] source)
    {
        this.source = source;
        this.current = 0;
        this.start = 0;
    }

    Token[] scanTokens()
    {
        while (!isAtEnd())
        {
            start = current;
            scanToken();
        }

        return tokens;
    }

    void scanToken()
    {
        char c = advance();
        switch (c)
        {
        case '(':
            addToken(TokenType.LEFT_PAREN);
            break;
        case ')':
            addToken(TokenType.RIGHT_PAREN);
            break;
        case '{':
            addToken(TokenType.LEFT_BRACE);
            break;
        case '}':
            addToken(TokenType.RIGHT_BRACE);
            break;
        case ',':
            addToken(TokenType.COMMA);
            break;
        case '.':
            addToken(TokenType.DOT);
            break;
        case '-':
            addToken(TokenType.MINUS);
            break;
        case '+':
            addToken(TokenType.PLUS);
            break;
        case ';':
            addToken(TokenType.SEMICOLON);
            break;
        case '*':
            addToken(TokenType.STAR);
            break;
        default:
            break;
        }
    }

    void addToken(TokenType type)
    {
        string text = cast(string) source[start .. current]; // slice from start to current
        Token t;
        t.type = type;
        t.line = line;
        t.lexeme = text;
        tokens ~= t;
    }

    bool isAtEnd()
    {
        return current >= source.length;
    }

    char advance()
    {
        return source[current++];
    }

    char peek()
    {
        return isAtEnd() ? '\0' : source[current];
    }

    void printTokens()
    {
        foreach (Token t; tokens)
        {
            writefln("TOKEN: %s, Lexeme: %s, [Line: %d]", tokenTypeToString(t.type), t.lexeme, t
                    .line);
        }
    }

}
