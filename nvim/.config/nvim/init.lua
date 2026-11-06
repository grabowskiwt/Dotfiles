--           _ _       _
-- __      _(_) |_ ___| | ____ _
-- \ \ /\ / / | __/ _ \ |/ / _` |
--  \ V  V /| | ||  __/   < (_| |
--   \_/\_/ |_|\__\___|_|\_\__, |
--                         |___/
-- Witek3023
-- https://github.com/Witek3023

-- ── Basic Options ─────────────────────────────────────────────────────────
vim.opt.number         = true       -- line numbers
vim.opt.relativenumber = false
vim.opt.cursorline     = true       -- highlight active line
vim.opt.termguicolors  = true       -- full color palette
vim.opt.signcolumn     = "yes"      -- sign column on the left (diagnostics, git)
vim.opt.scrolloff      = 8          -- always keep 8 lines above/below cursor

vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.smartindent    = true

vim.opt.wrap           = false
vim.opt.ignorecase     = true
vim.opt.smartcase      = true

vim.opt.splitright     = true
vim.opt.splitbelow     = true

vim.opt.updatetime     = 250
vim.opt.timeoutlen     = 400

vim.g.mapleader        = " "        -- leader = space

-- ── Keymaps ───────────────────────────────────────────────────────────────────
local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map("n", "<leader>w", "<cmd>w<cr>",  "Save")
map("n", "<leader>q", "<cmd>q<cr>",  "Close")
map("n", "<Esc>",     "<cmd>nohlsearch<cr>", "Clear search highlight")

-- move through visual lines (when wrapping)
map("n", "j", "gj")
map("n", "k", "gk")

-- load theme before lazy to prevent flashing
-- vim.cmd("colorscheme gruvbox")

-- ── Bootstrap lazy.nvim ──────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ──────────────────────────────────────────────────────────────────
require("lazy").setup({
    -- theme
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000, -- load before all other plugins (no flash)
        config = function()
            vim.o.background = "dark" -- or "light"
            require("gruvbox").setup({
                transparent_mode = false,
            })
            vim.cmd("colorscheme gruvbox")
        end,
    },
    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = {
                        normal = {
                            a = { fg = "#282828", bg = "#689d6a", gui = "bold" },
                            b = { fg = "#ebdbb2", bg = "#3c3836" },
                            c = { fg = "#ebdbb2", bg = "#282828" },
                        },
                        insert = {
                            a = { fg = "#282828", bg = "#d65d0e", gui = "bold" },
                        },
                        visual = {
                            a = { fg = "#282828", bg = "#8ec07c", gui = "bold" },
                        },
                        replace = {
                            a = { fg = "#282828", bg = "#fe8019", gui = "bold" },
                        },
                        command = {
                            a = { fg = "#282828", bg = "#fabd2f", gui = "bold" },
                        },
                        inactive = {
                            a = { fg = "#928374", bg = "#282828" },
                            b = { fg = "#928374", bg = "#282828" },
                            c = { fg = "#928374", bg = "#282828" },
                        },
                    },
                    component_separators = { left = "│", right = "│" },
                    section_separators   = { left = "", right = "" },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- better syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "lua", "python", "javascript", "typescript",
                "html", "css", "json", "yaml", "bash", "markdown",
            },
            highlight = { enable = true },
            indent = { enable = true },
        },
    },

    -- file explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
            vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })
        end,
    },

    -- fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "Buffers" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags,  { desc = "Help tags" })
        end,
    },

    -- auto pairs for brackets and quotes
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    -- preview hex colors in code (#ffffff, rgb(...))
    {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({ "*" }, { mode = "background" })
        end,
    },

}, {
    -- lazy.nvim options
    ui = { border = "rounded" },
    checker = { enabled = false },
})
