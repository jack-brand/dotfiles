#!/usr/bin/env bash
set -euo pipefail

latexmk -lualatex -synctex=1 -interaction=nonstopmode -file-line-error -f "${1:-main.tex}"

