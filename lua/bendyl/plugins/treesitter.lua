return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Combine parser lists from both configs
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "java",
        "html",
        "css",
        "javascript",
        "query",
        "markdown",
        "markdown_inline",
        "json",
      },
      auto_install = true,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
      },
    })
  end,
}

