#!/usr/bin/env bash
set -euo pipefail

wf-recorder -r 60 -f "${1:-$(date -u +%Y-%m-%d_%H-%M-%S)}.mkv"

true
