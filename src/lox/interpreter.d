module lox.interpreter;
import lox.expr;
import lox.token;
import lox.tokentype;

class Interpreter
{
    // TODO: create VALUE struct which contains the final literal evaluation
    // TODO: CheckNumberOperands()

    double evaluateExpression(Expr* expression)
    {
        switch (expression.type)
        {
        case ExprType.EXPR_LITERAL:
            return evalLiteral(expression.literal);

        case ExprType.EXPR_UNARY:
            return evalUnary(expression.unary);

        case ExprType.EXPR_BINARY:
            return evalBinary(expression.binary);

        case ExprType.EXPR_GROUPING:
            return evalGrouping(expression.grouping);

        default:
            assert(0, "Cannot evaluate expression");
        }
    }

    double evalLiteral(LiteralExpr* expr)
    {
        final switch (expr.value.type)
        {
        case LiteralType.NUMBER:
            return cast(double) expr.value.number;
        case LiteralType.BOOLEAN:
            return expr.value.boolean ? 1.0 : 0.0;
        case LiteralType.NULL:
            return 0.0;
        case LiteralType.STRING:
            assert(0, "Strings not yet supported in evaluation");
        }
    }

    double evalUnary(UnaryExpr* expr)
    {
        double right = evaluateExpression(expr.right);
        Token* op = expr.operator;

        switch (op.type)
        {
        case TokenType.MINUS:
            return -right;
        case TokenType.BANG:
            return (right == 0) ? 1.0 : 0.0;
        default:
            assert(0, "Unknown unary operator");
        }
    }

    double evalBinary(BinaryExpr* expr)
    {
        auto lhs = evaluateExpression(expr.left);
        auto rhs = evaluateExpression(expr.right);

        switch (expr.operator.type)
        {
            // TODO: checkNumberOperand through value struct
        case TokenType.PLUS:
            return lhs + rhs;
        case TokenType.MINUS:
            return lhs - rhs;
        case TokenType.STAR:
            return lhs * rhs;
        case TokenType.SLASH:
            return lhs / rhs;
        case TokenType.GREATER:
            return (lhs > rhs) ? 1.0 : 0.0;
        case TokenType.GREATER_EQUAL:
            return (lhs >= rhs) ? 1.0 : 0.0;
        case TokenType.LESS:
            return (lhs < rhs) ? 1.0 : 0.0;
        case TokenType.LESS_EQUAL:
            return (lhs <= rhs) ? 1.0 : 0.0;
        case TokenType.EQUAL_EQUAL:
            return (lhs == rhs) ? 1.0 : 0.0;
        case TokenType.BANG_EQUAL:
            return (lhs != rhs) ? 1.0 : 0.0;

        default:
            assert(0, "Unknown binary operator");
        }
    }

    double evalGrouping(GroupingExpr* expr)
    {
        return evaluateExpression(expr.expression);
    }
}
