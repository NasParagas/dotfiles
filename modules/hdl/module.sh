#!/usr/bin/env bash
# shellcheck shell=bash

module_install() {
    "${MODULE_DIR}/bin/setup-hdl-tools"
    mise reshim
}
