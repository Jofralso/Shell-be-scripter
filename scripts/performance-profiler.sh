#!/bin/bash

# Performance profiler script
# Usage: ./performance-profiler.sh [executable]

executable="$1"

# Example implementation using time command for measuring execution time
time ./"$executable"
