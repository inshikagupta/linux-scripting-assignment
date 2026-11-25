#!/usr/bin/env bash
# log_report.sh - summarises a web server access log.
# Usage: ./log_report.sh <logfile>

if [ $# -ne 1 ]; then
  echo "Usage: $0 <logfile>"
  echo "Example: $0 sample.log"
  exit 1
fi

LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then
  echo "Error: file '$LOG_FILE' not found."
  exit 1
fi

TOTAL=$(wc -l < "$LOG_FILE" | tr -d ' ')
NOT_FOUND=$(awk '$9 == 404' "$LOG_FILE" | wc -l | tr -d ' ')

echo "========== LOG REPORT: $LOG_FILE =========="
echo "Total requests : $TOTAL"
echo "404 errors     : $NOT_FOUND"
echo
echo "Top 3 IP addresses:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -3 \
  | awk '{printf "  %-15s %s requests\n", $2, $1}'
