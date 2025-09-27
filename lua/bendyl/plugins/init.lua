local plugin_dir = vim.fn.stdpath("config") .. "/lua/bendyl/plugins/"
local plugin_files = vim.fn.glob(plugin_dir .. "*.lua", false, true)

local plugins = {}

for _, file in ipairs(plugin_files) do
    local filename = vim.fn.fnamemodify(file, ":t")
    if filename ~= "init.lua" then  -- ignore the loader itself
        local module = "bendyl.plugins." .. vim.fn.fnamemodify(file, ":t:r")
        local ok, plugin = pcall(require, module)

        if ok then
            if type(plugin) == "table" then
                if type(plugin[1]) == "string" then
                    table.insert(plugins, plugin)
                elseif vim.islist(plugin) then
                    vim.list_extend(plugins, plugin)
                end
            end
        else
            vim.notify("Failed to load plugin module: " .. module .. "\n" .. plugin, vim.log.levels.WARN)
        end
    end
end

require("lazy").setup(plugins)

