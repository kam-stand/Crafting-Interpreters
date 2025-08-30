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

immutable TokenType[string] keywords = [
    "and": TokenType.AND,
    "class": TokenType.CLASS,
    "else": TokenType.ELSE,
    "false": TokenType.FALSE,
    "for": TokenType.FOR,
    "fun": TokenType.FUN,
    "if": TokenType.IF,
    "nil": TokenType.NIL,
    "or": TokenType.OR,
    "print": TokenType.PRINT,
    "return": TokenType.RETURN,
    "super": TokenType.SUPER,
    "this": TokenType.THIS,
    "true": TokenType.TRUE,
    "var": TokenType.VAR,
    "while": TokenType.WHILE,
];

public string tokenTypeToString(TokenType type)
{
    import std.string : format;

    switch (type)
    {
    case TokenType.LEFT_PAREN:
        return "LEFT_PAREN";
    case TokenType.RIGHT_PAREN:
        return "RIGHT_PAREN";
    case TokenType.LEFT_BRACE:
        return "LEFT_BRACE";
    case TokenType.RIGHT_BRACE:
        return "RIGHT_BRACE";
    case TokenType.COMMA:
        return "COMMA";
    case TokenType.DOT:
        return "DOT";
    case TokenType.MINUS:
        return "MINUS";
    case TokenType.PLUS:
        return "PLUS";
    case TokenType.SEMICOLON:
        return "SEMICOLON";
    case TokenType.SLASH:
        return "SLASH";
    case TokenType.STAR:
        return "STAR";
    case TokenType.BANG:
        return "BANG";
    case TokenType.BANG_EQUAL:
        return "BANG_EQUAL";
    case TokenType.EQUAL:
        return "EQUAL";
    case TokenType.EQUAL_EQUAL:
        return "EQUAL_EQUAL";
    case TokenType.GREATER:
        return "GREATER";
    case TokenType.GREATER_EQUAL:
        return "GREATER_EQUAL";
    case TokenType.LESS:
        return "LESS";
    case TokenType.LESS_EQUAL:
        return "LESS_EQUAL";
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
