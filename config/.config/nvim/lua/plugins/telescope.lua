return {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
        -- 1. Merge the base options
        opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
            layout_strategy = "horizontal",
            layout_config = { preview_width = 0.6 },
        })

        -- 2. Force the find_files picker to be AGGRESSIVE 🥋
        opts.pickers = opts.pickers or {}
        opts.pickers.find_files = {
            hidden = true,
            no_ignore = true,
            -- This ensures it searches from your CURRENT directory, not the "Project Root"
            cwd = vim.loop.cwd(),
        }

        -- 3. Keep your magic colorscheme preview 🎯
        opts.pickers.colorscheme = {
            enable_preview = true,
        }
    end,
}
