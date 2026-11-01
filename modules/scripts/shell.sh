# shellcheck shell=bash

# Toolchains installed on demand, by the setup-* scripts or by hand. Nothing
# happens on machines that don't have them.
if [ -r "$HOME/.cargo/env" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.cargo/env"
fi
path_prepend "$HOME/.elan/bin"
path_prepend "/opt/riscv/bin"
