module lox.parser;
import lox.token;
import lox.expr;
import lox.error;

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

    Expr* parse()
    {
        try
        {
            return expression();
        }
        catch (ParseError error)
        {
            return null;
        }
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

    Token* consume(TokenType type, string message)
    {
        if (check(type))
            return advance();

        throw parseError(peek(), message);
    }

    Expr* expression()
    {
        return equality();
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
