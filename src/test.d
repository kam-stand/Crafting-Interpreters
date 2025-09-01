import lox.scanner;
import lox.token;
import lox.tokentype;
import std.stdio;
import std.file;
import std.conv : to;

// -------------------------
// 1. Basic tokens and EOF
// -------------------------
unittest
{
    writeln("========== BASIC TOKEN TEST ==========");

    string test_file = "basic.lox";
    string content = "{} () != == >= <= + - / * \n";
    std.file.write(test_file, content);

    scope (exit)
    {
        assert(exists(test_file));
        remove(test_file);
    }

    string text = readText(test_file);
    Scanner scan = new Scanner(cast(byte[]) text);
    auto tokens = scan.scanTokens();

    // Expect 13 symbols + EOF
    assert(tokens.length == 13);
    assert(tokens[$ - 1].type == TokenType.EOF);

    // Check first few tokens
    assert(tokens[0].lexeme == "{");
    assert(tokens[0].type == TokenType.LEFT_BRACE);
    assert(tokens[1].lexeme == "}");
    assert(tokens[1].type == TokenType.RIGHT_BRACE);
}

// -------------------------
// 2. String literals
// -------------------------
unittest
{
    writeln("========== STRING TEST ==========");

    string test_file = "string.lox";
    string content = `"Hello, World!" "Test123"`;
    std.file.write(test_file, content);

    scope (exit)
    {
        remove(test_file);
    }

    string text = readText(test_file);
    Scanner scan = new Scanner(cast(byte[]) text);
    auto tokens = scan.scanTokens();

    assert(tokens.length == 3); // 2 strings + EOF
    assert(tokens[0].type == TokenType.STRING);
    assert(tokens[0].literal.str == "Hello, World!");
    assert(tokens[1].literal.str == "Test123");
}

// -------------------------
// 3. Comments
// -------------------------
unittest
{
    writeln("========== COMMENTS TEST ==========");

    string test_file = "comments.lox";
    string content = "123 // line comment\n456 /* block comment */ 789";
    std.file.write(test_file, content);

    scope (exit)
    {
        remove(test_file);
    }

    string text = readText(test_file);
    Scanner scan = new Scanner(cast(byte[]) text);
    auto tokens = scan.scanTokens();

    // Expect 3 numbers + EOF
    assert(tokens.length == 4);
    assert(tokens[0].literal.number == 123);
    assert(tokens[1].literal.number == 456);
    assert(tokens[2].literal.number == 789);
}

// -------------------------
// 4. Newlines
// -------------------------
unittest
{
    writeln("========== NEWLINE TEST ==========");

    string test_file = "newline.lox";
    string content = "{\n(\n)\n}";
    std.file.write(test_file, content);

    scope (exit)
    {
        remove(test_file);
    }

    string text = readText(test_file);
    Scanner scan = new Scanner(cast(byte[]) text);
    auto tokens = scan.scanTokens();

    assert(tokens.length == 5); // 4 symbols + EOF
    assert(scan.line == 4); // line counter should be 4 at end

}

// -------------------------
// 5. Comments
// -------------------------
unittest
{
    writeln("========== COMMENTS TEST ==========");

    string test_file = "newline.lox";
    string content = "/* NO TOKENS ONLY EOF */ ";
    std.file.write(test_file, content);

    scope (exit)
    {
        remove(test_file);
    }

    string text = readText(test_file);
    Scanner scan = new Scanner(cast(byte[]) text);
    auto tokens = scan.scanTokens();

    assert(tokens.length == 1);
    assert(tokens[0].type == TokenType.EOF);
}

unittest
{
    writeln("========== EDGE CASE: OPERATORS ==========");

    string test_file = "operators.lox";
    string content = "! == != =";
    std.file.write(test_file, content);

    scope (exit)
    {
        remove(test_file);
    }

    string text = readText(test_file);
    Scanner scan = new Scanner(cast(byte[]) text);
    auto tokens = scan.scanTokens();

    assert(tokens.length == 5); // 4 operators + EOF

    assert(tokens[0].type == TokenType.BANG); // !
    assert(tokens[1].type == TokenType.EQUAL_EQUAL); // ==
    assert(tokens[2].type == TokenType.BANG_EQUAL); // !=
    assert(tokens[3].type == TokenType.EQUAL); // =
}
