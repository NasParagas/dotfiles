#!/usr/bin/env bash
# shellcheck shell=bash

# git は base で導入するので、この module はリンクだけを扱う。
# ~/.gitconfig にはメールアドレスや credential helper などマシン固有の値が入るため、リポジトリでは管理しない。
create_module_symlinks() {
    # core.excludesFile を設定しなくても git が読む既定の場所
    symlink config/ignore "${HOME}/.config/git/ignore"
}
