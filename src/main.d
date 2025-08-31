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

    // Expr* expression = makeBinary(
    //     makeUnary(
    //         new Token(TokenType.MINUS, "-", createLiteral(), 1),
    //         makeLiteral!double(123.0)
    // ),
    // new Token(TokenType.STAR, "*", createLiteral(), 1),
    // makeGrouping(
    //     makeLiteral!double(45.67)
    // )
    // );

    // astPrinter(expression);

    return 0;

}
