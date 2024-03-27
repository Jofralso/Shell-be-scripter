#!/bin/bash

# Code formatter script
# Usage: ./code-formatter.sh [directory]

directory="${1:-.}"

# Example implementation using clang-format for C/C++ files
find "$directory" -type f -name "*.c" -o -name "*.cpp" | xargs clang-format -i
echo "Code formatted successfully"
