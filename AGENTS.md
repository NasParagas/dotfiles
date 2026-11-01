# AGENTS.md

macOS と Ubuntu で共有する個人用 dotfiles。Neovim の設定が中心で、`./install.sh <profile>` で環境を構築する。

## 構成

- `install.sh`: 入口。プロファイルが指定したモジュールを順に処理する
- `unlink.sh`: `install.sh` が作ったリンクを削除し、バックアップを戻す。導入したツールは残す
- `profiles/`: マシンの役割ごとのモジュール一覧。全環境共通は `cli.sh`
- `modules/<name>/`: ツール単位の設定、インストール処理、シェル連携
- `lib/`: OS 判定、パッケージ導入、リンク処理
- `modules/nvim/config/`: Neovim 設定。詳細は同じディレクトリの `README.md` を読む

OS は `lib/os.sh` が自動判定し、プロファイルは役割だけを表す。

## モジュールの規約

ファイルはすべて任意。置くだけで次のように扱われる。

| ファイル | 扱い |
| --- | --- |
| `packages.brew` / `packages.apt` | 該当するパッケージマネージャーで導入する |
| `packages.cask` | macOS で Homebrew の cask として導入する。tap の cask は `owner/tap/name` と書く |
| `module.sh` の `module_links` | `link <モジュール内のパス> <リンク先>` を書く |
| `module.sh` の `module_install` | パッケージ以外のインストール処理を書く。冪等にする |
| `shell.sh` | `~/.config/bash/rc.d/<name>.sh` にリンクする |
| `bin/*` | `~/.local/bin/` にリンクする。実行権限を付ける |

処理順は、パッケージ導入、リンク、`module_install`。

## 変更の置き場所

- 設定のない CLI ツール: `modules/mise/config/config.toml` に1行足す
- OS に近いパッケージ: `modules/base/packages.*` に1行足す
- 設定やシェル連携が必要なツール: `modules/<name>/` を作り、プロファイルに足す
- ツール固有の実行ファイル: `modules/<tool>/bin/`
- 汎用の実行ファイル: `modules/scripts/bin/`
- マシン固有の値: Git 管理外の `~/.config/dotfiles/local.sh`。リポジトリに入れない

## 実装時の注意

- `install.sh`、`unlink.sh`、`lib/`、`profiles/`、`module.sh` は Bash 3.2 で動かす。新しい Mac の初回実行は標準の `/bin/bash` になるため、連想配列、`mapfile`、空配列の展開は使わない
- `shell.sh` はシェル起動のたびに読まれる。何も出力せず、外部コマンドの実行は最小限にする。`bashrc` の対話判定より前に読まれるので、対話時専用の処理は自分で `$-` を確認する
- OS 分岐の `case` には `*) unsupported_os ;;` を入れ、未対応の OS を黙って通さない。モジュールを追加するときは、`module_install` を再実行しても壊れないようにする
- `~/.bashrc` や `~/.config/nvim` などはこのリポジトリへのリンクなので、編集はすぐ実環境に反映される。ファイルを移動すると実環境のリンクが切れるので、移動後は `./install.sh <profile> --link-only` を実行する
- `lazy-lock.json` は Neovim が更新する。手で編集しない
- このリポジトリは `core.fileMode=false` なので、`chmod` だけでは実行権限が Git に記録されない。新しい実行ファイルは `git add --chmod=+x <file>` で追加する

## 確認

```sh
shellcheck -x -e SC1091 -s bash install.sh unlink.sh lib/*.sh profiles/*.sh \
  modules/*/module.sh modules/*/shell.sh modules/bash/bashrc

# 実環境に触れずにリンク処理を確認する
HOME="$(mktemp -d)" /bin/bash ./install.sh container --link-only

# Neovim の Lua を変更したとき
(cd modules/nvim/config && stylua --check init.lua lua after)
```

`.github/workflows/install.yml` が Ubuntu での実インストールと、macOS でのリンク処理を確認する。

## コミット

メッセージは `add:`、`update:`、`fix:` のような接頭辞に、短い日本語の説明を続ける。
