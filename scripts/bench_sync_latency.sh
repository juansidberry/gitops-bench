#!/usr/bin/env bash
set -euo pipefail
REPO_DIR="${1:-$PWD}"          # path to your cloned gitops-bench
echo "Using repo dir: $REPO_DIR"
NS="$2"                        # flux-demo OR argocd-demo
DEPLOY="demo"
OLD_TAG="${3:-1.25.5}"
NEW_TAG="${4:-1.27.0}"         # pick a different valid nginx tag

cd "$REPO_DIR"

# 1) Change image tag
sed -i.bak "s|nginx:${OLD_TAG}|nginx:${NEW_TAG}|g" workloads/app/base/deployment.yaml

# 2) Commit and push
git add workloads/app/base/deployment.yaml
git commit -m "bench: bump image to ${NEW_TAG}"
# git push
git push > /dev/null 2>git_errors.log

# 3) Start timers (local wall clock) & wait for rollout
# T0=$(date +%s%3N) # for Linux, use date for milliseconds
T0=$(python3 -c 'import time; print(int(time.time() * 1000))') # For macOS, use Python for milliseconds
T_READY=$(scripts/wait_rollout.sh "$NS" "$DEPLOY")
ELAPSED=$((T_READY - T0))

echo "SYNC_LATENCY_MS,${NS},${OLD_TAG}->${NEW_TAG},${ELAPSED}"