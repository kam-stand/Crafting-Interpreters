import std.stdio;
import lox;

void main(string[] args) {
    Lox lox = new Lox(args);
    lox.runFile(args[0]);

    scope(exit) destroy(lox);
}
