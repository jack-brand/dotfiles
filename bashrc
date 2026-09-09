#!/usr/bin/env bash
#
# Author: Jack Brand <74jdvb@gmail.com>
# Date: 2026
# License: MIT

# If not running interactively, do nothing
[[ -n $PS1 ]] || return

# Use vardump instead of parr
# alias parr='vardump'

# Set environment and configure bash
HISTCONTROL='ignoredups'
HISTSIZE=5000
HISTFILESIZE=5000

export EDITOR='vim'
export GREP_COLOR='1;36'
export LSCOLORS='ExGxbEaECxxEhEhBaDaCaD'
export MANPAGER='less'
export PAGER='less'
export VISUAL='vim'

# Support colors in less
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;33;44m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;1;32m'
export LESS_TERMCAP_mr=$'\e[7m'
export LESS_TERMCAP_mh=$'\e[2m'
export LESS_TERMCAP_ZN=$'\e[74m'
export LESS_TERMCAP_ZV=$'\e[75m'
export LESS_TERMCAP_ZO=$'\e[73m'
export LESS_TERMCAP_ZW=$'\e[75m'

# Path
PATH="$HOME/bin:$PATH"

# Shell options
shopt -s cdspell
shopt -s checkwinsize
shopt -s extglob

# Bash version >= 4
shopt -s dirspell 2>/dev/null || true

# Aliases

# Enable colour if supported
grep --color=auto < /dev/null &>/dev/null &&
    alias grep='grep --color=auto'

# command -v xdg-open &>/dev/null &&
#     alias open='xdg-open'

# command -v system_profiler &>/dev/null &&
#     alias wattage='system_profiler SPPowerDataType | grep Wattage'

# Enable color if supported
if ls --color=auto /dev/null &>/dev/null; then
    alias ls='ls -p --color=auto'
else
    alias ls='ls -p -G'
fi

# Prompt

# Store a `tput` colour array to reduce fork and exec.
# Indices are 0..255 -> colors, 256 -> sgr0 (reset), 257 -> bold
COLOR256=()
COLOR256[0]=$'\e[31m'
COLOR256[256]=$'\e[0m'
COLOR256[257]=$'\e[1m'

# Change the prompt colors, with possible options 0..29
PROMPT_COLORS=()
set_prompt_colors() {
    local h=${1:-0}
    local color=
    local i=0
    local j=0
    for i in {22..231}; do
        ((i % 30 == h)) || continue

        color=${COLOR256[i]}

        if [[ -z $color ]]; then
            color=$'\e[38;5;'${i}m
            COLOR256[i]=$color
        fi

        PROMPT_COLORS[j]=$color
        ((j++))
    done
}
set_prompt_colors 24

# (<exit code>)
# <user>@<hostname> [<current directory>]
# <prompt character>

# Exit code of last process
PS1='$(ret=$?;(($ret!=0)) && echo "\[${COLOR256[0]}\]($ret)\[${COLOR256[256]}\]\n")'

# User
PS1+='\[${PROMPT_COLORS[0]}\]\[${COLOR256[257]}\]\u\[${COLOR256[256]}\]@'

# Zonename (with global zone warning)
# PS1+='\[${COLOR256[0]}\]\[${COLOR256[257]}\]'"$(zonename 2>/dev/null | grep -q '^global$' && echo 'GZ:')"'\[${COLOR256[256]}\]'

# Hostname
PS1+='\[${PROMPT_COLORS[3]}\]\h '

# System
# PS1+='\[${PROMPT_COLORS[2]}\]'"$(uname | tr '[:upper:]' '[:lower:]')"' '

# Directory
PS1+='\[${PROMPT_COLORS[5]}\]\w'

# Git branch
# PS1+='$(branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); [[ -n $branch ]] && echo "\[${PROMPT_COLORS[2]}\](\[${PROMPT_COLORS[3]}\]git:$branch\[${PROMPT_COLORS[2]}\]) ")'

# Prompt character
PS1+='\n\[${PROMPT_COLORS[0]}\]\$\[${COLOR256[256]}\] '

# Prompt command
_prompt_command() {
    local user=$USER
    local host=${HOSTNAME%%.*}
    local pwd=${PWD/#$HOME/\~}
    local ssh=
    [[ -n $SSH_CLIENT ]] && ssh='[ssh] '
    printf "\033]0;%s%s@%s:%s\007" "$ssh" "$user" "$host" "$pwd"
}
PROMPT_COMMAND=_prompt_command

# Print a colorized diff
diff() {
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
}

# Print all 256 colors
# colors() {
# 	local i
# 	for i in {0..255}; do
# 		printf "\x1b[38;5;${i}mcolor %d\n" "$i"
# 	done
# 	printf '\e[0m'
# }

# Copy stdin to the clipboard
copy() {
    pbcopy 2>/dev/null ||
        xsel 2>/dev/null ||
        clip.exe
}

# Print colour palette
palette() {
    exec {fd}<>/dev/tty || fatal 'failed to open TTY'

    re='rgb:([0-9a-f]{4})\/([0-9a-f]{4})\/([0-9a-f]{4})'
    for code in 4\;{0..15} 10 11 12 17 19; do
        # Query the terminal for palette info
        printf '\e]%s;?\e\\' "$code" >&$fd

        # Read the response into a string (removing escape chars)
        read -rs -d '\\' -u "$fd" s
        s=${s//$'\e'}

        if ! [[ $s =~ $re ]]; then
            echo "$code = <failed>"
            continue
        fi

        # Parse the response
        r=${BASH_REMATCH[1]}
        g=${BASH_REMATCH[2]}
        b=${BASH_REMATCH[3]}

        r=$((16#$r / 257))
        g=$((16#$g / 257))
        b=$((16#$b / 257))

        printf '%s = #%02x%02x%02x\n' "$code" "$r" "$g" "$b"
    done
    exec {fd}>&-
}

# Print epoch as human readable (current date if no args)
epoch() {
    local num=${1:--1}
    printf '%(%B %d, %Y %-I:%M:%S %p %Z)T\n' "$num"
}

# Open the current path or file in GitHub
github() {
    local file=$1
    local remote=${2:-origin}

    # Get the git root dir, branch, and remote URL
    local gr=$(git rev-parse --show-toplevel)
    local branch=$(git rev-parse --abbrev-ref HEAD)
    local url=$(git config --get "remote.$remote.url")

    [[ -n $gr && -n $branch && -n $remote ]] || return 1

    # Construct the path
    local path=${PWD/#$gr/}
    [[ -n $file ]] && path+=/$file

    # Extract the username and repo name
    local a
    IFS=:/ read -a a <<< "$url"
    local len=${#a[@]}
    local user=${a[len-2]}
    local repo=${a[len-1]%.git}

    url="https://github.com/$user/$repo/tree/$branch$path"
    echo "$url"
    open "$url"
}

# Platform-independent interfaces
interfaces() {
    node <<-EOF
    var os = require('os');
    var i = os.networkInterfaces();
    Object.keys(i).forEach(function(name) {
        i[name].forEach(function(int) {
            if (int.family === 'IPv4') {
                console.log('%s: %s', name, int.address);
            }
        });
    });
    EOF
}

# Calculate CPU load per core
load() {
    node -p <<-EOF
    var os = require('os');
    var c = os.cpus().length;
    os.loadavg().map(function(l) {
        return (l/c).toFixed(2);
    }).join(' ');
    EOF
}

# Platform-independent memory usage
meminfo() {
    node <<-EOF
    var os = require('os');
    var free = os.freemem();
    var total = os.totalmem();
    var used = total - free;
    console.log('memory: %dmb / %dmb (%d%%)',
        Math.round(used / 1024 / 1024),
        Math.round(total / 1024 / 1024),
        Math.round(used * 100 / total));
    EOF
}

# Print lines over X columns (defaults to 56)
over() {
    awk -v c="${1:-56}" 'length($0) > c {
        printf("%4d %s\n", NR, $0);
    }'
}

# Print a rainbow if truecolor is available to the terminal
rainbow() {
    local i r g b
    for ((i = 0; i < 77; i++)); do
        r=$((255 - (i * 255 / 76)))
        g=$((i * 510 / 76))
        b=$((i * 255 / 76))
        ((g > 255)) && g=$((510 - g))
        printf '\033[48;2;%d;%d;%dm ' "$r" "$g" "$b"
    done
    printf '\e[0m\n'
}

# Follow redirects to untiny a tiny url
untiny() {
    local location=$1
    local last_location=''

    while [[ -n $location ]]; do
        [[ -n $last_location ]] && echo " -> $last_location"
        last_location=$location
        read -r _ location < \
            <(curl -sI "$location" | grep 'Location: ' | tr -d '[:cntrl:]')
    done
    echo "$last_location"
}

# Load external files
. ~/.bashrc.local 2>/dev/null || true

# Load completion
. /etc/bash/bash_completion 2>/dev/null ||
    . ~/.bash_completion 2>/dev/null

true
