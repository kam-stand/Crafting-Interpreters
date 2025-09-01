module lox;
import std.file;
import std.stdio;
import std.string;
import lox.parser;
import lox.expr;
import lox.astprinter;
import lox.interpreter;
import lox.value;

public import lox.scanner;

void runFile(string file_path)
{
    byte[] source = cast(byte[]) read(file_path);
    run(source);

}

void run(byte[] source)
{
    Scanner scanner = new Scanner(source);
    auto tokens = scanner.scanTokens();

    Parser parser = new Parser(tokens);
    auto statements = parser.parse(); // parse returns an array of Stmt*

    Interpreter interpreter = new Interpreter();
    interpreter.interpret(statements);
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
