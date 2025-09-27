return {
  -- Mason (LSP/DAP installer)
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig", -- Needed to provide default configs for servers
    },
    config = function()
      require("mason").setup({
        install_root_dir = vim.fn.stdpath("data") .. "/mason-tools",
        ui = {
          icons = {
            package_installed = "✅",
            package_pending = "⌛",
            package_uninstalled = "❌",
          },
        },
      })

      -- Setup mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = { "jdtls" },
        automatic_installation = true,
        handlers = {
          -- Default handler for all installed servers
          function(server_name)
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local defaults = require("lspconfig.server_configurations")[server_name]

            -- Determine root_dir safely (fallback to cwd if nothing matches)
            local function get_root()
              return vim.fs.root(0, { "pom.xml", "gradlew", ".git" })
                or vim.fn.getcwd()
            end

            vim.lsp.start(vim.tbl_deep_extend("force", defaults, {
              capabilities = capabilities,
              root_dir = get_root(),
            }))
          end,
        },
      })
    end,
  },

  -- Autocompletion (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
