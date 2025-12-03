return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				-- 背景透明化の設定 (tokyonightの transparent = true に相当)
				transparent_background = true,

				styles = {
					-- コメントのスタイル設定
					-- 空のテーブル {} を渡すとスタイルなし（イタリック無効）になります
					-- (デフォルトは { "italic" } です)
					comments = {},

					-- 必要であれば他の要素もここで設定できます
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
			})

			-- 設定を適用するためにカラースキームをロードします
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
