if grep --color=auto < /dev/null &>/dev/null; then
    alias grep='grep --color=auto'
fi

if ls --color=auto /dev/null &>/dev/null; then
    alias ls='ls -lA --color=auto'
else
    alias ls='ls -lA'
fi

if diff --color=auto /dev/null &>/dev/null; then
    alias diff='diff -ud --color=always'
else
    alias diff='diff -ud'
fi

if command -v eza &>/dev/null; then
    alias ls="eza -al --no-user --changed --git"
    alias tree="eza --tree"
fi

if command -v bat &>/dev/null; then
    alias help="bat --language=help --style=plain"
fi
