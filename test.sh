#!/usr/bin/env bash
set -e  # stop on first error

APP="test"
SRC="src"
BIN="bin"

mkdir -p $BIN

# Compile all D files under src, put exe into bin/
ldc2 -Isrc --unittest -main -of=$BIN/$APP $SRC/*.d $SRC/lox/*.d

echo "Built $BIN/$APP successfully."


$BIN/$APP