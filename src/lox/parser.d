module lox.parser;
import lox.token;
import lox.expr;
import lox.error;
import lox.stmt;

import lox.tokentype;
import std.stdio;

/** 
 *   // program        → statement* EOF ;

    // statement      → exprStmt
    //                | printStmt ;

    // exprStmt       → expression ";" ;
    // printStmt      → "print" expression ";" ;

 */

/** 
 * expression     → equality ;
*  
*    equality       → comparison ( ( "!=" | "==" ) comparison )* ;
* 
*    comparison     → term ( ( ">" | ">=" | "<" | "<=" ) term )* ;
* 
*    term           → factor ( ( "-" | "+" ) factor )* ;
* 
*    factor         → unary ( ( "/" | "*" ) unary )* ;
*
*    unary          → ( "!" | "-" ) unary
*                   | primary ;
* 
*    primary        → NUMBER | STRING | "true" | "false" | "nil"
*                 | "(" expression ")" ;
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

    // Expr* parse()
    // {
    //     try
    //     {
    //         return expression();
    //     }
    //     catch (ParseError error)
    //     {
    //         return null;
    //     }
    // }

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

        consume(TokenType.SEMICOLON, "Expect ';' after varoable declaration");
        return makeVariableStmt(name, initializer);
    }

    Stmt* statement()
    {
        return match([TokenType.PRINT]) ? printStatement() : expressionStatement();
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
        Expr* expr = equality();

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

        return primary();
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
