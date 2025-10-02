-- lua/plugins/statusline.lua
return {
  "nvim-lualine/lualine.nvim", -- we fake it using lualine as a base
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local colors = {
      bg       = "#191724", -- rose-pine base
      fg       = "#e0def4",
      green    = "#31748f",
      orange   = "#f6c177",
      purple   = "#c4a7e7",
      red      = "#eb6f92",
      yellow   = "#f6c177",
      gray     = "#6e6a86",
      darkgray = "#26233a",
    }

    require("lualine").setup {
      options = {
        theme = {
          normal = {
            a = { fg = colors.bg, bg = colors.green, gui = "bold" },
            b = { fg = colors.fg, bg = colors.darkgray },
            c = { fg = colors.fg, bg = colors.bg },
          },
          insert = { a = { fg = colors.bg, bg = colors.purple, gui = "bold" } },
          visual = { a = { fg = colors.bg, bg = colors.orange, gui = "bold" } },
          replace = { a = { fg = colors.bg, bg = colors.red, gui = "bold" } },
          inactive = {
            a = { fg = colors.gray, bg = colors.bg, gui = "bold" },
            b = { fg = colors.gray, bg = colors.bg },
            c = { fg = colors.gray, bg = colors.bg },
          },
        },
        section_separators = "",
        component_separators = "",
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }
  end,
}

