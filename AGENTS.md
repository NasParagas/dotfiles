# AGENTS.md

macOS と Ubuntu で共有する個人用 dotfiles

## 構成

- `install.sh`: profile が指定した module を順に処理する setup 用 script
- `unlink.sh`: `install.sh` が作った symlink を削除し、backup から復元する( install した tool はそのまま)
- `profiles/`: profile ごとの module 一覧。 `cli.sh` は他の profile が読み込む共通部品で、単体では指定できない
- `modules/<name>/`: ツール単位の設定、インストール処理、シェル連携
- `lib/`: script で用いる処理関数置き場
- `modules/nvim/config/`: Neovim 設定。詳細は同じディレクトリの `README.md` を読む

OS は `lib/os.sh` が自動判定し、プロファイルは役割だけを表す。

## モジュールの規約

必要なファイルだけ配置、記載する。それぞれ次のように扱われる。

| ファイル | 扱い |
| --- | --- |
| `packages.****` | 該当するパッケージマネージャーで導入する(tap の cask は `owner/tap/name` と書く) |
| `bin/*` | `~/.local/bin/` にリンクする。実行権限を付ける |
| `rc.d/*` | `~/.config/bash/rc.d/` にリンクする。ファイル名は `<module>.sh` にする。`bashrc` が定義する `path_prepend` を使える |
| `module.sh` の `prepare_module` | パッケージ導入より前に行う前提の確認を書く |
| `module.sh` の `create_module_symlinks` | その他のリンクを `symlink <モジュール内のパス> <リンク先>` で書く |
| `module.sh` の `install_module_extras` | パッケージ以外のインストール処理を書く。冪等にする |

処理順は、`prepare_module`、パッケージ導入、リンク、`install_module_extras`。`--link-only` のときはリンクだけを処理する。

`module.sh` のトップレベルには関数と定数だけを書き、処理は上の関数に入れる。

`rc.d/*` はファイル名の順に読まれ、後に読まれたものほど `path_prepend` した PATH が優先される。

### `module.sh` で使えるもの

`install.sh` と `lib/` が用意する。

| 変数 | 内容 |
| --- | --- |
| `OS` | `darwin` または `ubuntu` |
| `PKG_MANAGER` | `brew` または `apt` |
| `MODULE` | 処理中の module 名 |
| `MODULE_DIR` | 処理中の module のディレクトリ |
| `TMP_DIR` | `make_tmp_dir` が作ったディレクトリ |

| 関数 | 内容 |
| --- | --- |
| `symlink <モジュール内のパス> <リンク先>` | シンボリックリンクを作り、manifest に記録する |
| `info`、`warn`、`die` | メッセージを表示する。`die` は終了する |
| `have <コマンド>` | コマンドの有無を確認する |
| `run_as_root <コマンド>` | root で実行する。必要なときだけ `sudo` を使う |
| `die_unsupported_os` | 未対応の OS として終了する |
| `make_tmp_dir` | 終了時に消える一時ディレクトリを作り、`TMP_DIR` に入れる |
| `ensure_local_bin` | `~/.local/bin` を作り、`PATH` に足す |

profile では `require_os <OS>` で対応 OS を指定できる。module が export した `PATH` は後続の module に引き継がれる。

## 変更の置き場所

- 設定のない CLI ツール: `modules/mise/config/config.toml` に1行足す
- OS に近いパッケージ: `modules/base/packages.*` に1行足す
- 設定やシェル連携が必要なツール: `modules/<name>/` を作り、プロファイルに足す
- ツール固有の実行ファイル: `modules/<tool>/bin/`
- 汎用の実行ファイル: `modules/scripts/bin/`
- 必要なマシンにだけ手動で入れるツール: `modules/scripts/bin/setup-<name>`
- 特定のプロジェクトでしか使わないツール: dotfiles に入れず、そのプロジェクトの `mise.toml` や Dockerfile に書く
- どれにも当たらない、手順だけ残すツール: `docs/tools.md`
- マシン固有の値: Git 管理外の `~/.config/dotfiles/local.sh`。リポジトリに入れない。対話シェルでのみ読まれる

## 実装時の注意

- `install.sh`、`unlink.sh`、`lib/`、`profiles/`、`module.sh` は Bash 3.2 で動かす。新しい Mac の初回実行は標準の `/bin/bash` になるため、連想配列、`mapfile`、空配列の展開は使わない
- `rc.d/*` はシェル起動のたびに読まれる。何も出力せず、外部コマンドの実行は最小限にする。`bashrc` の対話判定より前に読まれるので、対話時専用の処理は自分で `$-` を確認する
- OS 分岐の `case` には `*) die_unsupported_os ;;` を入れ、未対応の OS を黙って通さない。モジュールを追加するときは、`install_module_extras` を再実行しても壊れないようにする
- `~/.bashrc` や `~/.config/nvim` などはこのリポジトリへのリンクなので、編集はすぐ実環境に反映される。ファイルを移動すると実環境のリンクが切れるので、移動後は `./install.sh <profile> --link-only` を実行する
- `lazy-lock.json` は Neovim が更新する。手で編集しない
- このリポジトリは `core.fileMode=false` なので、`chmod` だけでは実行権限が Git に記録されない。新しい実行ファイルは `git add --chmod=+x <file>` で追加する

## 確認

```sh
shellcheck -x -e SC1091 -s bash install.sh unlink.sh lib/*.sh profiles/*.sh \
  modules/*/module.sh modules/*/rc.d/*.sh modules/bash/bashrc

# 実環境に触れずにリンク処理を確認する
HOME="$(mktemp -d)" /bin/bash ./install.sh container --link-only

# Neovim の Lua を変更したとき
(cd modules/nvim/config && stylua --check init.lua lua after)
```

`.github/workflows/install.yml` が Ubuntu での実インストールと、macOS でのリンク処理を確認する。

## コミット

メッセージは `add:`、`update:`、`fix:` のような接頭辞に、短い日本語の説明を続ける。
