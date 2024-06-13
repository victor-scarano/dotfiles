return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls = {
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.diagnostics.ltrs
			}
		}

		-- set any commands/keybindings here
	end
}
