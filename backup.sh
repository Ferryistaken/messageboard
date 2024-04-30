#!/bin/bash

# Define the log file and backup directory
LOGFILE="/app/messageboard/log/messages.log"
BACKUP_DIR="/app/messageboard/log/backups"

mkdir -p "$BACKUP_DIR"

if [ -s "$LOGFILE" ]; then
    BACKUP_FILE="$BACKUP_DIR/messages_$(date +%Y-%m-%d).log"
    cp "$LOGFILE" "$BACKUP_FILE"
    echo "Backup successful: $BACKUP_FILE"
else
    echo "No new messages to backup."
fi

