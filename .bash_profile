if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# Added by `rbenv init` on Sun Mar 29 15:24:51 JST 2026
if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init - --no-rehash bash)"
fi
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

export PATH="$HOME/.elan/bin:$PATH"
