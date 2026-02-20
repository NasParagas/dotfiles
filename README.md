# dotfiles

## 手順
- `git clone`
- `./setup_config_symlink.sh`

## 注意
- windows+weztermでwslにdotfileのsetupを行う場合、windows側のweztermのプロパティに`--config-file`を設定する必要あり

## 使用環境
- wezterm(bash)
- neovim

## neovim tips

### clangd
- 以下のようにして、clangdに対してコンパイル使った情報を伝える
```shell
 cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -S . -B build
 mv build/compile_commands.json .
 
```

