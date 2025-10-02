-- for the background transparency
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })

-- this is for the typography
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- this is for the general
vim.opt.relativenumber = true
vim.opt.colorcolumn = "100"
vim.opt.scrolloff = 999
