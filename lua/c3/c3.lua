vim.filetype.add({
    extension = {
        c3 = "c3",
        c3i = "c3",
        c3t = "c3",
    },
});

local parser_config = require("nvim-treesitter.parsers").get_parser_configs();
parser_config.c3 = {
    install_info = {
        url = "https://github.com/c3lang/tree-sitter-c3",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "main",
    },
};

return {
    recommended = {
        ft = "c3",
        root = { "project.json" },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "c3" },
            highlight = { enable = true },
        },
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                c3_lsp = {
                    cmd = { "c3-lsp" },
                }
            }
        }
    },
}
