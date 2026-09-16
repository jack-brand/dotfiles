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

ZDOTDIR="$HOME/.zsh"
mkdir -p "$ZDOTDIR"
mkdir -p "$ZDOTDIR/plugins"

replace "$SCRIPT_DIR/zsh/zshrc" "$ZDOTDIR/zshrc"
replace "$SCRIPT_DIR/zsh/zprofile" "$ZDOTDIR/zprofile"
replace "$SCRIPT_DIR/zsh/zshenv" "$ZDOTDIR/zshenv"

printf 'source "%s/zshenv"\n' "$ZDOTDIR" > "$HOME/.zshenv"
printf 'source "%s/zprofile"\n' "$ZDOTDIR" > "$HOME/.zprofile"
printf 'source "%s/zshrc"\n' "$ZDOTDIR" > "$HOME/.zshrc"

clone_zsh_plugin() {
    local repo="$1"
    local name="${repo##*/}"
    local path="$ZDOTDIR/plugins/$name"

    if [[ ! -d "$path" ]]; then
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
