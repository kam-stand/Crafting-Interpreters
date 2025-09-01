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

// TODO: create funciont for all StmtTypes 
