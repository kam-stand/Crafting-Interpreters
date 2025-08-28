module lox.scanner;
import std.stdio;

class Scanner
{
    public string content;

    this(string content)
    {
        this.content = content;
    }

    public void printContents()
    {
        write(this.content);
        writeln();
    }
}
