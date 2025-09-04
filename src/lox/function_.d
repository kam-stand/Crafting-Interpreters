module lox.function_;
import lox.callable;
import lox.stmt;
import lox.environment;
import lox.value;
import lox.interpreter;
import lox.error;

class LoxFunction : LoxCallable
{
    FuncStmt* declaration;
    Environment* closure;

    this(FuncStmt* stmt, Environment* closure)
    {
        this.declaration = stmt;
        this.closure = closure;
    }

    int arity()
    {
        return cast(int) declaration.params.length;
    }

    Value call(Value[] arguments)
    {
        auto env = new Environment(closure);

        foreach (i, params; declaration.params)
        {
            env.define(params.lexeme, arguments[i]);
        }
        try
        {

            auto interp = new Interpreter();
            interp.evalBlockStmt(declaration.body, &env);

        }
        catch (ReturnException r)
        {
            return r.value;
        }
        return value();
    }

    override string toString()
    {
        return "<fn " ~ declaration.name.lexeme ~ ">";
    }

}
