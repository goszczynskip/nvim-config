return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        -- eslint = {
        --   -- settings = {
        --   --   useFlatConfig = true, -- set if using flat config
        --   --   experimental = {
        --   --     useFlatConfig = nil, -- option not in the latest eslint-lsp
        --   --   },
        --   -- },
        -- },
        --
        -- tailwindcss = {
        --   -- root_dir = function(fname)
        --   --   -- log to messages for debugging
        --   --   vim.notify(fname)
        --   --   vim.notify(vim.fs.find(".git", { path = fname, upward = true }))
        --   --   vim.notify(vim.fs.find(".git", { path = fname, upward = true })[1])
        --   --   vim.notify(vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1]))
        --   --
        --   --   return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
        --   -- end,
        -- },
        oxlint = {
        },

        postgres_lsp = {
          cmd = { "postgrestools", "lsp-proxy" },
          filetypes = { "sql", "psql" },
          single_file_support = true,
          -- root_dir = function(fname)
          --   return vim.fs.dirname(vim.fs.find("postgrestools.jsonc", { path = fname, upward = true })[1])
          -- end,
        },
        sourcekit = {
          -- sourcekit-lsp is included with Xcode
          cmd = { "xcrun", "sourcekit-lsp" },
          filetypes = { "swift", "objc", "objcpp" },
          root_markers = { "Package.swift", "compile_commands.json", ".git" },
        }
      },

      setup = {
        -- eslint = function()
        --   Snacks.util.lsp.on(function(client)
        --     if client.name == "eslint" then
        --       client.server_capabilities.documentFormattingProvider = true
        --     elseif client.name == "tsserver" or client.name == "vtsls" then
        --       client.server_capabilities.documentFormattingProvider = false
        --     end
        --   end)
        --
        --   -- local function get_client(buf)
        --   --   return LazyVim.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
        --   -- end
        --   --
        --   -- local formatter = LazyVim.lsp.formatter({
        --   --   name = "eslint: lsp",
        --   --   primary = false,
        --   --   priority = 200,
        --   --   filter = "eslint",
        --   -- })
        --   --
        --   -- -- Use EslintFixAll on Neovim < 0.10.0
        --   -- if not pcall(require, "vim.lsp._dynamic") then
        --   --   formatter.name = "eslint: EslintFixAll"
        --   --   formatter.sources = function(buf)
        --   --     local client = get_client(buf)
        --   --     return client and { "eslint" } or {}
        --   --   end
        --   --   formatter.format = function(buf)
        --   --     local client = get_client(buf)
        --   --     if client then
        --   --       local diag = vim.diagnostic.get(buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
        --   --       if #diag > 0 then
        --   --         vim.cmd("EslintFixAll")
        --   --       end
        --   --     end
        --   --   end
        --   -- end
        --   --
        --   -- -- register the formatter with LazyVim
        --   -- LazyVim.format.register(formatter)
        -- end,

        tailwindcss = function(_, opts)
          opts.settings = {
            tailwindCSS = {
              classFunctions = { "cva", "cx" },
            },
          }
        end,
      },
    },
  },
}
