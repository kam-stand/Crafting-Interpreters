module lox.parser;
import lox.token;
import lox.expr;
import lox.error;
import lox.stmt;

import lox.tokentype;
import std.stdio;

/** 
 * statement      → exprStmt
               | ifStmt
               | printStmt
               | block ;

ifStmt         → "if" "(" expression ")" statement
               ( "else" statement )? ;
 */

class Parser
{
    Token*[] tokens;
    int current;

    this(Token*[] tokens)
    {
        this.tokens = tokens;
        current = 0;
    }

    Stmt*[] parse()
    {
        Stmt*[] statements = [];

        while (!isAtEnd())
        {
            statements ~= declaration();
        }

        return statements;
    }

    Stmt* declaration()
    {
        try
        {
            if (match([TokenType.VAR]))
            {
                return varDeclaration();
            }
            return statement();
        }
        catch (ParseError error)
        {
            synchronize();
            return null;
        }
    }

    Stmt* varDeclaration()
    {
        Token* name = consume(TokenType.IDENTIFIER, "Expect variable name.");
        Expr* initializer = null;
        if (match([TokenType.EQUAL]))
        {
            initializer = expression();
        }

        consume(TokenType.SEMICOLON, "Expect ';' after variable declaration");
        return makeVariableStmt(name, initializer);
    }

    Stmt* statement()
    {
        if (match([TokenType.FOR]))
        {
            return forStmt();
        }

        if (match([TokenType.IF]))
        {
            return ifStatement();
        }
        if (match([TokenType.PRINT]))
        {
            return printStatement();
        }
        if (match([TokenType.WHILE]))
        {
            return whileStmt();
        }
        if (match([TokenType.LEFT_BRACE]))
        {
            return makeBlockStmt(block());
        }

        return expressionStatement();

    }

    Stmt* forStmt()
    {
        consume(TokenType.LEFT_PAREN, "Expect '(' after 'for'.");
        Stmt* initializer;
        if (match([TokenType.SEMICOLON]))
        {
            initializer = null;

        }
        else if (match([TokenType.VAR]))
        {
            initializer = varDeclaration();
        }
        else
        {
            initializer = expressionStatement();
        }

        Expr* condition = null;
        if (!check(TokenType.SEMICOLON))
        {
            condition = expression();

        }
        consume(TokenType.SEMICOLON, "Expect ';' after loop condtion.");

        Expr* increment = null;
        if (!(check(TokenType.RIGHT_PAREN)))
        {
            increment = expression();
        }
        consume(TokenType.RIGHT_PAREN, "Expect ')', after for clauses");

        Stmt* body_ = statement();

        if (increment != null)
        {
            Stmt*[] stmts;
            stmts ~= body_;

            stmts ~= makeExprStmt(increment);

            body_ = makeBlockStmt(stmts);

        }

        if (condition == null)
        {
            condition = makeLiteral(true);
        }
        body_ = makeWhileStmt(condition, body_);
        if (initializer != null)
        {
            Stmt*[] stmts;
            stmts ~= initializer;
            stmts ~= body_;
            body_ = makeBlockStmt(stmts);
        }
        return body_;
    }

    Stmt* whileStmt()
    {
        consume(TokenType.LEFT_PAREN, "Expect '(' after 'while'.");
        Expr* condition = expression();
        consume(TokenType.RIGHT_PAREN, "Expect ')' after condition.");
        Stmt* body_ = statement();

        return makeWhileStmt(condition, body_);

    }

    Stmt* ifStatement()
    {
        consume(TokenType.LEFT_PAREN, "Expect '(' after 'if'.");
        Expr* condition = expression();
        consume(TokenType.RIGHT_PAREN, "Expect ')' after 'condition'.");

        Stmt* thenBranch = statement();
        Stmt* elseBranch = null;
        if (match([TokenType.ELSE]))
        {
            elseBranch = statement();
        }

        return makeIfStmt(condition, thenBranch, elseBranch);

    }

    Stmt*[] block()
    {
        Stmt*[] statements = [];
        while (!(check(TokenType.RIGHT_BRACE)) && !isAtEnd())
        {
            statements ~= declaration();
        }
        consume(TokenType.RIGHT_BRACE, "Expect '}' after block.");
        return statements;
    }

    Stmt* printStatement()
    {
        Expr* value = expression();
        consume(TokenType.SEMICOLON, "Expect ';' after value.");
        return makeprintStmt(value);
    }

    Stmt* expressionStatement()
    {
        Expr* expr = expression();
        consume(TokenType.SEMICOLON, "Expect ';' after expression.");
        return makeExprStmt(expr);
    }

    Token* peek()
    {
        return tokens[current];
    }

    Token* previous()
    {
        return tokens[current - 1];
    }

    Token* advance()
    {
        if (!isAtEnd())
            current++;
        return previous();
    }

    bool isAtEnd()
    {
        return peek().type == TokenType.EOF;
    }

    bool check(TokenType type)
    {
        return isAtEnd() ? false : peek().type == type;
    }

    bool match(TokenType[] types)
    {
        foreach (TokenType type; types)
        {
            if (check(type))
            {
                advance();
                return true;
            }
        }

        return false;

    }

    void synchronize()
    {
        advance();
        while (!isAtEnd())
        {
            if (previous().type == TokenType.SEMICOLON)
            {
                return;
            }

            switch (peek().type)
            {
            case TokenType.CLASS:
            case TokenType.FUN:
            case TokenType.VAR:
            case TokenType.IF:
            case TokenType.WHILE:
            case TokenType.PRINT:
            case TokenType.RETURN:
            default:
                return;

            }
            advance();
        }

    }

    Token* consume(TokenType type, string message)
    {
        if (check(type))
            return advance();

        throw parseError(peek(), message);
    }

    Expr* expression()
    {
        return assignment();
    }

    Expr* assignment()
    {
        Expr* expr = or();

        if (match([TokenType.EQUAL]))
        {
            Token* equals = previous();
            Expr* value = assignment();

            if (expr.type == ExprType.EXPR_VARIABLE)
            {
                return makeAssign(expr.variable.name, value);
            }

            throw parseError(equals, "Invalid assignment target");
        }

        return expr;
    }

    Expr* or()
    {
        Expr* expr = and(); // parse left side

        while (match([TokenType.OR]))
        {
            Token* operator = previous();
            Expr* right = and();

            // Wrap in Expr* as EXPR_LOGICAL
            expr = makeLogical(expr, operator, right);
        }

        return expr;
    }

    Expr* and()
    {
        Expr* expr = equality(); // or whatever your next lower precedence is

        while (match([TokenType.AND]))
        {
            Token* operator = previous();
            Expr* right = equality();

            // Wrap in Expr* as EXPR_LOGICAL
            expr = makeLogical(expr, operator, right);
        }

        return expr;
    }

    Expr* equality()
    {
        Expr* expr = comparison();
        while (match([TokenType.BANG_EQUAL, TokenType.EQUAL_EQUAL]))
        {
            Token* op = previous();
            Expr* right = comparison();

            auto left = expr;
            auto node = new Expr(ExprType.EXPR_BINARY);
            node.binary = new BinaryExpr(left, op, right);
            expr = node;
        }
        return expr;
    }

    Expr* comparison()
    {
        Expr* expr = term();
        while (match([
                TokenType.GREATER, TokenType.GREATER_EQUAL, TokenType.LESS,
                TokenType.LESS_EQUAL
            ]))
        {
            Token* op = previous();
            Expr* right = term();

            auto left = expr;
            auto node = new Expr(ExprType.EXPR_BINARY);
            node.binary = new BinaryExpr(left, op, right);
            expr = node;
        }
        return expr;
    }

    Expr* term()
    {
        Expr* expr = factor();

        while (match([TokenType.MINUS, TokenType.PLUS]))
        {
            Token* op = previous();
            Expr* right = factor();

            auto left = expr; // save old left
            auto node = new Expr(ExprType.EXPR_BINARY);
            node.binary = new BinaryExpr(left, op, right);
            expr = node; // now replace expr with the new parent
        }
        return expr;
    }

    Expr* factor()
    {
        Expr* expr = unary();
        while (match([TokenType.SLASH, TokenType.STAR]))
        {
            Token* op = previous();
            Expr* right = unary();

            auto left = expr;
            auto node = new Expr(ExprType.EXPR_BINARY);
            node.binary = new BinaryExpr(left, op, right);
            expr = node;
        }
        return expr;
    }

    Expr* unary()
    {
        if (match([TokenType.BANG, TokenType.MINUS]))
        {
            Token* operator = previous();
            Expr* right = unary();
            return makeUnary(operator, right);
        }

        return call();
    }

    Expr* call()
    {
        Expr* expr = primary();

        while (true)
        {
            if (match([TokenType.LEFT_PAREN]))
            {
                expr = finishCall(expr);

            }
            else
            {
                break;
            }
        }

        return expr;

    }

    Expr* finishCall(Expr* callee)
    {

        Expr*[] arguments = [];
        if (!check(TokenType.RIGHT_PAREN))
        {
            do
            {
                arguments ~= expression();
            }
            while (match([TokenType.COMMA]));
        }

        Token* parent = consume(TokenType.RIGHT_PAREN, "Expect ')' after arguments.");

        return makeCall(callee, parent, arguments);

    }

    Expr* primary()
    {
        if (match([TokenType.FALSE]))
            return makeLiteral(false);

        if (match([TokenType.TRUE]))
            return makeLiteral(true);

        if (match([TokenType.NIL]))
            return makeLiteral(null);

        if (match([TokenType.NUMBER]))
            return makeLiteral(previous().literal.number);

        if (match([TokenType.STRING]))
            return makeLiteral(previous().literal.str);

        if (match([TokenType.IDENTIFIER]))
            return makeVariable(previous());

        if (match([TokenType.LEFT_PAREN]))
        {
            Expr* expr = expression();
            consume(TokenType.RIGHT_PAREN, "Expect ')' after expression.");
            return makeGrouping(expr);
        }

        // If nothing matches, this is an error
        throw parseError(peek(), "Expect expression");
    }

}
