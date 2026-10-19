export XDG_CONFIG_HOME="$HOME/.config"

source "$XDG_CONFIG_HOME/shell/env.sh"

if [[ -d "/usr/local/share/zsh" ]]; then
    fpath=(
        "/usr/local/share/zsh/functions"
        "/usr/local/share/zsh/site-functions"
        $fpath
    )
fi

if [[ -d "$BREWDIR/share/zsh" ]]; then
    fpath=(
        "$BREWDIR/share/zsh/functions"
        "$BREWDIR/share/zsh/site-functions"
        $fpath
    )
fi
