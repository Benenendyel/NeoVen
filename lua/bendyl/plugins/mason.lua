return {
	-- Mason (LSP/DAP installer)
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason").setup({
				install_root_dir = vim.fn.stdpath("data") .. "/mason-tools",
				ui = {
					icons = {
						package_installed = "✅",
						package_pending = "⌛",
						package_uninstalled = "❌",
					},
				},
			})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"jdtls",
					"html",
					"cssls",
					"ts_ls",
					"emmet_ls",
					"eslint",
					"jedi_language_server",
				},
				automatic_installation = true,
				handlers = {
					function(server_name)
						local capabilities = require("cmp_nvim_lsp").default_capabilities()
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,
					["emmet_ls"] = function()
						require("lspconfig").emmet_ls.setup({
							capabilities = require("cmp_nvim_lsp").default_capabilities(),
							filetypes = { "html", "css", "javascript", "javascriptreact", "typescriptreact" },
						})
					end,
					["jdtls"] = function() end,
				},
			})
		end,
	},
	-- Autocompletion (nvim-cmp)
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
}
