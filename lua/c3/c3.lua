vim.filetype.add({
    extension = {
        c3 = "c3",
        c3i = "c3",
        c3t = "c3",
    },
});

-- Add C3 parser configuration
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.c3 = {
    install_info = {
        url = "https://github.com/c3lang/tree-sitter-c3",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "main",
    },
    sync_install = false, -- Set to true if you want to install synchronously
    auto_install = true,  -- Automatically install when opening a file
    filetype = "c3",      -- if filetype does not match the parser name
}


return {
    -- Recommended configuration for C3
    recommended = function()
        return LazyVim.extras.wants({
            ft = "c3",
            root = { "project.json" },
        })
    end,
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "c3" },
            highlight = { enable = true },
            sync_install = true, -- Use true if you want synchronous installation
            auto_install = true,
        },
        config = function()
            require("nvim-treesitter.install").prefer_git = true -- Use Git for installation
            -- Ensure the parser for C3 is available
            local ts = require("nvim-treesitter")

            -- Debugging: Check if nvim-treesitter is loaded
            local ts_ok, ts = pcall(require, "nvim-treesitter")
            if ts_ok then
                vim.notify("nvim-treesitter loaded successfully")
            else
                vim.notify("Failed to load nvim-treesitter", vim.log.levels.ERROR)
                return
            end

            -- Check if the parser for C3 is available
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

            if parser_config["c3"] then
                vim.notify("C3 parser configuration found")
            else
                vim.notify("C3 parser configuration NOT found", vim.log.levels.ERROR)
            end

            -- Retrieve the Tree-sitter parser for the current buffer
            local success, parser = pcall(ts.get_parser, 0, "c3")
            if success then
                vim.notify("C3 parser loaded successfully for the current buffer")
            else
                vim.notify("Failed to load C3 parser: " .. parser, vim.log.levels.ERROR)
            end

            -- You can now work with the parser instance
            print(parser:parse())
            local query_path = vim.fn.stdpath("config") .. "/queries/c3/highlights.scm"
            ts.query.set("c3", "highlights", vim.fn.readfile(query_path))
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                c3_lsp = {
                    cmd = { "c3-lsp" },
                },
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-context", -- Optional: For better context display
    },
    {
        "nvim-treesitter/nvim-treesitter-refactor", -- Optional: For code refactoring features
    },
}
