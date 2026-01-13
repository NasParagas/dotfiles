# dotfiles

TODO: container化

## 手順

- `git clone`
- `./setup_config_symlink.sh`

## 注意

- windows+weztermの場合、weztermのプロパティに`--config-file`を設定する必要あり

## 使用環境

- wezterm
- neovim
 
## 依存
 
- ripgrep(telescope.nvim)
```bash
sudo apt-get install ripgrep
```
- lazygit
```bash
sudo apt install lazygit
```
- deno(どれだっけ)
```bash
curl -fsSL https://deno.land/install.sh | sh
```
- kickstarterの依存
- pyright
```bash
sudo apt install -y npm
:MansonInstall pyright
```
- clangd
 
```bash
# Ubuntu
sudo apt install -y unzip
:MasonInstall clangd
```
 
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
