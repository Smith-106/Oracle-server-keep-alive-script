#!/usr/bin/env bash
set -u

PID_FILE="/tmp/bandwidth_occupier.pid"
MIN_INTERVAL=10
MAX_INTERVAL=3600
MIN_BYTES=1024
MAX_BYTES=1073741824
DOWNLOAD_URL_BASE="https://speed.cloudflare.com/__down?bytes="

cleanup() {
  rm -f "$PID_FILE"
}

if [ -e "$PID_FILE" ]; then
  old_pid=$(cat "$PID_FILE" 2>/dev/null || true)
  if [ -n "$old_pid" ] && kill -0 "$old_pid" 2>/dev/null; then
    echo "Error: Another instance is already running with PID $old_pid"
    exit 1
  fi
  rm -f "$PID_FILE"
fi

echo $$ > "$PID_FILE"
trap cleanup EXIT INT TERM

while true; do
  cycle_start=$(date +%s)

  interval=$((RANDOM % (MAX_INTERVAL - MIN_INTERVAL + 1) + MIN_INTERVAL))

  max_for_interval=$((MIN_BYTES + (interval - MIN_INTERVAL) * (MAX_BYTES - MIN_BYTES) / (MAX_INTERVAL - MIN_INTERVAL)))
  [ "$max_for_interval" -lt "$MIN_BYTES" ] && max_for_interval=$MIN_BYTES
  [ "$max_for_interval" -gt "$MAX_BYTES" ] && max_for_interval=$MAX_BYTES

  size=$((RANDOM * RANDOM))
  size=$((MIN_BYTES + (size % (max_for_interval - MIN_BYTES + 1))))

  tmp_file="/tmp/bandwidth_occupier_${size}_$$_${cycle_start}.bin"
  timeout 70m wget -q -O "$tmp_file" "${DOWNLOAD_URL_BASE}${size}" || true
  rm -f "$tmp_file"

  elapsed=$(( $(date +%s) - cycle_start ))
  remain=$(( interval - elapsed ))
  if [ "$remain" -gt 0 ]; then
    sleep "$remain"
  fi
done
