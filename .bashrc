# ~/.bashrc: executed by bash(1) for non-login shells.
# shellcheck shell=bash
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't source this file.
case $- in
*i*) ;;
*) return ;;
esac

### history config
# don't put duplicate lines in the ./.bash_history
HISTCONTROL=ignoredups
# append to the history file, don't overwrite it
shopt -s histappend
# size of bash session history
HISTSIZE=10000
# size of .bash_history
HISTFILESIZE=20000

# update the values of LINES and COLUMNS after each command
shopt -s checkwinsize

os_name="$(uname -s)"

case "$os_name" in
Darwin)
    # macOS shows a default-shell migration warning when Bash is used.
    export BASH_SILENCE_DEPRECATION_WARNING=1

    # "notes" alias for iCloud notes.
    notes() {
        cd "${HOME}/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes" || return
    }
    ;;
Linux)
    # make `less` more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    # enable color support for some commands
    if [ -x /usr/bin/dircolors ]; then
        if [ -r ~/.dircolors ]; then
            eval "$(dircolors -b ~/.dircolors)"
        else
            eval "$(dircolors -b)"
        fi
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
    fi

    # enable programmable completion features
    if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
            # shellcheck source=/dev/null
            . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
            # shellcheck source=/dev/null
            . /etc/bash_completion
        fi
    fi
    ;;
esac

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [ -f ~/.bash_aliases ]; then
    # shellcheck source=/dev/null
    . ~/.bash_aliases
fi

#############
# user setting
#############
# Warn only about tools the setup scripts install on every host.
# Optional tools (RISC-V, opencode, ...) are added silently when present.
warn_missing() {
    printf '[WARN] .bashrc: %s\n' "$*" >&2
}

# Use a compact colored prompt for interactive shells.
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "

# Rust
if [ -r "$HOME/.cargo/env" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.cargo/env"
else
    warn_missing "Rust environment file not found: $HOME/.cargo/env"
fi

# User-local executable path
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
else
    warn_missing "user-local bin directory not found: $HOME/.local/bin"
fi

# RISC-V toolchain (riscv-gnu-toolchain, installed by get-riscv-toolchain.sh)
if [ -d "/opt/riscv/bin" ]; then
    export PATH="/opt/riscv/bin:$PATH"
fi

# Node.js via nvm. Node-based LSP servers such as bash-language-server depend on this.
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    # shellcheck source=/dev/null
    . "$NVM_DIR/nvm.sh"
    if ! command -v node >/dev/null 2>&1; then
        warn_missing "node is not available after loading nvm"
    fi
else
    warn_missing "nvm is not installed: $NVM_DIR/nvm.sh"
fi

# uv
if command -v uv >/dev/null 2>&1; then
    eval "$(uv generate-shell-completion bash)"
else
    warn_missing "uv is not installed; shell completion skipped"
fi
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# opencode
if [ -d "$HOME/.opencode/bin" ]; then
    export PATH="$HOME/.opencode/bin:$PATH"
fi
