#!/usr/bin/env bash
set -euo pipefail

local red=$(tput setaf 1 2>/dev/null)
local green=$(tput setaf 2 2>/dev/null)
local cyan=$(tput setaf 6 2>/dev/null)
local reset=$(tput sgr0 2>/dev/null)

command diff -u "$@" | awk "
  /^\-/ { printf \"%s\", \"$red\" }
  /^\+/ { printf \"%s\", \"$green\" }
  /^@/ { printf \"%s\", \"$cyan\" }
  { print \$0 \"$reset\" }
"

return "${PIPESTATUS[0]}"
