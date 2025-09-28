-- this is my special key 
vim.g.mapleader = " "

-- Movements
vim.api.nvim_set_keymap('n', '<C-j>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', ':m .-2<CR>==', { noremap = true, silent = true })

-- This is for my nvim tree
vim.keymap.set("n", "<leader>pv", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })


-- remap for telesceope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })



-- Java build and run keymaps (handles multiple packages) 
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local jdtls = require('jdtls')
    local opts = { buffer = true, silent = true }
    
    -- Build entire project (compiles ALL java files recursively)
    vim.keymap.set('n', '<F6>', function()
      -- Windows command to find and compile all .java files recursively
      vim.cmd('!for /r . %%i in (*.java) do @javac -cp . -d ../bin "%%i"')
    end, opts)
    
    -- Alternative build using PowerShell (more reliable)
    vim.keymap.set('n', '<F7>', function()
      vim.cmd('!powershell "Get-ChildItem -Recurse -Filter *.java | ForEach-Object { javac -cp . -d ../bin $_.FullName }"')
    end, opts)
    
    -- Run current Java file
    vim.keymap.set('n', '<F5>', function()
      vim.cmd('w') -- Save first
      local filename = vim.fn.expand('%:t:r')
      vim.cmd('terminal cd .. && java -cp bin ' .. filename)
    end, opts)
    
  end,
})
