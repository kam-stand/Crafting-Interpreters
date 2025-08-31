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
        write("(");
        write(expr.binary.operator.lexeme, " ");
        astPrinter(expr.binary.left);
        write(" ");
        astPrinter(expr.binary.right);
        write(")");
        break;

    case ExprType.EXPR_GROUPING:
        write("(group ");
        astPrinter(expr.grouping.expression);
        write(")");
        break;

    case ExprType.EXPR_LITERAL:
        write(literalToString(expr.literal.value));
        break;

    case ExprType.EXPR_UNARY:
        write("(");
        write(expr.unary.operator.lexeme, " ");
        astPrinter(expr.unary.right);
        write(")");
        break;

    default:
        writeln();
        write("undefined");
        break;
    }
}

void printLiteral(LiteralExpr* literal)
{
    auto lit = literal.value;
    final switch (lit.type)
    {
    case LiteralType.STRING:
        write(lit.str);
        break;
    case LiteralType.NUMBER:
        write(lit.number);
        break;
    case LiteralType.BOOLEAN:
        write(lit.boolean ? "true" : "false");
        break;
    case LiteralType.NULL:
        write("nil"); // or "null"
        break;
    }
}
