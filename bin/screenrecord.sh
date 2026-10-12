#!/usr/bin/env sh
set -eu

wf-recorder -r 60 -f "${1:-$(date -u +%Y-%m-%d_%H-%M-%S)}.mkv" &

