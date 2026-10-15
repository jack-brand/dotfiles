#!/usr/bin/env bash
set -eu

if command -v wl-copy &>/dev/null; then
    wl-copy
elif command -v xclip &>/dev/null; then
    xclip -selection clipboard
elif command -v xsel &>/dev/null; then
    xsel --clipboard --input
elif command -v pbcopy &>/dev/null; then
    pbcopy
fi
