import std.stdio;
import core.memory;

import lox;
import lox.tokentype;
import lox.token;
import lox.expr;
import lox.printast;

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

    Expr* left = cast(Expr*) GC.malloc(Expr.sizeof);
    left.type = ExprType.EXPR_LITERAL;
    left.literal.value.number = 12;
    // printExpr(left);

    Token* operator = cast(Token*) GC.malloc(Token.sizeof);
    operator.line = 1;
    operator.lexeme = "+";
    operator.type = TokenType.PLUS;

    Expr* right = cast(Expr*) GC.malloc(Expr.sizeof);
    right.type = ExprType.EXPR_LITERAL;
    right.literal.value.number = 12;
    // printExpr(right);

    BinaryExpr* binaryExpr = cast(BinaryExpr*) GC.malloc(BinaryExpr.sizeof);
    binaryExpr.left = left;
    binaryExpr.right = right;
    binaryExpr.operator = operator;

    Expr* expr = cast(Expr*) GC.malloc(Expr.sizeof);
    expr.type = ExprType.EXPR_BINARY;
    expr.binary = binaryExpr;

    printExpr(expr);
    return 0;

}
