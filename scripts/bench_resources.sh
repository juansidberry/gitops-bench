#!/usr/bin/env bash
set -euo pipefail
NS="$1"               # flux-system OR argocd
DUR_SEC="${2:-120}"   # sample window (seconds)
INTERVAL="${3:-2}"    # sample every 2s
# TEST="$4"      # resource type (cpu/mem)

END=$(( $(date +%s) + DUR_SEC ))
# if [ "$NS" == "flux-demo" ]; then
#   NS="flux-system"
# elif [ "$NS" == "argocd-demo" ]; then
#   NS="argocd"
# fi
#   echo "Usage: $0 <namespace> [duration_seconds] [interval_seconds] [test_type]"
#   echo "Example: $0 flux-system 120 2 sync-latency"
#   exit 1
# fi
#echo "TS,POD,CPU(m),MEM(Mi),NS,type" > "${NS}_resources.csv"
while [ "$(date +%s)" -le "$END" ]; do
  # requires metrics-server
  # if [ "$NS" == "flux-system" ]; then
    kubectl top pod -n "$NS" --no-headers 2>/dev/null | awk -v ns="$NS" -v ts="$(date +%s)" '{print ts","$1","$2","$3","ns}' >> "${NS}_resources.csv"
    sleep "$INTERVAL"
  #   continue
  # fi
  # # argocd namespace
  # if [ "$NS" == "argocd" ]; then
  #   kubectl top pod -n "$NS" --no-headers 2>/dev/null | awk -v ns="$NS" -v ts="$(date +%s)" '{print ts","$1","$2","$3","ns}' | tee argo_resources.csv
  #   sleep "$INTERVAL"
  #   continue
  # fi
done