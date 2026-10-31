#!/usr/bin/env bash

# This script symlinks config files to `~/` and `~/.config/`.
# To update the config files, simply execute `git pull` in
# this REPO_DIR.

# Author: Jack Brand <74jdvb@gmail.com> <https://github.com/jack-brand>
# Credit: Dave Eddy <dave@daveeddy.com> <https://github.com/bahamas10/dotfiles>

set -euo pipefail

THIS_SCRIPT_NAME="${0##*/}"

YES=false
while (($#)); do
    case "$1" in
        "-y"|"--yes")
            YES=true
            ;;
        "--jack")
            JACK=true
            ;;
        *)
            printf '%s: Unknown option: %s\n' \
                "$THIS_SCRIPT_NAME" "$1" >&2
            exit 1
            ;;
    esac
    shift
done

REPO_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"

git -C "$REPO_DIR" submodule update --init --recursive --remote

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$XDG_CONFIG_HOME"

XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
mkdir -p "$XDG_DATA_HOME"

manually_symlinked=()

replace() {
    local src="$1"
    local dst="$2"

    local src_print="${src/#$HOME/~}"
    local dst_print="${dst/#$HOME/~}"

    if [[ -e "$dst" || -L "$dst" ]]; then
        if [[ "$YES" != true ]]; then
            printf 'Replace %s with %s? [y/N] ' \
                "$dst_print" "$src_print"
            read -r reply

            [[ "$reply" == [yY] ]] || {
                printf 'Skipped %s\n' "$dst_print"
                return
            }
        fi

        rm -rf "$dst"
    fi

    ln -s "$src" "$dst"
    printf 'Linked %s -> %s\n' "$dst_print" "$src_print"
}

# Git

if $JACK; then
    replace "$REPO_DIR/config/git/gitconfig" "$HOME/.gitconfig"
fi

# Bash

manually_symlinked+=('bash')

BASH_DIR="$XDG_CONFIG_HOME/bash"

replace "$REPO_DIR/config/bash" "$BASH_DIR"

for name in 'bashrc' 'bash_profile'; do
    if [[ -f "$HOME/.$name" ]]; then
        rm "$HOME/.$name"
    fi
done

ln -s "$BASH_DIR/bash_profile" "$HOME/.bash_profile"

# Zsh

manually_symlinked+=('zsh')

ZSH_DIR="$XDG_CONFIG_HOME/zsh"

replace "$REPO_DIR/config/zsh" "$ZSH_DIR"

for name in 'zshrc' 'zprofile' 'zshenv'; do
    if [[ -f "$HOME/.$name" ]]; then
        rm "$HOME/.$name"
    fi
done

printf 'export ZDOTDIR=\"%s\"\n' "$ZSH_DIR" > "$HOME/.zshenv"


ZSH_PLUG_DIR="$XDG_DATA_HOME/zsh"
mkdir -p "$ZSH_PLUG_DIR"

clone_zsh_plugin() {
    local repo="$1"
    local name="${repo##*/}"
    local path="$ZSH_PLUG_DIR/$name"

    if [[ ! -d "$path" ]]; then
        git clone --depth=1 "https://github.com/$repo" "$path"
    fi
}

clone_zsh_plugin "Aloxaf/fzf-tab"
clone_zsh_plugin "zsh-users/zsh-autosuggestions"
clone_zsh_plugin "zsh-users/zsh-syntax-highlighting"
clone_zsh_plugin "zsh-users/zsh-history-substring-search"

# Github
# (manually symlink so that hosts.yml is not exposed in the repo)

manually_symlinked+=('gh')

GITHUB_DIR="$XDG_CONFIG_HOME/gh"
mkdir -p "$GITHUB_DIR"

replace "$REPO_DIR/config/gh/config.yml" \
    "$GITHUB_DIR/config.yml"

# Spotatui

SPOTATUI_DIR="$XDG_CONFIG_HOME/spotatui"
mkdir -p "$SPOTATUI_DIR"

printf 'behavior:\n  enable_global_song_count: true' > "$SPOTATUI_DIR/config.yml"

# Other

for path in "$REPO_DIR/config"/*; do
    name="${path##*/}"

    for excluded in "${manually_symlinked[@]}"; do
        if [[ "$name" == "$excluded" ]]; then
            continue 2
        fi
    done

    replace "$path" "$XDG_CONFIG_HOME/$name"

	if [[ "$name" == 'bat' ]] && command -v bat >/dev/null 2>&1; then
		bat cache --build
	fi
done

# Bin

for repo_path in "$REPO_DIR/bin"/*; do
    name="${repo_path##*/}"
    path="$HOME/.local/bin/$name"
    replace "$repo_path" "$path"
    chmod +x "$path"
done

# Wallpapers

if [[ "$(uname)" == "Darwin" ]]; then
    PICS_DIR="$HOME/Pictures"
else
    PICS_DIR="$HOME/pictures"
fi
mkdir -p "$PICS_DIR"

replace "$REPO_DIR/wallpapers" "$PICS_DIR/wallpapers"

# Themes

THEME_DIR="$XDG_DATA_HOME/themes"
mkdir -p "$THEME_DIR"

for repo_path in "$REPO_DIR/themes"/*; do
	name="${repo_path##*/}"
	path="$THEME_DIR/$name"
	replace "$repo_path" "$path"
done

# MacOS

if [[ "$(uname)" == "Darwin" ]]; then
    MAC_REPO_DIR="$REPO_DIR/mac"

    KEYBIND_DIR="$HOME/Library/KeyBindings"
    mkdir -p "$KEYBIND_DIR"
    replace "$MAC_REPO_DIR/DefaultKeyBindings.dict" \
        "$KEYBIND_DIR/DefaultKeyBindings.dict"

    "$BASH" "$MAC_REPO_DIR/mac_defaults.sh"
fi

true
