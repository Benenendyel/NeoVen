--------------- For LazyVim Package Manager ----------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================== --
--      Loading of Configs        --
-- ============================== --
require("bendyl.plugins");
require("bendyl.general-settings");
require("bendyl.remap");

print("hello, world");
