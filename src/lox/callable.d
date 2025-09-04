module lox.callable;

import lox.value;
import std.string;
import lox.interpreter;

interface LoxCallable
{
    int arity();
    Value call(Value[] arguments);
    string toString();
}
