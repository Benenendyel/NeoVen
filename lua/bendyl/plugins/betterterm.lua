-- lua/plugins/betterterm.lua
return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        local toggleterm = require("toggleterm")
        toggleterm.setup({
            size = 15,
            shell = "powershell.exe",
            open_mapping = [[<c-\>]],
            shade_terminals = true,
            direction = "float",
            float_opts = {
                border = "curved",
            },
        })
        local Terminal = require("toggleterm.terminal").Terminal
        -- SET YOUR JAVAFX PATH HERE (relative to src folder)
        local javafx_path = "..\\javafx-sdk-21.0.2\\lib"
        -- F5: Just open a floating terminal
        vim.keymap.set("n", "<F5>", function()
            Terminal:new({
                shell = "powershell.exe",
                direction = "float",
            }):toggle()
        end, { noremap = true, silent = true })
        -- F6: Compile and run Main in normal Java project
        vim.keymap.set("n", "<F6>", function()
            vim.cmd("w") -- save file
            require("toggleterm.terminal").Terminal
                :new({
                    cmd = 'powershell.exe -NoExit -Command "java -cp ../bin Main"',
                    hidden = true,
                    direction = "float",
                })
                :toggle()
        end, { noremap = true, silent = true })
        -- F7: Compile all .java with PowerShell
        vim.keymap.set("n", "<F7>", function()
            Terminal
                :new({
                    cmd = [[powershell -Command "Get-ChildItem -Recurse -Filter *.java | ForEach-Object { javac -d ../bin $_.FullName }"]],
                    hidden = true,
                    direction = "float",
                })
                :toggle()
        end, { noremap = true, silent = true })
        -- F8: Maven compile (compiles Java files and copies resources)
        vim.keymap.set("n", "<F8>", function()
            vim.cmd("w") -- save file
            Terminal
                :new({
                    cmd = [[powershell.exe -NoExit -Command "cd .. ; mvn clean compile"]],
                    hidden = true,
                    direction = "float",
                })
                :toggle()
        end, { noremap = true, silent = true })
        -- F9: Maven run JavaFX application
        vim.keymap.set("n", "<F9>", function()
            Terminal
                :new({
                    cmd = [[powershell.exe -NoExit -Command "cd .. ; mvn javafx:run"]],
                    hidden = true,
                    direction = "float",
                })
                :toggle()
        end, { noremap = true, silent = true })
    end,
}
