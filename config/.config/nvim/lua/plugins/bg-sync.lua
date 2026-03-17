return {
  "typicode/bg.nvim",
  lazy = false, -- Must be false so it catches the initial colorscheme load!
  config = function()
    -- No complex setup needed, it works out of the box!
    -- It sends OSC escape sequences to Kitty to sync the colors.
  end,
}
