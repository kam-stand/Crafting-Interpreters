import std.stdio;
import lox;

int main(string[] args)
{
    if (args.length > 2)
    {
        writeln("Usage: jlox [script]");
        return -1;
    }

    else if (args.length == 2)
    {
        runFile(args[1]);

    }
    else
    {
        runPrompt();
    }

    return 0;

}
