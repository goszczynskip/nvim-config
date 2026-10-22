local M = {}

local state = {
  configured = false,
  directory = nil,
  workspaces = {},
  job = nil,
  generation = 0,
  ready = false,
  clients = 0,
  context_enabled = true,
  context_timer = nil,
  context_workspace = nil,
  queue = {},
  opts = nil,
}

local defaults = {
  debounce_ms = 150,
  context_enabled = true,
  max_pending_mentions = 100,
}

local function notify(message, level)
  vim.schedule(function()
    vim.notify(message, level, { title = "OpenCode" })
  end)
end

local function flush()
  if not state.ready or not state.job then
    return
  end
  for _, message in ipairs(state.queue) do
    vim.fn.chansend(state.job, vim.json.encode(message) .. "\n")
  end
  state.queue = {}
end

local function enqueue(message)
  if message.method == "selection_changed" then
    for index = #state.queue, 1, -1 do
      local pending = state.queue[index]
      if
        pending.method == message.method
        and pending.workspace == message.workspace
        and pending.broadcastAll == message.broadcastAll
      then
        table.remove(state.queue, index)
      end
    end
  else
    local mentions = 0
    for _, pending in ipairs(state.queue) do
      if pending.method == "at_mentioned" then
        mentions = mentions + 1
      end
    end
    if mentions >= state.opts.max_pending_mentions then
      for index, pending in ipairs(state.queue) do
        if pending.method == "at_mentioned" then
          table.remove(state.queue, index)
          break
        end
      end
    end
  end
  table.insert(state.queue, message)
end

local function workspace_directories(directory)
  local output = vim.fn.systemlist({ "git", "-C", directory, "worktree", "list", "--porcelain" })
  if vim.v.shell_error ~= 0 then
    return { directory }
  end

  local directories = {}
  for _, line in ipairs(output) do
    local worktree = line:match("^worktree (.+)$")
    if worktree then
      table.insert(directories, vim.fs.normalize(worktree))
    end
  end
  return #directories > 0 and directories or { directory }
end

local function handle_bridge_message(line)
  local ok, message = pcall(vim.json.decode, line)
  if not ok then
    notify("Invalid bridge output: " .. line, vim.log.levels.ERROR)
    return
  end

  if message.event == "ready" then
    state.ready = true
    flush()
  elseif message.event == "clients" then
    local was_connected = state.clients > 0
    state.clients = message.count or 0
    if not was_connected and state.clients > 0 then
      notify("Connected to OpenCode TUI", vim.log.levels.INFO)
      vim.schedule(M.broadcast)
    end
  elseif message.event == "queued" then
    notify("Reference queued until the OpenCode TUI connects", vim.log.levels.WARN)
  end
end

local function line_handler(callback)
  local pending = ""
  return function(_, data)
    if not data or #data == 0 then
      return
    end
    data[1] = pending .. data[1]
    pending = table.remove(data) or ""
    for _, line in ipairs(data) do
      if line ~= "" then
        callback(line)
      end
    end
  end
end

local function start_bridge()
  state.generation = state.generation + 1
  local generation = state.generation
  if state.job then
    vim.fn.jobstop(state.job)
  end
  state.job = nil
  state.ready = false
  state.clients = 0
  state.queue = {}

  local runner = state.opts.plugin_dir .. "/node_modules/tsx/dist/cli.mjs"
  local script = state.opts.plugin_dir .. "/bridge.ts"
  if vim.fn.executable("node") ~= 1 then
    notify("Node.js is required by opencode-tui.nvim", vim.log.levels.ERROR)
    return
  end
  if vim.fn.filereadable(runner) ~= 1 then
    notify("Run npm install in " .. state.opts.plugin_dir, vim.log.levels.ERROR)
    return
  end

  state.workspaces = workspace_directories(state.directory)
  local stderr = line_handler(function(line)
    notify(line, vim.log.levels.ERROR)
  end)
  local job = vim.fn.jobstart({ "node", runner, script, vim.json.encode(state.workspaces) }, {
    stdout_buffered = false,
    on_stdout = line_handler(handle_bridge_message),
    on_stderr = stderr,
    on_exit = function(job_id, code)
      if generation ~= state.generation or job_id ~= state.job then
        return
      end
      state.job = nil
      state.ready = false
      state.clients = 0
      if code ~= 0 then
        notify("Editor bridge exited with code " .. code, vim.log.levels.ERROR)
      end
    end,
  })

  if job <= 0 then
    notify("Failed to start the OpenCode editor bridge", vim.log.levels.ERROR)
    return
  end
  state.job = job
end

local function workspace_for_file(file)
  local match
  for _, workspace in ipairs(state.workspaces) do
    if file == workspace or vim.startswith(file, workspace .. "/") then
      if not match or #workspace > #match then
        match = workspace
      end
    end
  end
  return match
end

local function send(message, file)
  if not state.job then
    start_bridge()
  end
  if not state.job then
    return
  end
  if file then
    message.workspace = workspace_for_file(file)
    if not message.workspace then
      notify("File is outside the configured Git worktrees: " .. file, vim.log.levels.WARN)
      return
    end
  end
  enqueue(message)
  flush()
end

local function clear_context(workspace, broadcast_all)
  send({
    method = "selection_changed",
    workspace = workspace,
    broadcastAll = broadcast_all,
    params = {
      filePath = "",
      ranges = {
        {
          text = "",
          selection = {
            start = { line = 0, character = 0 },
            ["end"] = { line = 0, character = 0 },
          },
        },
      },
    },
  })
end

local function current_file(silent)
  if vim.bo.buftype ~= "" then
    return
  end
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    if not silent then
      notify("Current buffer has no file", vim.log.levels.WARN)
    end
    return
  end
  return vim.fs.normalize(file)
end

function M.file()
  local file = current_file()
  if not file then
    return
  end
  send({
    method = "at_mentioned",
    params = {
      filePath = file,
      lineStart = 1,
      lineEnd = vim.api.nvim_buf_line_count(0),
    },
  }, file)
end

function M.line()
  local file = current_file()
  if not file then
    return
  end
  local line = vim.api.nvim_win_get_cursor(0)[1]
  send({
    method = "at_mentioned",
    params = { filePath = file, lineStart = line, lineEnd = line },
  }, file)
end

function M.selection()
  local first = vim.fn.line("v")
  local last = vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  local file = current_file()
  if not file then
    return
  end
  send({
    method = "at_mentioned",
    params = { filePath = file, lineStart = first, lineEnd = last },
  }, file)
end

function M.broadcast()
  if not state.context_enabled then
    return
  end
  local file = current_file(true)
  if not file then
    return
  end
  local workspace = workspace_for_file(file)
  if not workspace then
    return
  end
  if state.context_workspace and state.context_workspace ~= workspace then
    clear_context(state.context_workspace)
  end
  state.context_workspace = workspace

  local first
  local last
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    first = vim.fn.line("v")
    last = vim.fn.line(".")
    if first > last then
      first, last = last, first
    end
  else
    first = vim.api.nvim_win_get_cursor(0)[1]
    last = first
  end

  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  send({
    method = "selection_changed",
    params = {
      filePath = file,
      ranges = {
        {
          text = table.concat(lines, "\n"),
          selection = {
            start = { line = first - 1, character = 0 },
            ["end"] = { line = last - 1, character = #(lines[#lines] or "") },
          },
        },
      },
    },
  }, file)
end

function M.toggle_context()
  state.context_enabled = not state.context_enabled
  if state.context_enabled then
    M.broadcast()
  else
    if state.context_timer then
      state.context_timer:stop()
    end
    clear_context(nil, true)
    state.context_workspace = nil
  end
  notify("Location broadcast " .. (state.context_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end

function M.target(directory)
  directory = directory ~= "" and directory or vim.fn.getcwd(0)
  directory = vim.fs.normalize(vim.fn.fnamemodify(directory, ":p"))
  if vim.fn.isdirectory(directory) ~= 1 then
    notify("Not a directory: " .. directory, vim.log.levels.ERROR)
    return
  end
  state.directory = directory
  start_bridge()
  notify("TUI target: " .. directory, vim.log.levels.INFO)
end

local function stop()
  state.generation = state.generation + 1
  if state.context_timer then
    state.context_timer:stop()
    state.context_timer:close()
    state.context_timer = nil
  end
  if state.job then
    vim.fn.jobstop(state.job)
    state.job = nil
  end
end

function M.setup(opts)
  if state.configured then
    return
  end
  state.configured = true
  state.opts = vim.tbl_deep_extend("force", defaults, opts or {})
  state.context_enabled = state.opts.context_enabled
  state.directory = vim.fs.normalize(vim.fn.getcwd(0))
  start_bridge()

  vim.api.nvim_create_user_command("OpenCodeAddFile", M.file, {
    desc = "Add the current file to the visible OpenCode TUI prompt",
  })
  vim.api.nvim_create_user_command("OpenCodeAddLine", M.line, {
    desc = "Add the current line to the visible OpenCode TUI prompt",
  })
  vim.api.nvim_create_user_command("OpenCodeTarget", function(command)
    M.target(command.args)
  end, {
    nargs = "?",
    complete = "dir",
    desc = "Set the workspace of the target OpenCode TUI",
  })
  vim.api.nvim_create_user_command("OpenCodeStatus", function()
    notify(
      ("target=%s, worktrees=%d, bridge=%s, clients=%d, broadcast=%s"):format(
        state.directory,
        #state.workspaces,
        state.ready and "ready" or "starting",
        state.clients,
        state.context_enabled and "on" or "off"
      ),
      vim.log.levels.INFO
    )
  end, { desc = "Show OpenCode TUI bridge status" })
  vim.api.nvim_create_user_command("OpenCodeContextToggle", M.toggle_context, {
    desc = "Toggle OpenCode location broadcasting",
  })

  local context_group = vim.api.nvim_create_augroup("opencode_tui_context", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "CursorMoved", "CursorMovedI" }, {
    group = context_group,
    callback = function()
      if not state.context_enabled then
        return
      end
      if state.context_timer then
        state.context_timer:stop()
      else
        state.context_timer = vim.uv.new_timer()
      end
      state.context_timer:start(state.opts.debounce_ms, 0, vim.schedule_wrap(M.broadcast))
    end,
    desc = "Broadcast the current location to OpenCode",
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = context_group,
    callback = stop,
    desc = "Stop the OpenCode editor bridge",
  })
end

return M
