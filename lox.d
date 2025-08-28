module lox;
import std.stdio;
import std.string;
import std.file;


class Lox
{
    public string[] args;
    public string contents;

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
        // takes in the contents as a singular string
        this.contents = readText(this.args[1]);
        this.run();
    }

    public void runPrompt()
    {
        while (true)
        {
            write("lox> ");
            string line = readln();
            if (line is null || strip(line) == "exit") break;
            this.run();
        }
    }

    public void run()
    {
        writefln("Running jlox on file %s", this.args[1]);
        writefln("Contents are %s \n", this.contents);
        // TODO: call the scanner class
    }

}
