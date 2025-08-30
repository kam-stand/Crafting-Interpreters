module lox.scanner;
import lox.token;
import lox.tokentype;

import std.string;
import std.ascii;
import std.stdio;
import std.conv;

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
        Token t;
        t.type = TokenType.EOF;
        t.line = line;
        t.lexeme = "";
        tokens ~= t;
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
        case '!':
            addToken((match('=')) ? TokenType.BANG_EQUAL : TokenType.BANG);
            break;
        case '=':
            addToken((match('=')) ? TokenType.EQUAL_EQUAL : TokenType.EQUAL);
            break;
        case '<':
            addToken((match('=')) ? TokenType.LESS_EQUAL : TokenType.LESS);
            break;
        case '>':
            addToken((match('=')) ? TokenType.GREATER_EQUAL : TokenType.GREATER);
            break;
        case '/':
            if (match('/'))
            {
                while (peek() != '\n' && !isAtEnd())
                    advance();
            }
            else if (match('*'))
            {
                // block comment
                while (!(peek() == '*' && peekNext() == '/') && !isAtEnd())
                {
                    if (peek() == '\n')
                        line++;
                    advance();
                }

                if (isAtEnd())
                {
                    writeln("Unterminated block comment at line ", line);
                    return;
                }

                // consume the closing */
                advance(); // consume '*'
                advance(); // consume '/'
            }
            else
            {
                addToken(TokenType.SLASH);
            }
            break;
        case ' ':
        case '\r':
        case '\t':
            break;
        case '\n':
            line++;
            break;
        case '"':
            scanString();
            break;
        default:
            if (isDigit(c))
            {
                scanNumber();
            }
            else if (isAlpha(c))
            {
                scanIdentifier();
            }
            else
            {
                writefln("[Line: %d] Unexpected character", line);
            }
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

    void addToken(TokenType type, string value)
    {
        Token t;
        t.type = type;
        t.line = line;
        t.lexeme = cast(string) source[start .. current];
        t.literal_type = LiteralType.STRING;
        t.literal.str = value;
        tokens ~= t;
    }

    void addToken(TokenType type, double value)
    {
        Token t;
        t.type = type;
        t.line = line;
        t.lexeme = cast(string) source[start .. current];
        t.literal_type = LiteralType.NUMBER;
        t.literal.number = value;
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

    char peekNext()
    {
        return (current + 1 >= source.length) ? '\0' : source[current + 1];
    }

    void printTokens()
    {
        foreach (Token t; tokens)
        {
            writefln("TOKEN: %s, Lexeme: %s, [Line: %d]", tokenTypeToString(t.type), t.lexeme, t
                    .line);
        }
    }

    bool match(char expected)
    {
        if (!isAtEnd() && source[current] == expected)
        {
            current++;
            return true;
        }
        return false;
    }

    void scanString()
    {
        while (peek() != '"' && !isAtEnd())
        {
            if (peek() == '\n')
                line++;
            advance();
        }

        if (isAtEnd())
        {
            writeln("Unterminated string at line ", line);
            return;
        }

        advance(); // consume the closing "

        // literal value (without quotes)
        string value = cast(string) source[start + 1 .. current - 1];

        // lexeme comes from addToken, which uses [start..current]
        addToken(TokenType.STRING, value);
    }

    void scanNumber()
    {
        while (isDigit(peek()))
        {
            advance();
        }
        if (peek() == '.' && isDigit(peekNext()))
        {
            advance();
            while (isDigit(peek()))
                advance();
        }
        string numText = cast(string) source[start .. current];
        double value = to!double(numText);
        addToken(TokenType.NUMBER, value);
    }

    void scanIdentifier()
    {
        while (isAlphaNum(peek()))
            advance();

        string text = cast(string) source[start .. current];

        TokenType type;
        if (auto val = text in keywords)
            type = *val; // keyword found
        else
            type = TokenType.IDENTIFIER;

        addToken(type);
    }
}
