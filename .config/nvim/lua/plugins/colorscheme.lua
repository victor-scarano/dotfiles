return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		opts = {},
		config = function()
			require("gruvbox").setup({
				-- transparent_mode = true
			})
			-- vim.cmd.colorscheme("gruvbox")
		end
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		opts = {},
		config = function()
			require("tokyonight").setup({
				-- transparent = true,
				styles = {
					-- sidebars = "trapsparent",
					-- floats = "transparent"
				},
				hide_inactive_statusline = true,
			})
			vim.cmd.colorscheme("tokyonight-night")
		end
	}
}
