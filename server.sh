#!/bin/bash

# Default port and log file path
PORT=${PORT_SERVER:-1915}
LOGFILE="/app/messageboard/log/messages.log"

while true
do
  echo "Listening for connections on port $PORT..."

  coproc NC { nc -lk -p $PORT; }

  echo "Connection established."

  message=""
  ready_to_record=false

  while read -u ${NC[0]} line
  do
    if [[ "$line" == "." ]]; then
      now=$(date '+%Y-%m-%d %H:%M:%S')
      if [[ "$ready_to_record" == true && -n "$message" ]]; then
        echo "Writing to file: $LOGFILE"
        formatted_message=$(echo "$message" | awk '{if(NR==1){print} else {print "                   > " $0}}')
        echo "$now> $formatted_message" >> $LOGFILE
        echo "Goodbye at $now" >&${NC[1]}
      fi
      message=""
      ready_to_record=false
    elif [[ "$line" == "ave" ]]; then
      ready_to_record=true
    elif [[ "$ready_to_record" == true ]]; then
      if [[ -n "$line" ]]; then
        if [[ -n "$message" ]]; then
          message+=$'\n'
        fi
        message+="$line"
      fi
    fi
  done
done
