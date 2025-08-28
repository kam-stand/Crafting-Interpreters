module lox;
import std.stdio;
import std.string;

class Lox {
    private string[] args;
    public static bool error = false;
    this(string[] args)
    {
        this.args = args;
    }
    ~this()
    {
        writeln("Destrying Lox class");
    }
    public void runFile(string file_path)
    { 
        writefln("The file path is %s: ", file_path); 
        this.verify_args();
        if (this.error)
        {
            this.runPrompt();
        }
        this.run(file_path);

    }
    public void runPrompt() {
        writefln("TODO");
    }
    public void run(string source) {writefln("Running lox on %s: ", source);}
    public void verify_args(){
        if (this.args.length == 0)
        {
            this.error = true;
        }
        else if (this.args.length > 1) {
            this.error = true;
        }
    }
}
