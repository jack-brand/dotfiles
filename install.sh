#!/usr/bin/env bash

# This script symlinks config files to `~/` and `~/.config/`.
# To update the config files, simply execute `git pull` in this SCRIPT_DIR.

# Author: Jack Brand <74jdvb@gmail.com>
# Credit: Dave Eddy <dave@daveeddy.com> <https://github.com/bahamas10/dotfiles>
# License: MIT

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"

git -C "$SCRIPT_DIR" submodule update --init --recursive

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$CONFIG_DIR"

manually_symlinked=()

replace() {
    local src="$1"
    local dst="$2"

    if [[ -e "$dst" || -L "$dst" ]]; then
        printf 'Replace %s with %s? [y/N] ' \
            "${dst/#$HOME/\~}" \
            "${src/#$HOME/\~}"
        read -r reply

        [[ "$reply" == [yY] ]] || {
            printf 'Skipped %s\n' "${dst/#$HOME/\~}"
            return
        }

        rm -rf "$dst"
    fi

    ln -s "$src" "$dst"
}

# Git

replace "$SCRIPT_DIR/gitconfig" "$HOME/.gitconfig"

# Bash

manually_symlinked+=('bash')

SCRIPT_BASH_DIR="$SCRIPT_DIR/config/bash"

BASH_DIR="$CONFIG_DIR/bash"
mkdir -p "$BASH_DIR"

replace "$SCRIPT_BASH_DIR/bashrc" "$BASH_DIR/bashrc"
if [[ -f "$HOME/.bashrc" ]]; then
    rm "$HOME/.bashrc"
fi
ln -s "$BASH_DIR/bashrc" "$HOME/.bashrc"

# Zsh

manually_symlinked+=('zsh')

SCRIPT_ZSH_DIR="$SCRIPT_DIR/config/zsh"

ZSH_DIR="$CONFIG_DIR/zsh"
mkdir -p "$ZSH_DIR"

for name in 'zshrc' 'zprofile' 'zshenv'; do
    replace "$SCRIPT_ZSH_DIR/$name" "$ZSH_DIR/.$name"
    if [[ -f "$HOME/.$name" ]]; then
        rm "$HOME/.$name"
    fi
done

printf 'export ZDOTDIR=\"%s\"\n' "$ZSH_DIR" > "$HOME/.zshenv"

clone_zsh_plugin() {
    mkdir -p "$ZSH_DIR/plugins"

    local repo="$1"
    local name="${repo##*/}"
    local path="$ZSH_DIR/plugins/$name"

    if [[ ! -d "$path" ]]; then
        git clone --depth=1 "https://github.com/$repo" "$path"
    fi
}

clone_zsh_plugin "Aloxaf/fzf-tab"
clone_zsh_plugin "zsh-users/zsh-autosuggestions"
clone_zsh_plugin "zsh-users/zsh-syntax-highlighting"
clone_zsh_plugin "zsh-users/zsh-history-substring-search"

# Vim

manually_symlinked+=('vim')

SCRIPT_VIM_DIR="$SCRIPT_DIR/config/vim"

VIM_DIR="$CONFIG_DIR/vim"
mkdir -p "$VIM_DIR"

replace "$SCRIPT_VIM_DIR/vimrc" "$VIM_DIR/vimrc"

# Vis

manually_symlinked+=('vis')

SCRIPT_VIS_DIR="$SCRIPT_DIR/config/vis"

VIS_DIR="$CONFIG_DIR/vis"
mkdir -p "$VIS_DIR"

replace "$SCRIPT_VIS_DIR/visrc.lua" "$VIS_DIR/visrc.lua"

for subdir in 'plugins' 'themes'; do
    mkdir -p "$VIS_DIR/$subdir"
    
    for path in "$SCRIPT_VIS_DIR/$subdir"/*; do
        name="${path##*/}"
        replace "$path" "$VIS_DIR/$subdir/$name"
    done
done

# Symlink directories

for path in "$SCRIPT_DIR/config"/*; do
    name="${path##*/}"

    for excluded in "${manually_symlinked[@]}"; do
        [[ "$name" == "$excluded" ]] && continue 2
    done

    replace "$path" "$CONFIG_DIR/$name"
done

# MacOS

if [[ "$(uname)" == "Darwin" ]]; then
    MAC_SCRIPT_DIR="$SCRIPT_DIR/mac"

    KEYBIND_DIR="$HOME/Library/KeyBindings"
    mkdir -p "$KEYBIND_DIR"
    replace "$MAC_SCRIPT_DIR/DefaultKeyBindings.dict" "$KEYBIND_DIR/DefaultKeyBindings.dict"

    "$BASH" "$MAC_SCRIPT_DIR/mac_defaults.sh"
fi

true
