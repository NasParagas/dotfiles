#!/usr/bin/env bash
# called shebang. determines how to execute this script
# execute /usr/bin/env and env finds and execute bash
# good for picking up bash even if its PATH is different

# -e: exits the script immediately if a command exits an error
# -u: treats undefined variables as an error
# -o pipefall: sets the exit status of the entire pipeline to the status of last command to fall
set -euo pipefail

# Apply symlink for the entire ~/.config to point at ~/dotfiles/.config
# - Backs up existing ~/.config (if it's a directory or file) with timestamp
# - Replaces existing symlink if it points elsewhere
# - Verifies result
#
# Usage:
#   chmod +x setup_config_symlink.sh
#   ./setup_config_symlink.sh
#
# Optional env vars:
#   DOTFILES_ROOT   (default: "$HOME/dotfiles")


# --- Settings ---
# "${VARS"-PATH"}" means set VARS to PATH if it isnt set
DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/dotfiles}"
# Now, add dotdir path here if you want to add symlink dotfiles considering safety
DOTFILES_CONFIG_DIR="$DOTFILES_ROOT/.config"
TARGET_CONFIG_DIR="$HOME/.config"

# --- Functions ---
msg() { echo -e "[\033[1;32mINFO\033[0m] $*"; }
warn() { echo -e "[\033[1;33mWARN\033[0m] $*"; }
err() { echo -e "[\033[1;31mERROR\033[0m] $*"; }

# --- Checks ---
if [ ! -d "$DOTFILES_CONFIG_DIR" ]; then
  err "Dotfiles .config directory not found: $DOTFILES_CONFIG_DIR"
  err "Ensure your dotfiles are under: $DOTFILES_ROOT/.config"
  exit 1
fi

# --- Backup existing ~/.config/nvim if present ---
if [ -e "$TARGET_CONFIG_DIR" ] && [ ! -L "$TARGET_CONFIG_DIR" ]; then
  ts=$(date '+%Y%m%d-%H%M%S')
  backup="$HOME/.config.backup-$ts"
  msg "Backing up existing ~/.config -> $backup"
  mv "$TARGET_CONFIG_DIR" "$backup"
elif [ -L "$TARGET_CONFIG_DIR" ]; then
  current_target=$(readlink "$TARGET_CONFIG_DIR")
  if [ "$current_target" = "$DOTFILES_CONFIG_DIR" ]; then
    msg "Symlink already points to $DOTFILES_CONFIG_DIR. Nothing to do."
    exit 0
  else
    warn "Existing ~/.config symlink points to: $current_target"
    msg "Replacing symlink to point to $DOTFILES_CONFIG_DIR"
    rm "$TARGET_CONFIG_DIR"
  fi
fi

# --- Create symlink ---
msg "Creating symlink: $TARGET_CONFIG_DIR -> $DOTFILES_CONFIG_DIR"
ln -s "$DOTFILES_CONFIG_DIR" "$TARGET_CONFIG_DIR"

# --- Verify ---
resolved_target=$(readlink -f "$TARGET_CONFIG_DIR")
resolved_source=$(readlink -f "$DOTFILES_CONFIG_DIR")
if [ "$resolved_target" = "$resolved_source" ]; then
  msg "Symlink created successfully: $TARGET_CONFIG_DIR -> $resolved_source"
else
  err "Symlink verification failed: $resolved_target != $resolved_source"
  exit 1
fi

cat << 'EOF'
Next steps:
  1) Launch Neovim and verify the loaded init file:
       :echo $MYVIMRC
       :scriptnames
  2) You should see something like:
       $HOME/dotfiles/.config/nvim/init.lua

Tip:
  - To revert, remove the symlink:
       rm $HOME/.config/nvim
    and restore your backup (if created):
       mv $HOME/.config/nvim.backup-<timestamp> $HOME/.config/nvim
EOF
