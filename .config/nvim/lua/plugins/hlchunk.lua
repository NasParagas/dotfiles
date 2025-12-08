return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = true,
				-- ...
			},
			indent = {
				enable = true,
				-- ...
			},
		})
	end,
}

-- local default_conf = {
--     enable = false,
--     style = {},
--     notify = false,
--     priority = 0,
--     exclude_filetypes = {
--         aerial = true,
--         dashboard = true,
--         -- some other filetypes
--     }
-- }
