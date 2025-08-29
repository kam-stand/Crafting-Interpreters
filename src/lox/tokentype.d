module lox.tokentype;

enum TokenType
{
    // Single-character tokens.
    LEFT_PAREN,
    RIGHT_PAREN,
    LEFT_BRACE,
    RIGHT_BRACE,
    COMMA,
    DOT,
    MINUS,
    PLUS,
    SEMICOLON,
    SLASH,
    STAR,
    // One or two character tokens.
    BANG,
    BANG_EQUAL,
    EQUAL,
    EQUAL_EQUAL,
    GREATER,
    GREATER_EQUAL,
    LESS,
    LESS_EQUAL,
    // Literals.
    IDENTIFIER,
    STRING,
    NUMBER,
    // Keywords.
    AND,
    CLASS,
    ELSE,
    FALSE,
    FUN,
    FOR,
    IF,
    NIL,
    OR,
    PRINT,
    RETURN,
    SUPER,
    THIS,
    TRUE,
    VAR,
    WHILE,
    EOF
}

public string tokenTypeToString(TokenType type)
{
    import std.string : format;

    switch (type)
    {
    case TokenType.LEFT_PAREN:
        return "(";
    case TokenType.RIGHT_PAREN:
        return ")";
    case TokenType.LEFT_BRACE:
        return "{";
    case TokenType.RIGHT_BRACE:
        return "}";
    case TokenType.COMMA:
        return ",";
    case TokenType.DOT:
        return ".";
    case TokenType.MINUS:
        return "-";
    case TokenType.PLUS:
        return "+";
    case TokenType.SEMICOLON:
        return ";";
    case TokenType.SLASH:
        return "/";
    case TokenType.STAR:
        return "*";
    case TokenType.BANG:
        return "!";
    case TokenType.BANG_EQUAL:
        return "!=";
    case TokenType.EQUAL:
        return "=";
    case TokenType.EQUAL_EQUAL:
        return "==";
    case TokenType.GREATER:
        return ">";
    case TokenType.GREATER_EQUAL:
        return ">=";
    case TokenType.LESS:
        return "<";
    case TokenType.LESS_EQUAL:
        return "<=";
    case TokenType.IDENTIFIER:
        return "IDENTIFIER";
    case TokenType.STRING:
        return "STRING";
    case TokenType.NUMBER:
        return "NUMBER";
    case TokenType.AND:
        return "and";
    case TokenType.CLASS:
        return "class";
    case TokenType.ELSE:
        return "else";
    case TokenType.FALSE:
        return "false";
    case TokenType.FUN:
        return "fun";
    case TokenType.FOR:
        return "for";
    case TokenType.IF:
        return "if";
    case TokenType.NIL:
        return "nil";
    case TokenType.OR:
        return "or";
    case TokenType.PRINT:
        return "print";
    case TokenType.RETURN:
        return "return";
    case TokenType.SUPER:
        return "super";
    case TokenType.THIS:
        return "this";
    case TokenType.TRUE:
        return "true";
    case TokenType.VAR:
        return "var";
    case TokenType.WHILE:
        return "while";
    case TokenType.EOF:
        return "EOF";
    default:
        return "NOT SUPPORTED";
    }
}
