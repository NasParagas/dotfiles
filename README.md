# dotfiles

## 手順(既存`.bashrc`を管理するまでを例として)

- `git clone`
- `$HOME/dotfiles`に`clone`したとする
- `cp ~/.bashrc ~/dotfiles`
- `mkdir -p ~/dotfiles_bk` 
- `mv ~/.bashrc ~/dotfiles_bk`
- `ln -s ~/dotfiles/.bashrc ~`

## 注意

- windows+weztermの場合、weztermのプロパティに`--config-file`を設定する必要あり

## 依存


- lazygit
- deno
- kickstarterの依存
- pyright
- rust

## その他環境
- pixi
  - https://pixi.sh/dev/installation/

```bash
curl -fsSL https://pixi.sh/install.sh | sh
# or
brew install pixi
``

- neovim
