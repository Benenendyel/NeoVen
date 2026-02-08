return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    
    conform.setup({
      formatters_by_ft = {
        java = { "google-java-format" },
        python = { "ruff_format" },
      },
      formatters = {
        ["google-java-format"] = {
          prepend_args = { "--aosp" }, -- AOSP style: 4 spaces
        },
      },
      format_on_save = {
        timeout_ms = 500,
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
