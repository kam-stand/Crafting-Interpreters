import std.stdio;
import lox;

int main(string[] args)
{
    if (args.length > 2)
    {
        writeln("Usage: jlox [script]");
        return -1;
    }

    Lox lox = new Lox(args);

    if (args.length == 2)
    {
        lox.runFile();
    }
    else 
    {
        lox.runPrompt();
    }

    return 0;
}
