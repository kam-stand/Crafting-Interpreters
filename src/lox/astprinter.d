module lox.astprinter;
import std.stdio;
import lox.expr;
import lox.token;
import std.conv : to;

void astPrinter(Expr* expr)
{
    switch (expr.type)
    {
    case ExprType.EXPR_BINARY:
        write(" ( ");
        write(expr.binary.operator.lexeme);
        astPrinter(expr.binary.left);
        astPrinter(expr.binary.right);
        write(" )");
        break;

    case ExprType.EXPR_GROUPING:
        write(" ( ");
        write("group ");
        astPrinter(expr.grouping.expression);
        write(" )");
        break;

    case ExprType.EXPR_LITERAL:
        printLiteral(expr.literal);
        break;

    case ExprType.EXPR_UNARY:
        write(" ( ");
        write(expr.unary.operator.lexeme);
        astPrinter(expr.unary.right);
        write(" )");
        break;
        // TODO: Exhaust all other expression types
    default:
        writeln("undefined expression type");
        break;
    }
    write(" ");

}

void printLiteral(LiteralExpr* literal)
{
    write(literal.value.number);
}
