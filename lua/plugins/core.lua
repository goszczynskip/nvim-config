local sql_ft = { "sql", "mysql", "plsql" }

return {
  {
    "vuki656/package-info.nvim",
    requires = "MunifTanjim/nui.nvim",
    ft = "json",
    config = function()
      require("package-info").setup({
        hide_up_to_date = false,
        colors = {
          up_to_date = "#3C6048", -- Text color for up to date dependency virtual text
          outdated = "#d19a66", -- Text color for outdated dependency virtual text
        },
      })
    end,
  },
  {
    "tikhomirov/vim-glsl",
  },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          projects = {
            dev = { "~/workspace" },
          },
        },
      },
    },
  },
}
