#!/usr/bin/env bash
# コマンド失敗、未定義変数、パイプ途中失敗を即座にエラー扱いにする。
set -euo pipefail

# 呼び出し側で DOTFILES_ROOT が未指定なら ~/dotfiles を使う。
DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/dotfiles}"
# シンボリックリンクのリンク先として使うため、repo ルートを絶対パスに正規化する。
SOURCE_ROOT="$(cd "$DOTFILES_ROOT" && pwd -P)"

# HOME 直下へリンクしたい dotfile / dotdir をここに列挙する。
TARGETS=(
  # 各種アプリ設定をまとめた ~/.config を管理する。
  ".config"
  # bash のログインシェル用設定を管理する。
  ".bash_profile"
  # bash の通常設定を管理する。
  ".bashrc"
  # zsh の設定を管理する。
  ".zshrc"
  # ~/.codex も管理したくなったらコメントアウトを外す。
  ".codex"
)

# 緑色の INFO ログを出す。
msg() { echo -e "[\033[1;32mINFO\033[0m] $*"; }
# 黄色の WARN ログを出す。
warn() { echo -e "[\033[1;33mWARN\033[0m] $*"; }
# 赤色の ERROR ログを出す。
err() { echo -e "[\033[1;31mERROR\033[0m] $*"; }

# 既存のファイルやディレクトリを、タイムスタンプ付きで退避する。
backup_target() {
  # 退避対象のフルパスを受け取る。
  local target_path="$1"
  # 連続実行でも衝突しにくい backup 名を作る。
  local backup_path="${target_path}.backup-$(date +%Y%m%d-%H%M%S)"

  # 何をどこへ退避するのかを表示する。
  warn "Existing $target_path found. Backing it up to $backup_path"
  # 削除せず mv で退避して、元の内容を残す。
  mv "$target_path" "$backup_path"
}

# allowlist にある 1 件分の symlink を作成する。
link_target() {
  # TARGETS に書いた相対パスを受け取る。
  local relative_path="$1"
  # repo 内のリンク元パスを組み立てる。
  local source_path="$SOURCE_ROOT/$relative_path"
  # HOME 配下のリンク先パスを組み立てる。
  local target_path="$HOME/$relative_path"

  # repo 側に対象がなければその場で失敗させる。
  if [[ ! -e "$source_path" && ! -L "$source_path" ]]; then
    err "Source not found in dotfiles repo: $source_path"
    return 1
  fi

  # 既に正しい symlink なら何もせず終了する。
  if [[ -L "$target_path" && "$(readlink "$target_path")" == "$source_path" ]]; then
    msg "Already linked: $target_path -> $source_path"
    return 0
  fi

  # 通常ファイル、ディレクトリ、誤った symlink があれば先に退避する。
  if [[ -e "$target_path" || -L "$target_path" ]]; then
    backup_target "$target_path"
  fi

  # repo 内の実体を指す symlink を HOME 配下に作る。
  msg "Linking $target_path -> $source_path"
  ln -s "$source_path" "$target_path"

  # 作成後に readlink でリンク先を検証する。
  if [[ -L "$target_path" && "$(readlink "$target_path")" == "$source_path" ]]; then
    msg "Linked successfully: $target_path"
  else
    err "Symlink verification failed: $target_path"
    return 1
  fi
}

# 対象一覧を先頭から順に処理し、どれか 1 件でも失敗したらスクリプト全体を止める。
for target in "${TARGETS[@]}"; do
  link_target "$target"
done
