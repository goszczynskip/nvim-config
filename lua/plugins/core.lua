local sql_ft = { "sql", "mysql", "plsql" }

-- Directories scanned by the projects picker. Put a list in the untracked
-- projects.local.lua file in the config directory, e.g. `return { "~/code" }`.
local function project_dirs()
  local path = vim.fn.stdpath("config") .. "/projects.local.lua"
  if vim.uv.fs_stat(path) then
    local ok, dirs = pcall(dofile, path)
    if ok and type(dirs) == "table" then
      return dirs
    end
    vim.notify("Ignoring invalid " .. path, vim.log.levels.WARN)
  end
  return { "~/workspace" }
end

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
            dev = project_dirs(),
          },
        },
      },
    },
  },
}
