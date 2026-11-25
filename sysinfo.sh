#!/usr/bin/env bash
# sysinfo.sh - prints basic system information and saves it to a dated file.
# Works on both macOS and Linux.
OUTPUT_FILE="sysinfo_$(date +%Y-%m-%d).txt"
OS="$(uname -s)"

{
  echo "========== SYSTEM INFO =========="
  echo "Hostname       : $(hostname)"
  echo "Date & Time    : $(date '+%Y-%m-%d %H:%M:%S %Z')"
  echo "Logged-in user : $(whoami)"
  echo

  echo "---------- Disk usage of / ----------"
  df -h /
  echo

  echo "---------- Memory usage ----------"
  if [ "$OS" = "Darwin" ]; then
    top -l 1 | grep PhysMem
  else
    free -h
  fi
  echo

  echo "---------- Top 5 processes by memory ----------"
  if [ "$OS" = "Darwin" ]; then
    ps -Ao pid,user,%mem,rss,ucomm -m | head -6
  else
    ps -eo pid,user,%mem,rss,ucomm --sort=-%mem | head -6
  fi
} | tee "$OUTPUT_FILE"

echo
echo "Saved to $OUTPUT_FILE"
