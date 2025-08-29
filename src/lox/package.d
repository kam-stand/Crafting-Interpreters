module lox;
import std.file;
import std.stdio;
import std.string;

public import lox.scanner;

void runFile(string file_path)
{
    byte[] source = cast(byte[]) read(file_path);
    run(source);

}

void run(byte[] source)
{
    printContent(source);
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
        run(cast(byte[]) line); // casting to byte array
    }
}
