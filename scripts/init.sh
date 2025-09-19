#!/usr/bin/env bash
set -euo pipefail

# Run script1.sh and script2.sh in parallel
# example: ./script2.sh &   # Run in background

# # this is the SYNC block
echo "TS,POD,CPU(m),MEM(Mi),NS,type" > "flux-system_resources.csv"
./scripts/bench_resources.sh flux-system 30 2 sync-latency &
./scripts/bench_sync_latency_loop.sh &
wait 
sleep 5   # wait a bit before starting next block

echo "TS,POD,CPU(m),MEM(Mi),NS,type" > "argocd_resources.csv"
./scripts/bench_resources.sh argocd 30 2 sync-latency &
./scripts/bench_sync_latency_loop.sh &   # Run in background
wait
sleep 5   # wait a bit before starting next block
echo "Benchmarking Sync/Latency completed."

# now run the DRIFT block
./scripts/bench_drift.sh
sleep 5   # wait a bit before starting next block

# ./scripts/bench_resources.sh argocd 120 2 drift &
# ./scripts/bench_drift.sh argocd-demo &
# wait

# echo "Benchmarking Drift is completed."