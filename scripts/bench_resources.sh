#!/usr/bin/env bash
set -euo pipefail
NS="$1"               # flux-system OR argocd
DUR_SEC="${2:-120}"   # sample window (seconds)
INTERVAL="${3:-2}"    # sample every 2s

END=$(( $(date +%s) + DUR_SEC ))
echo "TS,POD,CPU(m),MEM(Mi),NS"
while [ "$(date +%s)" -le "$END" ]; do
  # requires metrics-server
  kubectl top pod -n "$NS" --no-headers 2>/dev/null | awk -v ns="$NS" -v ts="$(date +%s)" '{print ts","$1","$2","$3","ns}'
  sleep "$INTERVAL"
done