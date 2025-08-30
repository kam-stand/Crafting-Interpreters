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

struct LogicalExpr
{
    Expr* left;
    Token* operator;
    Expr* right;
}

struct SetExpr
{
    Expr* object;
    Token* operator;
    Expr* value;
}

struct SuperExpr
{
    Token* keyword;
    Token* method;
}

struct AssignExpr
{
    Token* name;
    Expr* value;
}

struct CallExpr
{
    Expr* callee;
    Token* parent;
    Expr*[] arguments;
}

struct GetExpr
{
    Expr* object;
    Token* name;
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

Expr* makeBinary(Expr* left, Token* operator, Expr* right)
{
    BinaryExpr* bin = new BinaryExpr(left, operator, right);
    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_BINARY;
    expr.binary = bin;
    return expr;
}

Expr* makeUnary(Token* operator, Expr* right)
{
    UnaryExpr* unary = new UnaryExpr(operator, right);
    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_UNARY;
    expr.unary = unary;
    return expr;
}

Expr* makeGrouping(Expr* expression)
{
    GroupingExpr* group = new GroupingExpr(expression);
    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_GROUPING;
    expr.grouping = group;
    return expr;
}

// Expr* makeLiteralDouble(double num)
// {
//     auto lit = new Literal;
//     lit.number = num;

//     auto litExpr = new LiteralExpr;
//     litExpr.value = lit;

//     auto expr = new Expr;
//     expr.type = ExprType.EXPR_LITERAL;
//     expr.literal = litExpr;

//     return expr;
// }

// Expr* makeLiteralString(string s)
// {
//     auto lit = new Literal;
//     lit.str = s;

//     auto litExpr = new LiteralExpr;
//     litExpr.value = lit;

//     auto expr = new Expr;
//     expr.type = ExprType.EXPR_LITERAL;
//     expr.literal = litExpr;

//     return expr;
// }

// Expr* makeLiteralBool(bool b)
// {
//     auto lit = new Literal;
//     lit.boolean = b;

//     auto litExpr = new LiteralExpr;
//     litExpr.value = lit;

//     auto expr = new Expr;
//     expr.type = ExprType.EXPR_LITERAL;
//     expr.literal = litExpr;

//     return expr;
// }

Expr* makeLiteral(T)(T value)
{
    auto lit = new Literal;

    static if (is(T == string))
        lit.str = value;
    else static if (is(T == double))
        lit.number = value;
    else static if (is(T == bool))
        lit.boolean = value;
    else
        static assert(false, "Unsupported literal type");

    auto litExpr = new LiteralExpr;
    litExpr.value = lit;

    auto expr = new Expr;
    expr.type = ExprType.EXPR_LITERAL;
    expr.literal = litExpr;

    return expr;
}
