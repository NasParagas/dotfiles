# Neovim設定

Neovim本体の設定、プラグインの設定、自作機能を分けて管理する。
現在のロック済みプラグイン構成は **Neovim 0.12以降**を対象とする
（nvim-treesitterの`main`ブランチの要件）。

## 構成

```text
init.lua                   起動順序・leaderなどの共通変数
lazy-lock.json             有効なプラグインのバージョン
lua/
  config/
    options.lua            全体のオプション・SSH時のクリップボード
    filetypes.lua          拡張子とファイルタイプの対応
    keymaps.lua            標準機能・自作コマンドの共通キー
    autocmds.lua           全体に適用するautocmd
    commands.lua           自作コマンドの登録
    lazy.lua               lazy.nvimの導入・カテゴリの読み込み
    lsp/
      servers.lua          言語サーバー設定・導入対象・OS分岐
      attach.lua           接続時のバッファローカルキー・ハイライト
      diagnostics.lua      診断表示
  plugins/
    coding/                LSP・補完・フォーマット・構文解析・言語支援
    editor/                編集操作・検索・ファイル操作・ターミナル
    ui/                    配色・ステータスライン・キーガイド
    git/                   Git関連
    writing/               Markdown・プレビュー・画像・TODOコメント
  custom/
    terminal.lua           ターミナルの状態管理・レイアウト・just実行
    progress_bar.lua       current/totalから進捗バーを生成
    metal_lint.lua         Metalコンパイラの実行と診断表示
after/ftplugin/             ファイルタイプごとのバッファ設定
disabled/                  無効なプラグイン設定の保管場所
```

## 読み込みの流れ

1. `init.lua`でleaderを設定する。
2. `config`のoptions、filetypes、keymaps、autocmds、commandsを読み込む。
3. `config.lazy`で`plugins.ui`、`coding`、`editor`、`git`、`writing`をimportする。
4. 各プラグインを、そのspecの`lazy`・`event`・`ft`・`cmd`・`keys`に従って読み込む。
5. ファイルタイプの決定時にNeovimが`after/ftplugin/<filetype>.lua`を読み込む。

カテゴリ内のLuaファイルは自動でimportされる。依存関係は各specの
`dependencies`に記載し、importの並び順には依存させない。
カテゴリのさらに下にディレクトリを追加する場合は、明示的なimportが必要。

### 読み込み条件の方針

| 用途 | 方針・例 |
| --- | --- |
| 起動直後に必要 | `lazy = false`。配色、Oil、Treesitter、LSP基盤 |
| 入力時に必要 | `event = "InsertEnter"`。autopairs、autotag |
| バッファで継続的に動作 | `BufReadPost` / `BufNewFile`。gitsigns、ufoなど |
| 保存時に必要 | `BufWritePre`。Conform |
| 特定のファイルタイプ | `ft`。Markdown描画など |
| 操作したときだけ必要 | `cmd` / `keys`。ToggleTerm、LazyGit、Diffview、画像貼り付け、プレビュー |

TelescopeはLSPのピッカーと`vim.ui.select`も担当するため、LSPの依存として
読み込む。Blinkも最初のLSPクライアントに補完capabilitiesを渡すため、
LSPの依存として読み込む。シグネチャ表示はBlinkに統一している。
Flashは標準の`f/F/t/T`との連携があるため、`VeryLazy`で初期化する。

## 設定を追加・変更するとき

- **プラグインを追加する**: `lua/plugins/<用途>/<名前>.lua`にLazyのspecを返すファイルを置く。
  短い設定は`opts`、追加処理が必要な場合は`config = function(_, opts)`を使う。
- **プラグイン用のキーを追加する**: 同じspecの`keys`に書く。
  LSPのキーなど接続先バッファに限定するものは、接続時に`buffer`付きで登録する。
- **独自機能が大きくなる**: 状態管理やまとまった処理を`custom/`に切り出す。
  `custom/`をrequireしただけでコマンドやキーを登録せず、呼び出し側が起動時期を決める。
- **ファイルタイプ固有の設定**: `after/ftplugin/`で`vim.opt_local`やバッファローカルキーを設定する。
- **autocmdを追加する**: 名前付きaugroupを使い、再設定時の重複を防ぐ。
- **プラグインを無効化する**: specを`disabled/`へ移す。再有効化は該当カテゴリへ戻す。
  依存元のspecからも参照がなくなっていることを確認する。
- **プラグインを更新する**: `:Lazy update`後、動作と`lazy-lock.json`の差分を確認する。
  ロック済みのバージョンへ合わせる操作は`:Lazy restore`。

### 言語支援の変更箇所

言語ごとの設定は、担当する仕組みのファイルに記載する。

| 変更内容 | ファイル |
| --- | --- |
| 拡張子・filetype | `lua/config/filetypes.lua` |
| LSPサーバー・起動オプション | `lua/config/lsp/servers.lua` |
| パーサーの導入・ハイライト対象 | `lua/plugins/coding/treesitter.lua`の`languages` |
| 外部フォーマッタの割り当て | `lua/plugins/coding/conform.lua`の`formatters_by_ft` |
| インデント・言語固有の操作 | `after/ftplugin/<filetype>.lua` |

Treesitterの`languages`は「パーサー名 → filetype一覧」の対応表。
空の一覧は、他の言語への埋め込みで使うパーサーを表す。
MetalとCUDAはC++パーサーを再利用する。

## 外部ツール

- **LSP / stylua**: `servers.ensure_installed()`からMason経由で導入する。
  Linuxの`clangd`はシステムのパッケージマネージャーで導入し、`PATH`から利用する。
- **Python**: `uv python find --directory <root>`でプロジェクトのPythonを選ぶ。
  利用できない場合は`python3`へフォールバックする。
- **Treesitter**: パーサーのビルドにはCコンパイラ、tree-sitter CLIなどが必要。
  正確な要件は`:checkhealth nvim-treesitter`で確認できる。
- **検索**: Telescopeのgrepには`rg`、fzf拡張のビルドには`make`が必要。
- **ターミナル**: `/bin/bash`を利用する。`<leader>r...`はプロジェクトの`justfile`にある
  `test`、`watch`、`check`、`dev`レシピを呼ぶ。
- **Metal**: `xcrun -sdk macosx metal`を利用する。`xcrun`がない環境では診断処理を開始しない。
- **Markdown内の数式**: render-markdownのLaTeX描画には`utftex`または`latex2text`を利用する。

## 主な操作

`<leader>`はSpace。

| キー / コマンド | 操作 |
| --- | --- |
| `grn` / `gra` | リネーム / コードアクション |
| `grd` / `grD` / `grt` | 定義 / 宣言 / 型定義 |
| `grr` / `gri` | 参照 / 実装 |
| `gO` / `gW` | ファイル内 / ワークスペースのシンボル |
| `<leader>lh` | 現在のバッファのインレイヒント切り替え |
| `<leader>f` | フォーマット。外部フォーマッタがなければLSPへフォールバック |
| `:FormatDisable` / `:FormatDisable!` | 全体 / 現在のバッファの保存時フォーマットを無効化 |
| `:FormatEnable` | 全体と現在のバッファの無効化フラグを解除 |
| `<leader>sf` / `<leader>sg` | ファイル検索 / grep |
| `-` | 親ディレクトリをOilで開く |
| `<leader>tt` / `<leader>tn` | メインターミナル切り替え / 新規ターミナル |
| `<leader>tf` / `<leader>tv` / `<leader>th` | 全画面 / 縦分割 / 横分割ターミナル |
| `<leader>ts` / `<leader>td` | ターミナル選択 / 削除 |
| `<leader>rt` / `<leader>rw` / `<leader>rc` / `<leader>rd` | just test / watch / check / dev |
| `<leader>gg` / `<leader>gm` | LazyGit / カーソル行のコミット情報 |
| `<leader>ip` | 画像貼り付け |
| 選択して`<leader>pb` | 選択開始行の`current/total`を進捗バー付きにする |
| `:BuildProgressBar` | 現在行の進捗バーを生成・更新 |
| `:InsertDetails` | HTMLのdetails/summaryを挿入 |

## 確認

このディレクトリでLuaの整形を確認する:

```sh
stylua --check init.lua lua after
```

Neovim内では`:Lazy`、`:checkhealth lazy vim.lsp nvim-treesitter`、
`:Mason`、`:ConformInfo`で読み込みやツールの状態を確認できる。
表示・対話操作の確認は、Lua / Python / C++ / Markdownなど実際のファイルで行う。
