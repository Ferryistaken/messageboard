#!/bin/bash

# Default port and file paths
PORT=${PORT:-6969}
LOGFILE="/app/messageboard/log/messages.log"
HEADER="/app/messageboard/log/header.txt"
FOOTER="/app/messageboard/log/footer.txt"

while true; do
  # Handle each connection in a subshell to reset environment
  (
    echo -ne "HTTP/1.1 200 OK\r\nContent-Type: text/plain; charset=utf-8\r\n\r\n"
    cat $HEADER $LOGFILE $FOOTER
  ) | nc -l -k -p $PORT
done
