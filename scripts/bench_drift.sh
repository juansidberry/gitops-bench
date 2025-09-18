#!/usr/bin/env bash
set -euo pipefail
# NS="$1"      # flux-demo or argocd-demo
# DEPLOY="demo"

# # Delete managed resource to induce drift
# kubectl -n "$NS" delete deploy/"$DEPLOY" --wait=false || true

# # T0=$(date +%s%3N) # for Linux, use date for milliseconds
# T0=$(python3 -c 'import time; print(int(time.time() * 1000))') # For macOS, use Python for milliseconds

# # Wait until Deployment is recreated and Ready
# # (first wait until object exists again)
# echo "Waiting for deployment to reappear..."
# until kubectl -n "$NS" get deploy/"$DEPLOY" >/dev/null 2>&1; do sleep 1; done

# T_READY=$(scripts/wait_rollout.sh "$NS" "$DEPLOY")
# ELAPSED=$((T_READY - T0))
# echo "DRIFT_REPAIR_MS,${NS},${ELAPSED}"
# echo ${NS},${ELAPSED}" >> drift_results.csv


set -euo pipefail

CSV_FILE="drift_results.csv"
DEPLOY="demo"

# Write CSV header
echo "run,app,namespace,elapsed-time" > "$CSV_FILE"

for APP_NS in "flux flux-demo" "argocd argocd-demo"; do
  read -r APP NS <<< "$APP_NS"

  for RUN in {1..5}; do
    echo "Run $RUN for app=$APP, namespace=$NS"

    # Delete managed resource to induce drift
    kubectl -n "$NS" delete deploy/"$DEPLOY" --wait=false || true

    # Get start time in milliseconds
    T0=$(python3 -c 'import time; print(int(time.time() * 1000))')

    # Wait until Deployment is recreated and Ready
    echo "Waiting for deployment to reappear..."
    until kubectl -n "$NS" get deploy/"$DEPLOY" >/dev/null 2>&1; do sleep 1; done

    T_READY=$(scripts/wait_rollout.sh "$NS" "$DEPLOY")
    ELAPSED=$((T_READY - T0))

    # Append result to CSV
    echo "${RUN},${APP},${NS},${ELAPSED}" >> "$CSV_FILE"
  done
done