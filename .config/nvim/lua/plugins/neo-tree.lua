return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim", -- Optional image support
	},
	config = function()
		require("neo-tree").setup({
			window = {
				width = 30
			}
		})
		vim.keymap.set("n", "<leader>t", "<cmd>Neotree toggle<CR>")
	end
}

