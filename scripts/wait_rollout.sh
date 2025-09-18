#!/usr/bin/env bash
set -euo pipefail
NS="$1"       # namespace holding the app (flux-demo or argocd-demo)
DEPLOY="$2"   # deployment name (demo)

# Wait for new pods to be ready
kubectl -n "$NS" rollout status deploy/"$DEPLOY" --timeout=5m >/dev/null
# Return a stable "pod ready" timestamp
# date +%s%3N
python3 -c 'import time; print(int(time.time() * 1000))'