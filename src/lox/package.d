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

    while (!parser.isAtEnd())
    {
        Expr* expr = parser.expression(); // parse next expression
        astPrinter(expr);
        writeln(); // separate expressions
        Interpreter interpreter = new Interpreter();
        auto result = interpreter.evaluateExpression(expr);
        writeln(stringify(result));

    }

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
