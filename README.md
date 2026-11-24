# Neovim config

This [LazyVim](https://www.lazyvim.org/) configuration can send file references and editor context to an OpenCode TUI running in a separate terminal.

## First run

Install Neovim 0.12 or newer, Git, and Node.js 18 or newer with npm. With an empty Neovim config directory, run:

```sh
config="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
git clone https://github.com/goszczynskip/nvim-config.git "$config"
npm --prefix "$config/local/opencode-tui.nvim" ci --omit=dev
```

Run `nvim` from your project directory and let lazy.nvim finish installing plugins.

## Send context to OpenCode

Open a project file in Neovim. From a second terminal in the same project or Git worktree, run `opencode`. The TUI must support Claude-style IDE discovery: Neovim starts a local WebSocket bridge and advertises it under `~/.claude/ide/`; the TUI connects to the bridge. Use `:OpenCodeStatus` to check for `bridge=ready` and a connected client.

- Press `<Space>of` to add a reference to the whole file, or `<Space>ol` for the current line. In Visual mode, `<Space>ol` references the selected lines. References are queued if the TUI is not connected yet.
- The bridge also shares the text of the current line or selected lines by default. Press `<Space>ot` to turn that automatic context off or back on.
- To switch projects without restarting Neovim, use `:OpenCodeTarget /path/to/project`. In a Git repository, the bridge advertises an endpoint for each worktree.

## Local settings

The projects picker scans `~/workspace` by default. To use other directories, create `projects.local.lua` in the Neovim config directory. Git ignores this file.

```lua
return { "~/code", "~/work" }
```
