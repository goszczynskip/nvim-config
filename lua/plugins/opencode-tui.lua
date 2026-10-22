local plugin_dir = vim.fn.stdpath("config") .. "/local/opencode-tui.nvim"

return {
  {
    name = "opencode-tui.nvim",
    dir = plugin_dir,
    event = "VeryLazy",
    build = "npm ci --omit=dev",
    main = "opencode_tui",
    opts = {
      plugin_dir = plugin_dir,
    },
    cmd = {
      "OpenCodeAddFile",
      "OpenCodeAddLine",
      "OpenCodeContextToggle",
      "OpenCodeStatus",
      "OpenCodeTarget",
    },
    keys = {
      {
        "<leader>of",
        function()
          require("opencode_tui").file()
        end,
        desc = "OpenCode: add file",
      },
      {
        "<leader>ol",
        function()
          require("opencode_tui").line()
        end,
        desc = "OpenCode: add line",
      },
      {
        "<leader>ol",
        function()
          require("opencode_tui").selection()
        end,
        mode = "x",
        desc = "OpenCode: add selection",
      },
      {
        "<leader>ot",
        function()
          require("opencode_tui").toggle_context()
        end,
        desc = "OpenCode: toggle location broadcast",
      },
    },
  },
}
