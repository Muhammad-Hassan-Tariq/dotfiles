return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      -- This makes sure the preview window is big enough to see your code!
      layout_strategy = "horizontal",
      layout_config = { preview_width = 0.6 },
    },
    pickers = {
      colorscheme = {
        enable_preview = true, -- 🎯 This is the magic line for Hassan!
      },
    },
  },
}
