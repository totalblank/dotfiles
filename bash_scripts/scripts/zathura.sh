#!/usr/bin/env bash

zathura "$@" &
PID="$!"

while true; do
  window_id="$(xdotool search --onlyvisible --pid "$PID")"
  if [ -n "$window_id" ]; then
    xdotool windowactivate --sync "$window_id" windowfocus --sync "$window_id" \
      key s key --delay 0 g g
    break
  fi
done
