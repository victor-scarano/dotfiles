return {
	{
		-- displays completions from the lsp attached to the current buffer
		"hrsh7th/cmp-nvim-lsp",

		-- source for everything in the current buffer
		"hrsh7th/cmp-buffer",

		-- source for the vim command line
		"hrsh7th/cmp-cmdline",

		-- supplies cmp with path completions
		"hrsh7th/cmp-path",
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require"cmp"
			cmp.setup({
				snippet = {
					-- specify snippet engine
					expand = function(args)
						-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						-- require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
						-- require("snippy").expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
						-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered()
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					-- accept currently selected 
					-- default is <CR>
					["<Tab>"] = cmp.mapping.confirm({ select = true })
				}),
				sources = cmp.config.sources(
					{
						{ name = "nvim_lsp" },
						-- { name = "vsnip" }, -- For vsnip users.
						-- { name = "luasnip" }, -- For luasnip users.
						-- { name = "ultisnips" }, -- For ultisnips users.
						-- { name = "snippy" }, -- For snippy users.
					},
					{ { name = "buffer" } }
				)
			})
		end
	}
}
