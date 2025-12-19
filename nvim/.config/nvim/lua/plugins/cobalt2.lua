return {
  {
    "lalitmee/cobalt2.nvim",
    event = { "ColorSchemePre" }, -- ⚡ Official trigger for color plugins
    dependencies = {
      { "tjdevries/colorbuddy.nvim", tag = "v1.0.0" }, -- 🔗 Pinning the version for stability
    },
    init = function()
      -- The official way to call the colorscheme via the colorbuddy engine
      require("colorbuddy").colorscheme("cobalt2")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cobalt2",
    },
  },
}
