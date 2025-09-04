module lox.callable;

import lox.value;
import std.string;

interface LoxCallable
{
    int arity();
    Value call(Value[] arguments);
    string toString();
}
