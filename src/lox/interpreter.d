module lox.interpreter;
import lox.expr;
import lox.token;
import lox.tokentype;
import lox.value;

class Interpreter
{
    // TODO: create VALUE struct which contains the final literal evaluation
    // TODO: CheckNumberOperands()

    Value evaluateExpression(Expr* expression)
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

    Value evalLiteral(LiteralExpr* expr)
    {
        final switch (expr.value.type)
        {
        case LiteralType.NUMBER:
            // return cast(double) expr.value.number;
            return value(expr.value.number);
        case LiteralType.BOOLEAN:
            // return expr.value.boolean ? 1.0 : 0.0;
            return value(expr.value.boolean);
        case LiteralType.NULL:
            // return 0.0;
            return value();

        case LiteralType.STRING:
            // assert(0, "Strings not yet supported in evaluation");
            return value(expr.value.str);
        }
    }

    Value evalUnary(UnaryExpr* expr)
    {
        Value right = evaluateExpression(expr.right);
        Token* op = expr.operator;

        switch (op.type)
        {
        case TokenType.MINUS:
            return value(-right.number);
        case TokenType.BANG:
            bool isFalsey = (right.type == LiteralType.NULL) || (
                right.type == LiteralType.BOOLEAN && !right.val);
            return value(!isFalsey);
        default:
            assert(0, "Unknown unary operator");
        }
    }

    bool isEqual(Value a, Value b)
    {
        if (a.type != b.type)
            return false;
        final switch (a.type)
        {
        case LiteralType.NUMBER:
            return a.number == b.number;
        case LiteralType.BOOLEAN:
            return a.val == b.val;
        case LiteralType.STRING:
            return a.str == b.str;
        case LiteralType.NULL:
            return true;
        }
        return false;
    }

    Value evalBinary(BinaryExpr* expr)
    {
        auto lhs = evaluateExpression(expr.left);
        auto rhs = evaluateExpression(expr.right);

        switch (expr.operator.type)
        {
        case TokenType.PLUS:
            if (lhs.type == LiteralType.NUMBER && rhs.type == LiteralType.NUMBER)
                return value(lhs.number + rhs.number);
            else if (lhs.type == LiteralType.STRING && rhs.type == LiteralType.STRING)
                return value(lhs.str ~ rhs.str);
            else
                assert(0, "Operands must be two numbers or two strings");

        case TokenType.MINUS:
            assert(lhs.type == LiteralType.NUMBER && rhs.type == LiteralType.NUMBER, "Operands must be numbers");
            return value(lhs.number - rhs.number);

        case TokenType.STAR:
            assert(lhs.type == LiteralType.NUMBER && rhs.type == LiteralType.NUMBER, "Operands must be numbers");
            return value(lhs.number * rhs.number);

        case TokenType.SLASH:
            assert(lhs.type == LiteralType.NUMBER && rhs.type == LiteralType.NUMBER, "Operands must be numbers");
            return value(lhs.number / rhs.number);

        case TokenType.GREATER:
            assert(lhs.type == LiteralType.NUMBER && rhs.type == LiteralType.NUMBER, "Operands must be numbers");
            return value(lhs.number > rhs.number);

        case TokenType.GREATER_EQUAL:
            assert(lhs.type == LiteralType.NUMBER && rhs.type == LiteralType.NUMBER, "Operands must be numbers");
            return value(lhs.number >= rhs.number);

        case TokenType.LESS:
            assert(lhs.type == LiteralType.NUMBER && rhs.type == LiteralType.NUMBER, "Operands must be numbers");
            return value(lhs.number < rhs.number);

        case TokenType.LESS_EQUAL:
            assert(lhs.type == LiteralType.NUMBER && rhs.type == LiteralType.NUMBER, "Operands must be numbers");
            return value(lhs.number <= rhs.number);

        case TokenType.EQUAL_EQUAL:
            return value(isEqual(lhs, rhs));

        case TokenType.BANG_EQUAL:
            return value(!isEqual(lhs, rhs));

        default:
            assert(0, "Unknown binary operator");
        }
    }

    Value evalGrouping(GroupingExpr* expr)
    {
        return evaluateExpression(expr.expression);
    }

}
