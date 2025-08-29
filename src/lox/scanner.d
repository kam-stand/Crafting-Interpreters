module lox.scanner;
import lox.token;
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
    this(byte[] source)
    {
        this.source = source;
        this.current = 0;
        this.start = 0;
    }

    Token[] scanTokens(byte[] source)
    {

        return null;
    }

    bool isAtEnd()
    {
        return current >= source.length;
    }

    char advance()
    {
        return source[current++];
    }

    char peak()
    {
        return isAtEnd() ? '\0' : source[current];
    }

}
