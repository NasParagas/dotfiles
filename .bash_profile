if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# Added by `rbenv init` on Sun Mar 29 15:24:51 JST 2026
eval "$(rbenv init - --no-rehash bash)"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
