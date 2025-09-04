module lox.stmt;
import lox.token;
import lox.expr;

// program        → statement* EOF ;

// statement      → exprStmt
//                | printStmt ;

// exprStmt       → expression ";" ;
// printStmt      → "print" expression ";" ;

struct BlockStmt
{
    Stmt*[] statements;
}

struct ClassStmt
{
    Token* name;
    VariableExpr* superclass; // May need to change from VariableExpr to Expr !

    Stmt*[] methods;

}

struct ExprStmt
{
    Expr* expression;
}

struct FuncStmt
{
    Token* name;
    Token*[] params;
    Stmt*[] body;
}

struct IfStmt
{
    Expr* condition;
    Stmt* thenBranch;
    Stmt* elseBranch;

}

struct PrintStmt
{
    Expr* expression;
}

struct ReturnStmt
{
    Token* keyword;
    Expr* value;
}

struct VariableStmt
{

    Token* name;
    Expr* initializer;
}

struct WhileStmt
{
    Expr* condition;
    Stmt* body;
}

enum StmtType
{
    BLOCK_STMT,
    CLASS_STMT,
    EXPR_STMT,
    FUNC_STMT,
    IF_STMT,
    PRINT_STMT,
    RETURN_STMT,
    VARIABLE_STMT,
    WHILE_STMT
}

struct Stmt
{
    StmtType type;
    union
    {
        BlockStmt* blockStmt;
        ClassStmt* classStmt;
        ExprStmt* exprStmt;
        FuncStmt* funcStmt;
        IfStmt* ifStmt;
        PrintStmt* printStmt;
        ReturnStmt* returnStmt;
        VariableStmt* varStmt;
        WhileStmt* whileStmt;

    }

}

Stmt* makeBlockStmt(Stmt*[] statements)
{
    BlockStmt* blockStmt = new BlockStmt(statements);
    Stmt* stmt = new Stmt;
    stmt.type = StmtType.BLOCK_STMT;
    stmt.blockStmt = blockStmt;
    return stmt;
}

Stmt* makeClassStmt(Token* name, VariableExpr* superclass, Stmt*[] methods)
{
    ClassStmt* classStmt = new ClassStmt(name, superclass, methods);
    Stmt* stmt = new Stmt;
    stmt.type = StmtType.CLASS_STMT;
    stmt.classStmt = classStmt;
    return stmt;

}

Stmt* makeExprStmt(Expr* expressions)
{
    ExprStmt* exprStmt = new ExprStmt(expressions);
    Stmt* stmt = new Stmt;
    stmt.type = StmtType.EXPR_STMT;
    stmt.exprStmt = exprStmt;
    return stmt;
}

Stmt* makeFuncStmt(Token* name, Token*[] params, Stmt*[] body)
{

    FuncStmt* functStmt = new FuncStmt(name, params, body);
    Stmt* stmt = new Stmt;
    stmt.type = StmtType.FUNC_STMT;
    stmt.funcStmt = functStmt;
    return stmt;
}

Stmt* makeIfStmt(Expr* condition, Stmt* thenBranch, Stmt* elseBranch)
{
    IfStmt* ifStmt = new IfStmt(condition, thenBranch, elseBranch);
    Stmt* stmt = new Stmt;
    stmt.type = StmtType.IF_STMT;
    stmt.ifStmt = ifStmt;
    return stmt;
}

Stmt* makeprintStmt(Expr* expression)
{
    PrintStmt* printStmt = new PrintStmt(expression);
    Stmt* stmt = new Stmt;
    stmt.type = StmtType.PRINT_STMT;
    stmt.printStmt = printStmt;
    return stmt;
}

Stmt* makeReturnStmt(Token* keyword, Expr* value)
{
    ReturnStmt* returnStmt = new ReturnStmt(keyword, value);
    Stmt* stmt = new Stmt;
    stmt.type = StmtType.RETURN_STMT;
    stmt.returnStmt = returnStmt;
    return stmt;
}

Stmt* makeVariableStmt(Token* name, Expr* initializer)
{
    VariableStmt* varStmt = new VariableStmt(name, initializer);
    Stmt* stmt = new Stmt;
    stmt.type = StmtType.VARIABLE_STMT;
    stmt.varStmt = varStmt;
    return stmt;
}

Stmt* makeWhileStmt(Expr* condition, Stmt* body)
{
    WhileStmt* whileStmt = new WhileStmt(condition, body);
    Stmt* stmt = new Stmt;
    stmt.type = StmtType.WHILE_STMT;
    stmt.whileStmt = whileStmt;
    return stmt;
}
