-- Git worktree picker.
-- Lists worktrees of the current repository (including ones created by
-- opencode's experimental workspaces / warp feature) and switches the tab's
-- working directory to the selected worktree.
--
-- Keymap: <leader>gw

local function git_root()
  local out = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })
  if vim.v.shell_error ~= 0 or not out[1] or out[1] == "" then
    return nil
  end
  return out[1]
end

local function list_worktrees()
  local root = git_root()
  if not root then
    return {}
  end

  local out = vim.fn.systemlist({ "git", "-C", root, "worktree", "list", "--porcelain" })
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local items, current = {}, nil
  local function flush()
    if current and current.path then
      table.insert(items, current)
    end
    current = nil
  end

  for _, line in ipairs(out) do
    if line:sub(1, 9) == "worktree " then
      flush()
      current = { path = line:sub(10) }
    elseif current then
      if line:sub(1, 7) == "branch " then
        current.branch = (line:sub(8):gsub("^refs/heads/", ""))
      elseif line == "detached" then
        current.branch = "(detached)"
      elseif line == "" then
        flush()
      end
    end
  end
  flush()

  return items
end

local function pick_worktree()
  local items = list_worktrees()
  if #items == 0 then
    vim.notify("No git worktrees found", vim.log.levels.WARN)
    return
  end

  local cwd = vim.uv.cwd()
  vim.ui.select(items, {
    prompt = "Switch worktree",
    format_item = function(it)
      local marker = it.path == cwd and " *" or ""
      return string.format("%s  [%s]%s", it.path, it.branch or "?", marker)
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.cmd.tcd(vim.fn.fnameescape(choice.path))
    vim.notify("cwd → " .. choice.path, vim.log.levels.INFO)
  end)
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gw", pick_worktree, desc = "Git worktrees" },
    },
  },
}
