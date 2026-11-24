return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        oxlint = {
        },

        postgres_lsp = {
          cmd = { "postgrestools", "lsp-proxy" },
          filetypes = { "sql", "psql" },
          single_file_support = true,
        },
        sourcekit = {
          -- sourcekit-lsp is included with Xcode
          cmd = { "xcrun", "sourcekit-lsp" },
          filetypes = { "swift", "objc", "objcpp" },
          root_markers = { "Package.swift", "compile_commands.json", ".git" },
        }
      },

      setup = {
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
