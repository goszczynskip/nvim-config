local pr_cache = {}

local function show_pr_files(cwd, pr)
  local Snacks = require("snacks")
  Snacks.picker.gh_diff({
    pr = pr,
    cwd = cwd,
    group = true,
    show_delay = 0,
    title = ("PR #%d Files"):format(pr),
    actions = {
      open_all = function(picker)
        local items = vim.tbl_filter(function(item)
          return not (item.block and item.block.delete)
        end, picker:items())

        if #items == 0 then
          Snacks.notify.warn("The PR has no files that exist locally", { title = "PR Files" })
          return
        end

        picker.list:set_selected(items)
        Snacks.picker.actions.confirm(picker, nil, {})
      end,
    },
    win = {
      input = {
        keys = {
          ["<C-o>"] = { "open_all", mode = { "n", "i" }, desc = "Open all PR files" },
        },
      },
      list = {
        keys = {
          ["<C-o>"] = { "open_all", desc = "Open all PR files" },
        },
      },
    },
  })
end

local function pr_files(refresh)
  local cwd = vim.fn.getcwd()
  local git = vim
    .system({
      "git",
      "-C",
      cwd,
      "rev-parse",
      "--show-toplevel",
      "--abbrev-ref",
      "HEAD",
    }, { text = true })
    :wait()

  if git.code ~= 0 then
    vim.notify("Not inside a Git repository", vim.log.levels.ERROR, { title = "PR Files" })
    return
  end

  local context = vim.split(vim.trim(git.stdout or ""), "\n", { plain = true })
  local root, branch = context[1], context[2]
  if not root or not branch then
    vim.notify("Could not determine the Git branch", vim.log.levels.ERROR, { title = "PR Files" })
    return
  end

  local cache_key = root .. "\0" .. branch
  if not refresh and pr_cache[cache_key] then
    show_pr_files(root, pr_cache[cache_key])
    return
  end

  vim.system({
    "gh",
    "pr",
    "view",
    "--json",
    "number",
    "--jq",
    ".number",
  }, { cwd = root, text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local message = vim.trim(result.stderr or "")
        if message == "" then
          message = "No PR found for the current branch"
        end
        vim.notify(message, vim.log.levels.ERROR, { title = "PR Files" })
        return
      end

      local pr = tonumber(vim.trim(result.stdout or ""))
      if not pr then
        vim.notify("Could not determine the PR number", vim.log.levels.ERROR, { title = "PR Files" })
        return
      end

      pr_cache[cache_key] = pr
      show_pr_files(root, pr)
    end)
  end)
end

return {
  {
    "folke/snacks.nvim",
    init = function()
      vim.api.nvim_create_user_command("PrFiles", function(opts)
        pr_files(opts.bang)
      end, {
        bang = true,
        desc = "Preview files changed in the current branch's PR",
      })
    end,
    keys = {
      {
        "<leader>gF",
        function()
          pr_files()
        end,
        desc = "PR files",
      },
    },
  },
}
