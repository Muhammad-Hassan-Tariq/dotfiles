return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        "mason-org/mason.nvim",
    },
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "arduino_language_server",
                "clangd",
            },
        })

        -- clangd setup with valid args
        require("lspconfig").clangd.setup({
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders=false",
                "--fallback-style=llvm",
            },
        })

        -- Optional: arduino-language-server
        require("lspconfig").arduino_language_server.setup({
            cmd = {
                "arduino-language-server",
                "-cli",
                "/usr/bin/arduino-cli",
                "-clangd",
                vim.fn.exepath("clangd"),
                "-fqbn",
                "arduino:avr:uno", -- <-- Set your board here
            },
        })
    end,
}
