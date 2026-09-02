-- install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({

	-- nvim/lua/plugins/**

	----- 見た目 / UI -----
	-- colorscheme 全般
	{ import = "plugins.colorscheme" },
	-- colorscheme selector
	{ import = "plugins.themery" },
	-- status bar
	{ import = "plugins.lualine" },
	-- indent に ガイド表示
	{ import = "plugins.hlchunk" },
	-- 入力途中のキーバインド表示
	{ import = "plugins.which_key" },
	-- キーマップをランダムに表示
	-- { import = "plugins.random_key_tips" },

	----- LSP / コーディング支援 -----
	-- Language Server Protocol
	{ import = "plugins.lsp" },
	-- 入力中に関数シグネチャを表示
	{ import = "plugins.lsp_signature" },
	-- 補完エンジン
	{ import = "plugins.blink_cmp" },
	-- 自動フォーマッタ
	{ import = "plugins.conform" },
	-- パース & ハイライト
	{ import = "plugins.nvim_treesitter" },
	-- 関数・メソッド・文などの後ろに現在のコンテキストを仮想テキストで表示
	{ import = "plugins.nvim_context_vt" },
	-- 配列・ハッシュ・文・オブジェクト・辞書などのコードブロックを分割/結合
	{ import = "plugins.treesj" },

	----- エディタ拡張 -----
	-- `{}` などのペアを自動補完
	{ import = "plugins.autopairs" },
	-- インクリメント/デクリメントの拡張
	{ import = "plugins.dial" },
	-- 折りたたみ機能の強化
	{ import = "plugins.nvim_ufo" },
	-- ペインのリサイズ
	{ import = "plugins.winresizer" },

	----- ナビゲーション -----
	-- ファジーファインダー
	{ import = "plugins.telescope" },
	-- ファイルエクスプローラ(バッファのように編集できる)
	{ import = "plugins.oil" },
	-- f/F/t/T のジャンプ先をハイライト
	{ import = "plugins.quick_scope" },
	-- f/F の機能強化
	{ import = "plugins.flash" },

	----- Git -----
	-- git の状態を行単位で確認
	{ import = "plugins.gitsigns" },
	-- git TUI
	{ import = "plugins.lazygit" },
	-- git の差分表示
	{ import = "plugins.diffview" },
	-- カーソル下のコミットメッセージを表示
	{ import = "plugins.git_messanger" },

	----- 執筆 / 生産性 -----
	-- markdown をブラウザでプレビュー
	{ import = "plugins.live_preview" },
	-- markdown をバッファ内でレンダリング
	{ import = "plugins.render_markdown" },
	-- コメントのハイライト & 検索
	{ import = "plugins.todo_comments" },
	-- 画像の貼り付け
	{ import = "plugins.img_clip" },
	-- ペア記号から簡単に抜ける
	{ import = "plugins.in-and-out" },
	-- タグの自動ペア 例: <div></div>
	{ import = "plugins.nvim-ts-autotag" },

	----- ユーティリティ -----
	-- ユーティリティプラグイン集
	{ import = "plugins.mini" },
	-- ターミナル統合
	{ import = "plugins.toggleterm" },
	-- buffer の中身の表示場所を pane 中心にする
	-- { import = "plugins.no-neck-pain" },

	--- その他 ---
	{ import = "plugins.lean" },
	{ import = "plugins.veryl" },

	----- 無効 / 未使用 -----
	-- LaTeX 数式プレビュー
	-- { import = "plugins.nabla" },
	-- { import = "plugins.none_ls" },
	-- { import = "plugins.snacks" },
	-- { import = "plugins.image" },
	-- { import = "plugins.obsidian_bridge" },
	-- { import = "plugins.wrapped" },
	-- { import = "plugins.nvim_jdtls" },
	-- { import = "plugins.nvim_notify" },
	-- { import = "plugins.barbar" },
	-- { import = "plugins.markdown_preview" },
	-- { import = "plugins.markview" },
	-- { import = "plugins.nvim_tree" },
}, {
	ui = {
		-- Nerd Font を使っている場合: icons を空テーブルにすると lazy.nvim デフォルトの
		-- Nerd Font アイコンが使われる。そうでない場合は unicode アイコンのテーブルを定義する
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
