module lox;
import std.file;
import std.stdio;
import std.string;

public import lox.scanner;

void runFile(string file_path)
{
    string source = readText(file_path);
    run(source);
}

void run(string source)
{
    Scanner scanner = new Scanner(source);
    scanner.printContents();
}

void runPrompt()
{
    while (1)
    {
        write("> ");
        string line = strip(readln());
        if (line is null)
        {
            break;
        }
        run((line));
    }
}
