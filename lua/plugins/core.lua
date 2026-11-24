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
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "BufRead package.json",
    opts = {
      highlights = {
        up_to_date = { fg = "#3C6048" },
      },
    },
  },
  { "akinsho/git-conflict.nvim", version = "*", event = "LazyFile", config = true },
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
