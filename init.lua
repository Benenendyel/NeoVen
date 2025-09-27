-- ============================== --
--          Greet Message         --
-- ============================== --
local function welcome_message()
  print([[
 __      __       .__                                  __            _______             ____   ____             
/  \    /  \ ____ |  |   ____  ____   _____   ____   _/  |_  ____    \      \   ____  ___\   \ /   /____   ____  
\   \/\/   // __ \|  | _/ ___\/  _ \ /     \_/ __ \  \   __\/  _ \   /   |   \_/ __ \/  _ \   Y   // __ \ /    \ 
 \        /\  ___/|  |_\  \__(  <_> )  Y Y  \  ___/   |  | (  <_> ) /    |    \  ___(  <_> )     /\  ___/|   |  \
  \__/\  /  \___  >____/\___  >____/|__|_|  /\___  >  |__|  \____/  \____|__  /\___  >____/ \___/  \___  >___|  /
       \/       \/          \/            \/     \/                         \/     \/                  \/     \/ 
  ]])
end

-- Run on Neovim start
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = welcome_message
})


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

