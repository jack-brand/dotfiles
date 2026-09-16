#!/usr/bin/env bash

# Symlink dotfiles to `~/` and `~/.config/`.
# Update dotfiles with `git pull` in this SCRIPT_DIR.

# Author: Jack Brand <74jdvb@gmail.com>
# Credit: Dave Eddy <dave@daveeddy.com> <https://github.com/bahamas10/dotfiles>
# License: MIT

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"

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

git submodule update --init --recursive

# home directory

dotfiles=(
    bashrc
    gitconfig
)

for f in "${dotfiles[@]}"; do
    replace "$SCRIPT_DIR/$f" "$HOME/.$f"
done

# zsh

replace "$SCRIPT_DIR/zsh/zshrc" "$HOME/.zshrc"
replace "$SCRIPT_DIR/zsh/zprofile" "$HOME/.zprofile"

if [[ "$(uname)" == "Darwin" ]]; then
    replace "$SCRIPT_DIR/zsh/zprofile.macos" "$HOME/.zprofile.local"
elif [[ "$(uname)" == "Linux" ]]; then
    replace "$SCRIPT_DIR/zsh/zprofile.linux" "$HOME/.zprofile.local"
fi

ZSH_PLUGIN_DIR="$HOME/.config/zsh/plugins"

clone_zsh_plugin() {
    local repo="$1"
    local name="${repo##*/}"
    local path="$ZSH_PLUGIN_DIR/$name"

    if [[ ! -d "$path" ]]; then
        mkdir -p "$ZSH_PLUGIN_DIR"
        git clone --depth=1 "https://github.com/$repo" "$path"
    fi
}

clone_zsh_plugin "Aloxaf/fzf-tab"
clone_zsh_plugin "zsh-users/zsh-autosuggestions"
clone_zsh_plugin "zsh-users/zsh-syntax-highlighting"
clone_zsh_plugin "zsh-users/zsh-history-substring-search"

# vim

mkdir -p "$HOME/.config/vim"

replace "$SCRIPT_DIR/vimrc" "$HOME/.config/vim/vimrc"

# config directory

mkdir -p "$HOME/.config"

for f in "$SCRIPT_DIR/config"/*; do
    name="${f##*/}"
    replace "$f" "$HOME/.config/$name"
done

# macOS

if [[ "$(uname)" == "Darwin" ]]; then
    mkdir -p ~/Library/KeyBindings
    replace "$SCRIPT_DIR/DefaultKeyBindings.dict" ~/Library/KeyBindings/DefaultKeyBindings.dict
    
    "$BASH" "$SCRIPT_DIR/macos_defaults.sh"
fi

true
