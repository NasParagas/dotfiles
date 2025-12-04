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

- neovim
- lazygit
- deno
- kickstarterの依存
- pyright
- rust

