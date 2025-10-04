-- this is my special key
vim.g.mapleader = " "

-- Movements
vim.api.nvim_set_keymap("n", "<C-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":m .-2<CR>==", { noremap = true, silent = true })

-- This is for my nvim tree
vim.keymap.set("n", "<leader>pv", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })

-- remap for telesceope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Map F1 to open :Tutor
vim.keymap.set("n", "<F1>", ":Tutor<CR>")

-- Java build and run keymaps (handles multiple packages)
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "java",
-- 	callback = function()
-- 		local jdtls = require("jdtls")
-- 		local opts = { buffer = true, silent = true }
--
-- 		-- F6: Build entire project (Windows cmd)
-- 		vim.keymap.set("n", "<F6>", function()
-- 			vim.cmd('!for /r . %%i in (*.java) do @javac -d ../bin "%%i"')
-- 		end, opts)
--
-- 		-- F7: Build entire project (PowerShell, more reliable)
-- 		vim.keymap.set("n", "<F7>", function()
-- 			vim.cmd([[
--         !powershell -Command "Get-ChildItem -Recurse -Filter *.java | ForEach-Object { javac -d ../bin $_.FullName }"
--       ]])
-- 		end, opts)
--
-- 		-- F5: Compile and run only the Main class
-- 		vim.keymap.set("n", "<F5>", function()
-- 			vim.cmd("w") -- Save current file
--
-- 			-- Determine project root and paths
-- 			local project_root = vim.fn.getcwd()
-- 			local bin_path = project_root .. "/bin"
--
-- 			-- Run Main class from bin
-- 			vim.cmd('terminal java -cp "' .. bin_path .. '" Main')
-- 		end, opts)
-- 	end,
-- })
