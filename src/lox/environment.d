import lox.value;
import lox.token;
import lox;

class Environment
{
    Value[string] values;

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
        throw runtimeError(name, "Undefined variable '" ~ name.lexeme ~ "'.");
    }

    void assign(Token* name, Value value)
    {
        if (auto v = name.lexeme in values)
        {
            values[name.lexeme] = value;
            return;
        }
        throw runtimeError(name, "Undefined variable '" ~ name.lexeme ~ "'.");
    }
}
