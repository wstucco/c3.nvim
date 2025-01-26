vim.filetype.add({
    extension = {
        c3 = "c3",
        c3i = "c3",
        c3t = "c3",
    },
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.c3 = {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    install_info = {
        url = "https://github.com/c3lang/tree-sitter-c3",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "main",
        sync_install = false, -- Set to false for async installation
        auto_install = true,  -- Automatically installs the parser on demand
        filetype = "c3",      -- The filetype for C3
    },
    -- Force queries installation along with the parser
    query = {
        enable = true, -- This forces query installation
    },
}

-- Pre-calculate the LSP executable configuration before passing it into `opts`
local lsp_config = {}
local c3lsp_executable = vim.fn.executable("c3-lsp") == 1 and "c3-lsp" or nil

-- Fallback to 'c3lsp' if 'c3-lsp' is not found
if not c3lsp_executable then
    c3lsp_executable = vim.fn.executable("c3lsp") == 1 and "c3lsp" or nil
end


return {
    setup = function()
    end,
    recommended = {
        ft = "c3",
        root = { "project.json" },
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                c3_lsp = {
                    cmd = { c3lsp_executable },
                }
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
