#!/usr/bin/env bash
set -euo pipefail

for i in 1 2 3 4 5; do /
	./scripts/bench_sync_latency.sh ./ flux-demo 1.25.5 1.27.0; /
	sleep 1; /
	./scripts/bench_sync_latency.sh ./ argocd-demo 1.27.0 1.25.5; /
	sleep 1; /
done