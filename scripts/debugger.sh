#!/bin/bash

# Debugger script for code debugging
# Usage: ./debugger.sh [options] [filename]

# Set default values
output_file="debug.log"
verbose=false

# Parse command line options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -o|--output)
            output_file="$2"
            shift
            ;;
        -v|--verbose)
            verbose=true
            ;;
        *)
            echo "Unknown option: $key"
            exit 1
            ;;
    esac
    shift
done

# Main debugging function
debug() {
    if [ "$verbose" = true ]; then
        echo "Debugging: $1"
    fi
    echo "Debug: $1" >> "$output_file"
}

# Example usage: debug "Error occurred in function foo()"
