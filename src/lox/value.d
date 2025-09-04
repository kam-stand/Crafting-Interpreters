module lox.value;
import lox.token;
import std.stdio;
import std.format;
import std.conv;
import lox.callable;

/** 
 * VALUE
 *  - All supported types mapped from Lox interpreter into D lang
 *  // TODO: add supprt for int , long and float
 */

struct Value
{
    LiteralType type;
    union
    {
        string str;
        double number;
        bool val;
        LoxCallable callable;
    }
}

Value value(string str)
{

    Value v = Value();
    v.type = LiteralType.STRING;
    v.str = str;

    return v;
}

Value value(double number)
{

    Value v = Value();
    v.type = LiteralType.NUMBER;
    v.number = number;

    return v;
}

Value value(bool val)
{

    Value v = Value();
    v.type = LiteralType.BOOLEAN;
    v.val = val;

    return v;
}

Value value()
{

    Value v = Value();
    v.type = LiteralType.NULL;

    return v;
}

Value value(LoxCallable fn)
{
    Value v = value();
    v.type = LiteralType.CALLABLE;
    v.callable = fn;
    return v;

}

string stringify(Value value)
{
    final switch (value.type)
    {
    case LiteralType.NUMBER:
        return format("%s", to!string(value.number));
    case LiteralType.BOOLEAN:
        return value.val ? "true" : "false";
    case LiteralType.STRING:
        return value.str;
    case LiteralType.NULL:
        return "nil";
    case LiteralType.CALLABLE:
        return value.callable.toString();
    }
}
