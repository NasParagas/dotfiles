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
install.sh    setup 時に実行する script
profiles/     対象 machine ごとの module
modules/      tool ことの設定、install 処理、 PATH 設定などが記載された script 郡
lib/          script で使用する処理関数置き場
```

tool の追加や変更をする際にいじるべきファイル等は [AGENTS.md](AGENTS.md) を参照。

## setup

```sh
git clone https://github.com/NasParagas/dotfiles.git ~/dotfiles
cd ~/dotfiles
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

- ツールのバージョンは `modules/mise/config/config.toml` で管理する。
- Ubuntu で `sudo` なしに `docker` を使う場合は、`DOCKER_ADD_USER_TO_GROUP=true` を付けて実行する。
- マシン固有の設定は、Git 管理外の `~/.config/dotfiles/local.sh` に書く。

### pull した後

リポジトリ内のファイルを移動した変更を取り込むと、古いリンクが切れて `.bashrc` などが読み込まれなくなる場合がある。
追加されたツールも入らないので、`pull` したらすぐ `install.sh` を実行し、新しいシェルを開く。

```sh
git pull
./install.sh <profile>
```

### リンクを元に戻す

間違えて共有環境で実行した場合などは、`install.sh` が作ったリンクを削除し、退避したファイルを戻せる。

```sh
./unlink.sh --dry-run   # 変更内容の確認
./unlink.sh
```

- 導入したパッケージやツールは削除しない。
- `install.sh` が途中で止まった場合も、そこまでのリンクを戻せる。
- `install.sh` の実行後に手で置き換えたパスは変更しない。
- 同じパスのバックアップが複数ある場合は、最新のものだけを戻す。

## 管理対象

### ツール

- neovim
- opencode
- claude
- mise で管理: node, uv, lazygit, just, tree-sitter
- herdr, wezterm, aerospace, docker

必要なマシンにだけ入れるツールや、管理していないツールの入れ方は [docs/tools.md](docs/tools.md) を参照。

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

# Ubuntu に ssh で入れるようにする場合（clone 後に実行）
bash ~/dotfiles/modules/sshd/ubuntu-host-minimal-setup.sh

# macOS
xcode-select --install
# Homebrew: https://brew.sh/
```


