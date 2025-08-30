module lox.printast;
import std.stdio;

import lox.expr;

void printExpr(Expr* expr)
{

    switch (expr.type)
    {
    case ExprType.EXPR_LITERAL:
        writeln("VALUE: ", expr.literal.value.number);
        break;
    case ExprType.EXPR_BINARY:
        printExpr(expr.binary.left);
        writefln("OPERATOR: %s", expr.binary.operator.lexeme);
        printExpr(expr.binary.right);
        break;
    default:
        break;
    }

    return;

}
