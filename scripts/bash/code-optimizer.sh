#!/bin/bash

# Code optimizer script
# Usage: ./code-optimizer.sh [directory]

directory="${1:-.}"

# Remove comments
find "$directory" -type f -name "*.c" -o -name "*.cpp" -o -name "*.h" | xargs sed -i '/^\s*\/\//d; /^\/\*/,/\*\//d'

# Remove whitespace
find "$directory" -type f -name "*.c" -o -name "*.cpp" -o -name "*.h" | xargs sed -i 's/^[ \t]*//'

# Remove unused variables
# Your implementation here
