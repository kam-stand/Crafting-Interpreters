module lox.environment;
import lox.value;
import lox.token;
import lox.error;

import lox;

class Environment
{
    Environment enclosing;
    Value[string] values;

    this(Environment enclosing)
    {
        this.enclosing = enclosing;
    }

    this()
    {

    }

    void define(string name, Value val)
    {
        values[name] = val;
    }

    Value get(Token* name)
    {
        if (auto v = name.lexeme in values)
        {
            return *v;
        }
        if (enclosing !is null)
        {

            return enclosing.get(name);
        }
        throw runtimeError(name, "Undefined variable '" ~ name.lexeme ~ "'.");
    }

    void assign(Token* name, Value value)
    {
        if (auto v = name.lexeme in values)
        {
            values[name.lexeme] = value;
            return;
        }

        if (enclosing !is null)
        {
            enclosing.assign(name, value);
        }

        throw runtimeError(name, "Undefined variable '" ~ name.lexeme ~ "'.");
    }
}
