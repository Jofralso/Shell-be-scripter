#!/bin/bash

# Documentation generator script
# Usage: ./documentation-generator.sh [directory]

directory="${1:-.}"

# Example implementation using Doxygen for generating documentation
doxygen "$directory/Doxyfile"
echo "Documentation generated successfully"
