return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")

    npairs.setup({
      check_ts = true, -- Use Treesitter for better pairing decisions
      ts_config = {
        lua = { "string" }, -- Don't add pairs in lua strings
        java = false,       -- Disable TS checking for Java (manual pairing only)
      },
      enable_check_bracket_line = false,
      fast_wrap = {},
      map_cr = true,
      map_bs = true,
    })

    -- Add custom < > pairing for HTML, XML, JSX, TSX
    npairs.add_rules({
      Rule("<", ">")
        :with_pair(function()
          local ft = vim.bo.filetype
          return ft == "html"
            or ft == "xml"
            or ft == "javascriptreact"
            or ft == "typescriptreact"
        end)
    })

    -- Integration with nvim-cmp (auto-inserts pairs after completion confirm)
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}

