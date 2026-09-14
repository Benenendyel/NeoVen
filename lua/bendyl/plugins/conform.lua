return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				java = { "google-java-format" },
				python = { "ruff_format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				lua = { "stylua" },
				xml = { "xmlformatter" },
				conform = { "sql_formatter" },
				bash = { "beautysh" },
				sh = { "beautysh" },
				markdown = { "prettier" },
				dart = { "dart_format" },
			},
			formatters = {
				["google-java-format"] = {
					prepend_args = { "--aosp" }, -- AOSP style: 4 spaces
				},
			},
			format_on_save = {
				timeout_ms = 3000,
				lsp_fallback = true,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range" })
	end,
}
