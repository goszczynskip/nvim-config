return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        postgres_lsp = {},
        sourcekit = {
          cmd = { "xcrun", "sourcekit-lsp" }, -- Xcode toolchain instead of swiftly
          filetypes = { "swift", "objc", "objcpp" }, -- leave C/C++ to clangd
        },
        tailwindcss = {
          settings = {
            tailwindCSS = {
              classFunctions = { "cva", "cx" },
            },
          },
        },
      },
    },
  },
}
