#!/usr/bin/env bash
set -e  # stop on first error

APP="debug"
SRC="src"
BIN="bin"

mkdir -p $BIN

# Compile all D files under src, put exe into bin/
ldc2 -Isrc -g -of=$BIN/$APP $SRC/main.d $SRC/lox/*.d

echo "Built $BIN/$APP successfully."
