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

local function download_c3_queries()
    local query_url = "https://raw.githubusercontent.com/c3lang/tree-sitter-c3/refs/heads/main/queries/highlights.scm"
    local is_windows = vim.fn.has("win32") == 1
    local file_path

    if is_windows then
        file_path = vim.fn.stdpath("config") .. "\\queries\\c3\\highlights.scm" -- Windows path
    else
        file_path = vim.fn.stdpath("config") .. "/queries/c3/highlights.scm"    -- POSIX path
    end

    -- Create the directory if it doesn't exist
    vim.fn.mkdir(vim.fn.fnamemodify(file_path, ":h"), "p")

    -- Download the file based on the OS
    local download_cmd
    if is_windows then
        download_cmd = {
            "powershell", "-Command",
            "(New-Object Net.WebClient).DownloadFile('" .. query_url .. "', '" .. file_path .. "')"
        }
    else
        download_cmd = { "curl", "-s", "-o", file_path, query_url }
    end

    -- Execute the download command
    local response = vim.fn.system(download_cmd)

    if vim.v.shell_error == 0 then
        print("Downloaded C3 Treesitter query.")
    else
        print("Failed to download C3 Treesitter query.")
    end
end


-- Call the function to download queries
download_c3_queries()

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
