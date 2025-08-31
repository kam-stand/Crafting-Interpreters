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
    EXPR_GET,
    EXPR_SUPER,
    EXPR_SET,
    EXPR_LOGICAL,
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
        LogicalExpr* logical;
        SetExpr* set;
        GetExpr* get;
        SuperExpr* superExpr;
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

Expr* makeLiteral(T)(T value)
{
    Literal* lit = new Literal;

    static if (is(T == string))
    {
        lit.type = LiteralType.STRING;
        lit.str = value;
    }
    else static if (is(T == double))
    {
        lit.type = LiteralType.NUMBER;
        lit.number = value;
    }
    else static if (is(T == bool))
    {
        lit.type = LiteralType.BOOLEAN;
        lit.boolean = value;
    }
    else static if (is(T == typeof(null))) // null case
        lit.type = LiteralType.NULL;
    // nothing stored in the union
    else
        static assert(false, "Unsupported literal type");

    LiteralExpr* litExpr = new LiteralExpr;
    litExpr.value = lit;

    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_LITERAL;
    expr.literal = litExpr;

    return expr;
}

Expr* makeLogical(Expr* left, Token* operator, Expr* right)
{
    LogicalExpr* logical = new LogicalExpr(left, operator, right);
    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_LOGICAL;
    expr.logical = logical;
    return expr;
}

Expr* makeSet(Expr* object, Token* operator, Expr* value)
{
    SetExpr* set = new SetExpr(object, operator, value);
    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_SET;
    expr.set = set;
    return expr;
}

Expr* makeSuper(Token* keyword, Token* method)
{
    SuperExpr* superExpr = new SuperExpr(keyword, method);
    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_SUPER;
    expr.superExpr = superExpr;
    return expr;
}

Expr* makeAssign(Token* name, Expr* value)
{
    AssignExpr* assign = new AssignExpr(name, value);
    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_ASSIGN;
    expr.assign = assign;
    return expr;
}

Expr* makeCall(Expr* callee, Token* parent, Expr*[] arguments)
{

    CallExpr* call = new CallExpr(callee, parent, arguments);
    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_CALL;
    expr.call = call;
    return expr;
}

Expr* makeGet(Expr* object, Token* name)
{
    GetExpr* get = new GetExpr(object, name);
    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_GET;
    expr.get = get;
    return expr;

}
