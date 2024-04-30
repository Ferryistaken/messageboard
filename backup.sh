#!/bin/bash

LOGFILE="/app/messageboard/log/messages.log"
BACKUP_DIR="/app/messageboard/log/backups"

# Create backup directory if it does not exist
mkdir -p "$BACKUP_DIR"

# Check if the log file has content
if [ -s "$LOGFILE" ]; then
    # Create a backup with the current date
    BACKUP_FILE="$BACKUP_DIR/messages_$(date +%Y-%m-%d).log"
    cp "$LOGFILE" "$BACKUP_FILE"
    echo "Backup successful: $BACKUP_FILE"
    # Clear the contents of the original log file
    > "$LOGFILE"
else
    echo "No new messages to backup."
fi
