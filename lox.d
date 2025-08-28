module lox;
import std.stdio;
import std.string;
import std.file;


class Lox
{
    public string[] args;

    this(string[] args)
    {
        this.args = args;
    }

    ~this()
    {
        writeln("Destroying Lox class");
    }

    public void runFile()
    {
        writefln("The source file is %s", this.args[1]);
        this.run();
    }

    public void runPrompt()
    {
        while (true)
        {
            write("lox> ");
            string line = readln();
            if (line is null || strip(line) == "exit") break;
            this.runLine(line);
        }
    }

    public void run()
    {
        writefln("Running jlox on file %s", this.args[1]);
    }

    private void runLine(string line)
    {
        writeln("Running line: ", line);
    }
}
