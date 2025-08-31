module lox.error;
import std.stdio;

void error(int line, string message)
{
    report(line, "", message);
}

void report(int line, string where, string message)
{
    writefln("[line %s ] Error %s: %s", line, where, message);
}
