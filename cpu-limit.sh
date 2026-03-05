#!/usr/bin/env bash
set -u

PID_FILE="/tmp/cpu-limit.pid"
WORKER_DIR="/tmp/cpu-limit-workers"
CHECK_INTERVAL=5
LOW_THRESHOLD=25
HIGH_THRESHOLD=70
MAX_WORKERS=$(nproc)
MIN_WORKERS=0

read_cpu_stat() {
  local cpu user nice system idle iowait irq softirq steal guest guest_nice
  read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
  local idle_all=$((idle + iowait))
  local total=$((user + nice + system + idle + iowait + irq + softirq + steal))
  echo "$total $idle_all"
}

count_workers() {
  local count=0
  local f
  [ -d "$WORKER_DIR" ] || { echo 0; return; }
  for f in "$WORKER_DIR"/*.pid; do
    [ -e "$f" ] || continue
    count=$((count + 1))
  done
  echo "$count"
}

reap_stale_workers() {
  [ -d "$WORKER_DIR" ] || return 0
  local f pid
  for f in "$WORKER_DIR"/*.pid; do
    [ -e "$f" ] || continue
    pid=$(cat "$f" 2>/dev/null || true)
    if [ -z "$pid" ] || ! kill -0 "$pid" 2>/dev/null; then
      rm -f "$f"
    fi
  done
}

start_worker() {
  dd if=/dev/zero of=/dev/null status=none &
  local pid=$!
  echo "$pid" > "$WORKER_DIR/$pid.pid"
}

stop_one_worker() {
  [ -d "$WORKER_DIR" ] || return 0
  local f pid
  for f in "$WORKER_DIR"/*.pid; do
    [ -e "$f" ] || continue
    pid=$(cat "$f" 2>/dev/null || true)
    rm -f "$f"
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
      return 0
    fi
  done
}

cleanup() {
  if [ -d "$WORKER_DIR" ]; then
    local f pid
    for f in "$WORKER_DIR"/*.pid; do
      [ -e "$f" ] || continue
      pid=$(cat "$f" 2>/dev/null || true)
      if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
        kill "$pid" 2>/dev/null || true
      fi
    done
    rm -rf "$WORKER_DIR"
  fi
  rm -f "$PID_FILE"
}

if [ -e "$PID_FILE" ]; then
  old_pid=$(cat "$PID_FILE" 2>/dev/null || true)
  if [ -n "$old_pid" ] && kill -0 "$old_pid" 2>/dev/null; then
    echo "Error: Another instance of cpu-limit.sh is already running with PID $old_pid"
    exit 1
  fi
  rm -f "$PID_FILE"
fi

echo $$ > "$PID_FILE"
mkdir -p "$WORKER_DIR"
trap cleanup EXIT INT TERM

read -r prev_total prev_idle <<< "$(read_cpu_stat)"

while true; do
  sleep "$CHECK_INTERVAL"
  read -r curr_total curr_idle <<< "$(read_cpu_stat)"

  delta_total=$((curr_total - prev_total))
  delta_idle=$((curr_idle - prev_idle))
  prev_total=$curr_total
  prev_idle=$curr_idle

  if [ "$delta_total" -le 0 ]; then
    continue
  fi

  usage=$(( (100 * (delta_total - delta_idle)) / delta_total ))

  reap_stale_workers
  workers=$(count_workers)

  if [ "$usage" -lt "$LOW_THRESHOLD" ] && [ "$workers" -lt "$MAX_WORKERS" ]; then
    start_worker
  elif [ "$usage" -gt "$HIGH_THRESHOLD" ] && [ "$workers" -gt "$MIN_WORKERS" ]; then
    stop_one_worker
  fi
done
