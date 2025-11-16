return {
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            local jdtls = require("jdtls")
            local jdtls_setup = require("jdtls.setup")

            -- Find project root - fallback to current file's directory if no project markers found
            local root_dir = jdtls_setup.find_root({
                ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.xml", ".project"
            })

            -- If no project root found, use the directory containing the current Java file
            if not root_dir then
                root_dir = vim.fn.expand('%:p:h')
            end

            -- Path to JDTLS installed via Mason (using mason-tools location)
            local jdtls_cmd = vim.fn.stdpath("data") .. "/mason-tools/bin/jdtls"
            -- Add .cmd extension on Windows
            if vim.fn.has("win32") == 1 then
                jdtls_cmd = jdtls_cmd .. ".cmd"
            end

            -- Workspace folder (centralized, so no clutter in project directories)
            local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
            -- Create a safe filename by replacing problematic characters
            local safe_project_name = project_name:gsub("[^%w%-_]", "_")
            -- Add a hash to avoid collisions between projects with same name in different locations
            local root_hash = vim.fn.sha256(root_dir):sub(1, 8)
            local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. safe_project_name .. "_" .. root_hash

            -- Java 21 configuration
            local java_home = os.getenv("JAVA_HOME")

            local config = {
                cmd = { jdtls_cmd, "-data", workspace_dir },
                root_dir = root_dir,
                settings = {
                    java = {
                        eclipse = { downloadSources = true },
                        configuration = {
                            updateBuildConfiguration = "automatic",
                            -- Java 21 runtime configuration
                            runtimes = java_home and {
                                { name = "JavaSE-21", path = java_home, default = true },
                            } or nil,
                        },
                        maven = { downloadSources = true },
                        implementationsCodeLens = { enabled = false },
                        referencesCodeLens = { enabled = false },
                        references = { includeDecompiledSources = true },
                        format = {
                            enabled = false, -- DISABLED: Let conform.nvim handle formatting
                        },
                        signatureHelp = { enabled = true },
                        completion = {
                            favoriteStaticMembers = {
                                "org.hamcrest.MatcherAssert.assertThat",
                                "org.hamcrest.Matchers.*",
                                "org.hamcrest.CoreMatchers.*",
                                "org.junit.jupiter.api.Assertions.*",
                                "java.util.Objects.requireNonNull",
                                "java.util.Objects.requireNonNullElse",
                            },
                            filteredTypes = {
                                "com.sun.*",
                                "sun.*",
                                "jdk.*",
                                "org.graalvm.*",
                                "io.micrometer.shaded.*",
                            },
                        },
                        sources = {
                            organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
                        },
                    },
                },
                init_options = {
                    bundles = {},
                },
                flags = {
                    debounce_text_changes = 150,
                    allow_incremental_sync = true,
                },
                -- Key mappings specific to Java
                on_attach = function(client, bufnr)
                    -- Disable LSP formatting to prevent conflicts with conform.nvim
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false

                    -- Mappings
                    local bufopts = { noremap=true, silent=true, buffer=bufnr }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

                    -- Java specific mappings
                    vim.keymap.set('n', '<leader>jo', jdtls.organize_imports, bufopts)
                    vim.keymap.set('n', '<leader>jv', jdtls.extract_variable, bufopts)
                    vim.keymap.set('n', '<leader>jc', jdtls.extract_constant, bufopts)
                    vim.keymap.set('v', '<leader>jm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], bufopts)
                    
                    -- Quick LSP restart keymap (for when completions break)
                    vim.keymap.set('n', '<leader>lr', '<cmd>LspRestart<cr>', { buffer=bufnr, desc = "Restart LSP" })
                end,
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            }

            -- Start or attach to JDTLS
            jdtls.start_or_attach(config)
        end,
    },
}
