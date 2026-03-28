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

        local function find_project_root()
            local check = vim.fn.expand("%:p:h")  -- start from the CURRENT FILE's directory
            for _ = 1, 10 do
                if vim.fn.filereadable(check .. "\\pom.xml") == 1 then
                    return check
                end
                local parent = vim.fn.fnamemodify(check, ":h")
                if parent == check then break end
                check = parent
            end
            vim.notify("Warning: pom.xml not found!", vim.log.levels.WARN)
            return vim.fn.expand("%:p:h")
        end

        local function maven(cmd)
            local root = find_project_root()
            return Terminal:new({
                cmd = string.format([[powershell.exe -NoExit -Command "cd '%s' ; %s"]], root, cmd),
                hidden = true,
                direction = "float",
            })
        end

        -- F5: Open a blank floating terminal
        vim.keymap.set("n", "<F5>", function()
            Terminal:new({ shell = "powershell.exe", direction = "float" }):toggle()
        end, { noremap = true, silent = true, desc = "Open terminal" })

        -- F6: Compile only
        vim.keymap.set("n", "<F6>", function()
            vim.cmd("w")
            maven("mvn clean compile"):toggle()
        end, { noremap = true, silent = true, desc = "Maven compile" })

        -- F7: Package into JAR
        vim.keymap.set("n", "<F7>", function()
            vim.cmd("w")
            maven("mvn clean package"):toggle()
        end, { noremap = true, silent = true, desc = "Maven package" })

        -- F8: Compile and run (normal Java)
        vim.keymap.set("n", "<F8>", function()
            vim.cmd("w")
            maven("mvn clean compile exec:java"):toggle()
        end, { noremap = true, silent = true, desc = "Maven run" })

        -- F9: Compile and run (JavaFX)
        vim.keymap.set("n", "<F9>", function()
            vim.cmd("w")
            maven("mvn clean compile javafx:run"):toggle()
        end, { noremap = true, silent = true, desc = "Maven JavaFX run" })
    end,
}
