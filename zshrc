# Environment

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:/Applications/Wolfram.app/Contents/MacOS"
export PATH="$PATH:$HOME/hep/lhapdf/6.5.6/bin"

export SHELL="/opt/homebrew/bin/zsh"

export HOMEBREW_NO_AUTO_UPDATE=1

export LHAPDF_DATA_PATH="$(lhapdf-config --datadir)"
export LHAPDF_DATADIR="$(lhapdf-config --datadir)"

export PAGER="less"
export LESS="-R -F -X"
export BAT_PAGER="less -R"

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
# export FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always {}'"

# Zsh

fpath=(
    /opt/homebrew/share/zsh/functions
    /opt/homebrew/share/zsh/site-functions
    $fpath
)

unsetopt correct_all
setopt interactivecomments
setopt prompt_subst
setopt EXTENDED_GLOB

autoload -Uz colors zmv
colors

# autoload -Uz add-zsh-hook

# Completion

autoload -Uz compinit
compinit

zstyle ":completion:*" menu no

# Plugins

source "/opt/homebrew/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh"
source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "/opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=243"

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=(bg=8)
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=(bg=1)

# History

HISTFILE=$HOME/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt sharehistory
setopt histignorealldups

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Prompt

VIRTUAL_ENV_DISABLE_PROMPT=1

PS1=$'\n'
PS1+='${VIRTUAL_ENV:+($(basename "$VIRTUAL_ENV")) }'
PS1+='[%~]'
PS1+=$'\n'
PS1+='%F{green}%%%f '

# External tools

zoxide() {
    unfunction zoxide
    eval "$(command zoxide init zsh)"
    command zoxide "$@"
}

eval "$(direnv hook zsh)"

# Editor

if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR="/usr/bin/vim"
else
    export EDITOR="/opt/homebrew/bin/gram"
fi

# Aliases

alias ls="eza -al --no-user --changed --git"
alias help="bat --language=help --style=plain"
alias tree="eza --tree"
copy() { pbcopy 2>/dev/null || xsel 2>/dev/null || clip.exe }
palette() { fastfetch --structure colors --logo none }
