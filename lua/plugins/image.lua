return {
  "3rd/image.nvim",
  event = "VeryLazy",
  opts = {
    integrations = {
      markdown = {
        clear_in_insert_mode = true,
        only_render_image_at_cursor = true,
      },
      typst = {
        only_render_image_at_cursor = true,
      },
    },
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign", "" },
  },
}
