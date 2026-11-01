#!/usr/bin/env bash
# shellcheck shell=bash

# NOTE:
# - 全 profile で共通の module。他の profile が読み込む部品で、単体では指定できない
# - module は上から順に処理する。module が export した PATH は後続の module にも引き継がれる
# - `base` は先頭に置く。brew の PATH や sudo を確認し、後続が使う curl などを導入する
# - `mise` は、mise が導入するツールを使う module より前に置く

[[ "${PROFILE}" != "cli" ]] || die "profile 'cli' is shared by the other profiles; choose one of them"

# shellcheck disable=SC2034 # read by install.sh
MODULES=(base bash scripts mise nvim clangd herdr opencode)
