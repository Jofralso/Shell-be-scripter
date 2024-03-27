#!/bin/bash

# Backup script
# Usage: ./backup-script.sh [source_directory] [destination_directory]

source_directory="$1"
destination_directory="$2"

# Example implementation using rsync for efficient file synchronization
rsync -av "$source_directory" "$destination_directory"
echo "Backup completed successfully"
