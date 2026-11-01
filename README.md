# dotfiles

## 動作確認環境

- Linux 系
  - Ubuntu
    - 24.04
    - 26.04
- MacOS
  - 26.x
  - 27.x

## 構成

```text
install.sh    入口
profiles/     マシンの役割ごとのモジュール一覧
modules/      ツール単位の設定、インストール処理、シェル連携
lib/          OS 判定、パッケージ導入、リンク処理
```

追加や変更の置き場所は [AGENTS.md](AGENTS.md) を参照。

## setup

```sh
./install.sh <profile>
```

| profile | 用途 |
| --- | --- |
| `mac` | macOS ホスト |
| `workstation` | Ubuntu ワークステーション |
| `server` | GUI のない Ubuntu サーバー |
| `container` | Ubuntu の開発用コンテナ |

何度実行しても問題ない。既存のファイルは `<名前>.backup-<日時>` に退避する。
リンクだけを更新する場合は `--link-only` を付ける。

マシン固有の設定は、Git 管理外の `~/.config/dotfiles/local.sh` に書く。

### pull した後

リポジトリ内のファイルを移動した変更を取り込むと、古いリンクが切れて `.bashrc` などが読み込まれなくなる場合がある。
追加されたツールも入らないので、`pull` したらすぐ `install.sh` を実行し、新しいシェルを開く。

```sh
git pull
./install.sh <profile>
```

## 管理対象

### ツール

- neovim
- opencode
- claude
- mise で管理: node, uv, lazygit, just, tree-sitter, yarn
- rust, herdr, wezterm, aerospace, docker, HDL 関連ツール
- go, java, rbenv, lean

### その他

- `.bashrc`
- `.bash_profile`
- clangd の設定
- HackGen フォント

## とりあえず必要なもの

```sh
# linux
sudo apt update
sudo apt install git

# macOS
xcode-select --install
# Homebrew: https://brew.sh/
```


