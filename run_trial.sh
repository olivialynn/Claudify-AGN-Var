#!/bin/bash
TRIAL=$1  # e.g. T1
claude \
  --append-system-prompt-file ./contexts/T${TRIAL}.txt \
  --no-session-persistence \
  --dangerously-skip-permissions \
  --tools "Write" \
  --verbose \
  -p "$(cat science_task.txt)" 2>&1 | tee outputs/T${TRIAL}_raw.md
