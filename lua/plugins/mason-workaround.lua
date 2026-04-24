return {
  { "mason-org/mason.nvim" },
  { "mason-org/mason-lspconfig.nvim" },
  { -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
  },
}
