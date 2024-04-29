#!/bin/bash

# Error logger script
# Usage: ./error-logger.sh [error_message]

error_message="$@"

# Log error to file
echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $error_message" >> error.log
