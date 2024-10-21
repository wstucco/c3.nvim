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
            sync_install = false, -- Use true if you want synchronous installation
            auto_install = true,
        },
        config = function()
            require("nvim-treesitter.install").prefer_git = true -- Use Git for installation
            -- Ensure the parser for C3 is available
            local ts = require("nvim-treesitter")

            -- Retrieve the Tree-sitter parser for the current buffer
            local parser = ts.get_parser(0, "c3") -- 0 = current buffer

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
