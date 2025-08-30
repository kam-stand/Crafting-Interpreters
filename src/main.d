import std.stdio;
import core.memory;

import lox;
import lox.tokentype;
import lox.token;
import lox.expr;
import lox.astprinter;

int main(string[] args)
{
    if (args.length > 2)
    {
        writeln("Usage: jlox [script]");
        return -1;
    }

    else if (args.length == 2)
    {

        runFile(args[1]);

    }
    else
    {
        runPrompt();
    }

    Expr* expression = makeBinary(
        makeUnary(
            new Token(TokenType.MINUS, "-", LiteralType.NULL, Literal.init, 1),
            makeLiteralDouble(123)
    ),
    new Token(TokenType.STAR, "*", LiteralType.NULL, Literal.init, 1),
    makeGrouping(
        makeLiteralDouble(45.67)
    )
    );

    astPrinter(expression);

    return 0;

}
