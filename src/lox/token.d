module lox.token;
import lox.tokentype;

struct Token
{
    TokenType type;
    string lexeme;
    union literal
    {
        string str;
        double number;
    }

    int line;

}
