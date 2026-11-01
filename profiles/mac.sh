#!/usr/bin/env bash
# shellcheck shell=bash

require_os darwin
# shellcheck source=profiles/cli.sh
source "${PROFILE_DIR}/cli.sh"
MODULES+=(wezterm aerospace fonts hdl go java ruby lean)
