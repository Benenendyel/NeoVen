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

            -- Path to JDTLS installed via Mason
            local jdtls_cmd = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
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
                            updateBuildConfiguration = "interactive",
                            -- Java 21 runtime configuration
                            runtimes = {
                                { name = "JavaSE-21", path = java_home, default = true },
                            },
                        },
                        maven = { downloadSources = true },
                        implementationsCodeLens = { enabled = true },
                        referencesCodeLens = { enabled = true },
                        references = { includeDecompiledSources = true },
                        format = {
                            enabled = true,
                            settings = {
                                url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
                                profile = "GoogleStyle",
                            },
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
                        },
                        sources = {
                            organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
                        },
                    },
                },
                init_options = {
                    bundles = {},
                    extendedClientCapabilities = { progressReportsSupported = true },
                },
                -- Key mappings specific to Java
                on_attach = function(client, bufnr)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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
                    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)

                    -- Java specific mappings
                    vim.keymap.set('n', '<leader>jo', jdtls.organize_imports, bufopts)
                    vim.keymap.set('n', '<leader>jv', jdtls.extract_variable, bufopts)
                    vim.keymap.set('n', '<leader>jc', jdtls.extract_constant, bufopts)
                    vim.keymap.set('v', '<leader>jm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], bufopts)
                end,
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            }

            -- Start or attach to JDTLS
            jdtls.start_or_attach(config)
        end,
    },
}

