module lox.expr;
import lox.token;
import std.variant;

struct BinaryExpr
{
    Expr* left;
    Token* operator;
    Expr* right;
}

struct UnaryExpr
{
    Token* operator;
    Expr* right;
}

struct GroupingExpr
{
    Expr* expression;
}

struct LiteralExpr
{
    Literal* value;
}

struct AssignExpr
{
    Token* name;
    Expr* value;
}

struct CallExpr
{
    Expr* callee;
    Token* paren;
    Expr*[] arguments;
}

struct VariableExpr
{
    Token* name;
}

enum ExprType
{
    EXPR_BINARY,
    EXPR_UNARY,
    EXPR_LITERAL,
    EXPR_GROUPING,
    EXPR_ASSIGN,
    EXPR_CALL,
    EXPR_VARIABLE
}

struct Expr
{
    ExprType type;
    union
    {
        BinaryExpr* binary;
        UnaryExpr* unary;
        GroupingExpr* grouping;
        LiteralExpr* literal;
        AssignExpr* assign;
        CallExpr* call;
        VariableExpr* variable;
    }
}
