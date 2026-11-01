#!/usr/bin/env bash
# shellcheck shell=bash

# Modules shared by every profile. Order matters: modules run top to bottom,
# and `mise` must run before anything that needs the tools it installs.
# shellcheck disable=SC2034 # read by install.sh
MODULES=(base bash scripts mise rust nvim clangd herdr opencode)
