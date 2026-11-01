#!/usr/bin/env bash
# shellcheck shell=bash

create_module_symlinks() {
    symlink bashrc "${HOME}/.bashrc"
    symlink bash_profile "${HOME}/.bash_profile"
}
