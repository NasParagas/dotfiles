# ツールの入れ方

`install.sh` が入れないツールの手順。全環境で使うものは `profiles/` と `modules/` で管理する。

## setup スクリプト

コマンド名で実行できる。すでに入っている場合は何もしない。

| コマンド | 入るもの |
| --- | --- |
| `setup-rust` | Rust（rustup） |
| `setup-lean` | Lean（elan） |
| `setup-hdl-tools` | yosys, graphviz, sv2v, verilator, netlistsvg, surfer |

`setup-hdl-tools` の Linux 版は、sv2v と surfer を x86_64 でのみ導入する。GUI のないサーバーでは `--no-viewer` を付ける。

## mise で入れる言語

プロジェクトの `mise.toml` に書く。

```toml
[tools]
go = "1"
java = "temurin-21"
ruby = "3"
```

`mise install` で入る。全プロジェクトの既定にする場合は、マシンごとに `mise use -g go@1` のように実行する。

yarn はプロジェクトの `package.json` の `packageManager` に書き、`corepack enable` で使う。

## 開発用ツール

Ubuntu のパッケージ名は 24.04 と 26.04 で確認した。

### 組み込み

| ツール | macOS | Ubuntu |
| --- | --- | --- |
| picotool | `brew install picotool` | `sudo apt install picotool` |
| avrdude | `brew install avrdude` | `sudo apt install avrdude` |
| AVR 用 GCC | `brew tap osx-cross/avr` の後 `brew install avr-gcc@8` | `sudo apt install gcc-avr avr-libc` |
| Arm 用 GCC | `brew install --cask gcc-arm-embedded` | `sudo apt install gcc-arm-none-eabi` |
| QEMU | `brew install qemu` | `sudo apt install qemu-system` |
| verylup | `cargo install verylup` | `cargo install verylup` |

RISC-V ツールチェーンは [riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain) を `/opt/riscv` に入れると、シェルが自動で PATH に追加する。

### CLI

| ツール | macOS | Ubuntu |
| --- | --- | --- |
| gh | `brew install gh` | `sudo apt install gh` |
| bat | `brew install bat` | `sudo apt install bat`（コマンド名は `batcat`） |
| eza | `brew install eza` | `sudo apt install eza` |
| zoxide | `brew install zoxide` | `sudo apt install zoxide` |
| yazi | `brew install yazi` | `cargo install --locked yazi-build` |
| tree | `brew install tree` | `sudo apt install tree` |
| ImageMagick | `brew install imagemagick` | `sudo apt install imagemagick` |
| FFmpeg | `brew install ffmpeg` | `sudo apt install ffmpeg` |
| luarocks | `brew install luarocks` | `sudo apt install luarocks` |
| shellcheck | `brew install shellcheck` | `sudo apt install shellcheck` |
| Deno | `brew install deno` | mise の `deno` |

### カレンダー・タスク

| ツール | macOS | Ubuntu |
| --- | --- | --- |
| khal | `brew install khal` | `sudo apt install khal` |
| todoman | `brew install todoman` | `sudo apt install todoman` |
| vdirsyncer | `brew install vdirsyncer` | `sudo apt install vdirsyncer` |

### アプリ・SDK

| ツール | macOS | Ubuntu |
| --- | --- | --- |
| .NET SDK | `brew install --cask dotnet-sdk` | `sudo apt install dotnet-sdk-8.0` |
| XQuartz | `brew install --cask xquartz` | 不要 |
| Mos | `brew install --cask mos` | 不要 |
| AIRI | `brew install --cask airi` | 公式サイトを参照 |
| Copilot CLI | `brew install --cask copilot-cli` | 公式サイトを参照 |
| Gemini CLI | `brew install gemini-cli` | `npm install -g @google/gemini-cli` |

## cargo で入れたツール

`setup-rust` の後に実行する。

```sh
cargo install rustlings tauri-cli create-tauri-app weathr
```
