module lox.printast;
import std.stdio;

import lox.expr;

void printExpr(Expr* expr)
{

    switch (expr.type)
    {
    case ExprType.EXPR_LITERAL:
        writeln("\t\n[TYPE: ", expr.type, " VALUE: ", expr.literal.value.number, " ]");
        break;
    case ExprType.EXPR_BINARY:
        write("{\t");
        printExpr(expr.binary.left);
        writef(" [OPERATOR: %s ] ", expr.binary.operator.lexeme);
        printExpr(expr.binary.right);
        write("}\n");
        break;
    case ExprType.EXPR_UNARY:
        writefln("OPERATOR: %s", expr.binary.operator.lexeme);
        printExpr(expr.binary.right);
        break;
    case ExprType.EXPR_VARIABLE:
        writeln("\t\n[TYPE: ", expr.type, " NAME: ", expr.variable.name.lexeme, " ]");
        break;
    default:
        break;
    }

    return;

}
