#!/usr/bin/env bash
# shellcheck shell=bash

require_os ubuntu
# shellcheck source=profiles/cli.sh
source "${PROFILE_DIR}/cli.sh"
MODULES+=(docker)
