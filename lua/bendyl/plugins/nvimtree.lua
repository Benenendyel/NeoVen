return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      trash = {
        cmd = "trash",   -- still configurable if you ever install trash-cli
        require_confirm = true,
      },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local opts = { noremap = true, silent = true, buffer = bufnr }

        -- Apply default keymaps
        api.config.mappings.default_on_attach(bufnr)

        -- Your custom keymaps
        vim.keymap.set("n", "D", api.fs.remove, opts) -- delete file/folder
        vim.keymap.set("n", "A", api.fs.create, opts) -- add file/folder
        vim.keymap.set("n", "R", api.fs.rename, opts) -- rename
      end,
    })
  end,
}

