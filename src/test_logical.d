module test_logical;
import lox.expr;
import lox.value;
import lox.interpreter;
import lox.token;
import lox.tokentype;
import std.stdio;

unittest
{
    auto interp = new Interpreter();

    // true or false -> true
    Expr* expr1 = makeLogical(makeLiteral(true), createToken("or", TokenType.OR, 1), makeLiteral(
            false));
    assert(interp.evaluateExpression(expr1).val == true);

    // false or true -> true
    Expr* expr2 = makeLogical(makeLiteral(false), createToken("or", TokenType.OR, 1), makeLiteral(
            true));
    assert(interp.evaluateExpression(expr2).val == true);

    // true and true -> true
    Expr* expr3 = makeLogical(makeLiteral(true), createToken("and", TokenType.AND, 1), makeLiteral(
            true));
    assert(interp.evaluateExpression(expr3).val == true);

    // true and false -> false
    Expr* expr4 = makeLogical(makeLiteral(true), createToken("and", TokenType.AND, 1), makeLiteral(
            false));
    assert(interp.evaluateExpression(expr4).val == false);

    // false and (anything) -> false (short-circuit)
    Expr* expr5 = makeLogical(makeLiteral(false), createToken("and", TokenType.AND, 1), makeLiteral(
            true));
    assert(interp.evaluateExpression(expr5).val == false);

    // (true or false) and true -> true
    Expr* orPart = makeLogical(makeLiteral(true), createToken("or", TokenType.OR, 1), makeLiteral(
            false));
    Expr* expr6 = makeLogical(orPart, createToken("and", TokenType.AND, 1), makeLiteral(true));
    assert(interp.evaluateExpression(expr6).val == true);

}
