module lox.error;
import std.stdio;
import lox.token;
import lox.tokentype;
import lox.value;

void error(int line, string message)
{
    report(line, "", message);
}

void report(int line, string where, string message)
{
    writefln("[line %s] Error%s: %s", line, where, message);
}

// ParseError should be an Exception, not a struct
class ParseError : Exception
{
    Token* token;

    this(Token* token, string message)
    {
        super(message);
        this.token = token;
    }
}

ParseError parseError(Token* token, string message)
{
    if (token.type == TokenType.EOF)
    {
        report(token.line, " at end", message);
    }
    else
    {
        report(token.line, " at '" ~ token.lexeme ~ "'", message);
    }

    return new ParseError(token, message);
}

class RuntimeError : Exception
{
    Token* token;

    this(Token* token, string message)
    {
        super(message);
        this.token = token;

    }
}

RuntimeError runtimeError(Token* token, string message)
{
    if (token.type == TokenType.EOF)
    {
        report(token.line, " at end", message);
    }
    else
    {
        report(token.line, " at '" ~ token.lexeme ~ "'", message);
    }

    return new RuntimeError(token, message);
}

class ReturnException : Exception
{
    Value value;

    this(Value value)
    {
        super("Return");
        this.value = value;
    }
}
