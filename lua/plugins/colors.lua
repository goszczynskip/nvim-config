return {
  {
    "eero-lehtinen/oklch-color-picker.nvim",
    version = "*",
    keys = {
      {
        "<leader>v",
        function()
          require("oklch-color-picker").pick_under_cursor()
        end,
        desc = "Color pick under cursor",
      },
    },
    ---@type oklch.Opts
    opts = {
      -- mini-hipatterns already highlights colors
      highlight = { enabled = false },
    },
  },
}
