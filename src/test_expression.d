module test_expression;
import lox.expr;
import lox.value;
import lox.interpreter;
import lox.token;
import lox.tokentype;
import std.stdio;

// ---------------
// 1. Add
// ---------------
unittest
{
    Expr* left = makeLiteral(1.0); // numeric literal
    Expr* right = makeLiteral(2.0); // numeric literal

    BinaryExpr* bin = new BinaryExpr;
    bin.left = left;
    bin.operator = createToken("+", TokenType.PLUS, 1); // the '+' token
    bin.right = right;

    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_BINARY;
    expr.binary = bin;

    // create an interpreter instance
    Interpreter interp = new Interpreter();

    // evaluate the expression
    Value val = interp.evaluateExpression(expr);

    assert(val.number == 3);
    writeln("\tGOT: ", val.number);

}

// ---------------
// 2. Subtract
// ---------------

unittest
{
    Expr* left = makeLiteral(10.0); // numeric literal
    Expr* right = makeLiteral(10.0); // numeric literal

    BinaryExpr* bin = new BinaryExpr;
    bin.left = left;
    bin.operator = createToken("-", TokenType.MINUS, 1); // the '-' token
    bin.right = right;

    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_BINARY;
    expr.binary = bin;

    // create an interpreter instance
    Interpreter interp = new Interpreter();

    // evaluate the expression
    Value val = interp.evaluateExpression(expr);

    assert(val.number == 0);

}

// ---------------
// 3. Divide
// ---------------

unittest
{
    Expr* left = makeLiteral(10.0); // numeric literal
    Expr* right = makeLiteral(10.0); // numeric literal

    BinaryExpr* bin = new BinaryExpr;
    bin.left = left;
    bin.operator = createToken("/", TokenType.SLASH, 1); // the '/' token
    bin.right = right;

    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_BINARY;
    expr.binary = bin;

    // create an interpreter instance
    Interpreter interp = new Interpreter();

    // evaluate the expression
    Value val = interp.evaluateExpression(expr);

    assert(val.number == 1);
}

// ---------------
// 4. Multiply
// ---------------
unittest
{
    Expr* left = makeLiteral(10.0); // numeric literal
    Expr* right = makeLiteral(10.0); // numeric literal

    BinaryExpr* bin = new BinaryExpr;
    bin.left = left;
    bin.operator = createToken("*", TokenType.STAR, 1); // the '-' token
    bin.right = right;

    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_BINARY;
    expr.binary = bin;

    // create an interpreter instance
    Interpreter interp = new Interpreter();

    // evaluate the expression
    Value val = interp.evaluateExpression(expr);

    assert(val.number == 100);

}

// ---------------
// 4. Concat
// ---------------
unittest
{
    Expr* left = makeLiteral("Hello"); // numeric literal
    Expr* right = makeLiteral(" world"); // numeric literal

    BinaryExpr* bin = new BinaryExpr;
    bin.left = left;
    bin.operator = createToken("+", TokenType.PLUS, 1); // the '-' token
    bin.right = right;

    Expr* expr = new Expr;
    expr.type = ExprType.EXPR_BINARY;
    expr.binary = bin;

    // create an interpreter instance
    Interpreter interp = new Interpreter();

    // evaluate the expression
    Value val = interp.evaluateExpression(expr);

    assert(val.type == LiteralType.STRING);

    assert(val.str.length > 0);

    assert(val.str.length == 11);

    assert(val.str == "Hello world");

}
