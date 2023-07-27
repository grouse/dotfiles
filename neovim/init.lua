local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.g.win32 = true
end

require("lazy").setup({
    { "echasnovski/mini.align",      version = "*" },
    { "echasnovski/mini.comment",    version = "*" },
    { "echasnovski/mini.jump",       version = "*" },
    { "echasnovski/mini.move",       version = "*" },
    { "echasnovski/mini.statusline", version = "*", enabled = not vim.g.vsode },
    { "echasnovski/mini.tabline",    version = "*", enabled = not vim.g.vsode },
    { 'echasnovski/mini.sessions',   version = '*', enabled = not vim.g.vscode },
 	{ 'echasnovski/mini.starter',    version = '*', enabled = not vim.g.vscode },

    { "maxmx03/solarized.nvim", enabled = not vim.g.vscode },

    { "neovim/nvim-lspconfig",                    enabled = not vim.g.vsode },
    { "williamboman/mason.nvim",                  enabled = not vim.g.vsode },
    { "williamboman/mason-lspconfig.nvim",        enabled = not vim.g.vsode },

    { "nvim-lualine/lualine.nvim",                enabled = not vim.g.vsode },
    { "stevearc/overseer.nvim",                   enabled = not vim.g.vscode, opts = {} },
    { "nvim-treesitter/nvim-treesitter",          enabled = not vim.g.vsode,  build = ":TSUpdate" },
    { "nvim-telescope/telescope.nvim",            enabled = not vim.g.vscode, tag = "0.1.2", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-fzy-native.nvim", enabled = not vim.g.vsode },
})

require("mini.align").setup()
require("mini.comment").setup()
require("mini.jump").setup()
require("mini.move").setup()

if not vim.g.vscode then
    require("overseer").setup()
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { "clangd" }
    })

    local lsp = require("lspconfig")
    lsp.clangd.setup({})

    require("solarized").setup({
        styles = {
            parameters = { italic = false },
            keywords   = { bold   = false },
        },
        colors = {
            base0  = '#D5C4A1', -- content tone (foreground)
            base1  = '#d36e2a', -- content tone (statusline/tabline)
            base2  = '#eee8d5', -- background tone light (highlight)
            base3  = '#fdf6e3', -- background tone lighter (main)

            base00 = '#657b83', -- content tone (winseparator)
            base01 = '#8ec07c', -- content tone (comment)
            base02 = '#254041', -- background tone (highlight/menu/LineNr)
            base03 = '#1B2E28', -- background tone dark (main)
            base04 = '#00222b', -- background tone darker (column/nvim-tree)

            blue   = '#d5c4a1',
            violet = '#ceb069',
            cyan   = '#689d6a',

            info   = '#ddda30',
        },
        highlights = {
            Function     = { fg   = "#ccb486"  },
            Operator     = { fg   = "#fcedfc", },
            Type         = { fg   = "#ceb069"  },

            Identifier   = { fg   = "#d5c4a1"  },

            Constant     = { fg   = "#e9e4c6", },
            Number       = { link = "Constant" },
            Boolean      = { link = "Constant" },
            Float        = { link = "Constant" },

            Structure    = { link = "Keyword"  },
            Statement    = { link = 'Keyword'  },
            Conditional  = { link = 'Keyword'  },
            Label        = { link = 'Keyword'  },
            Exception    = { link = 'Keyword'  },
            StorageClass = { link = 'Keyword'  },
            Typedef      = { link = 'Keyword'  },
            Repeat       = { link = "Keyword"  },

            Macro        = { fg = "#84a89a"   },

            Define       = { link = "Keyword"  },
            PreProc      = { link = "Define"   },
            Include      = { link = "Define"   },
            PreCondit    = { link = "Define"   },
        }
    })

    require("lualine").setup()

    require("telescope").setup()
    require("telescope").load_extension("fzy_native")

    if not vim.g.win32 then
        --require("mini.animate").setup()
    end

    require("mini.statusline").setup()
    require("mini.tabline").setup()
    require("mini.sessions").setup({
        directory = vim.fn.stdpath("data") .. "/session",
        file = "",
    })
    require("mini.starter").setup()

    require("nvim-treesitter.install").prefer_git = false
    require("nvim-treesitter.configs").setup {
        ensure_installed = { "comment", "c", "cpp", "bash", "vim", "lua" },
        auto_install = false,
        highlight = {
            enable = true,
        },
        additional_vim_regex_highlighting = false,
    }
    require("nvim-treesitter").setup()
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

vim.opt.clipboard:append{ 'unnamedplus' }
vim.opt.ignorecase=true
vim.opt.smartcase=true
vim.opt.cursorline=true
vim.opt.inccommand="split"
vim.opt.scrolloff=5
vim.opt.sidescrolloff=5
vim.opt.expandtab=true
vim.opt.shiftwidth=4
vim.opt.softtabstop=0
vim.opt.tabstop=4

if vim.g.vscode then
	vim.opt.inccommand="nosplit"
end

if not vim.g.vscode then
    vim.o.guifont = "UbuntuMono Nerd Font:h14"
end

if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_scroll_animation_length = 0

    vim.keymap.set({"n", "i"}, "<C-s>", ":w<CR>")
end


vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', "<CR>", ":nohlsearch<CR>")
vim.keymap.set("n", "<C-q>", ":bd<CR>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

if not vim.g.vscode then
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '<C-j>', vim.diagnostic.goto_prev)
    vim.keymap.set('n', '<C-k>', vim.diagnostic.goto_next)

    local builtin = require("telescope.builtin")
    vim.keymap.set('n', '<C-p>', builtin.find_files, {})
    vim.keymap.set("n", "<C-f>", builtin.live_grep, {})
    vim.keymap.set("n", "<C-:>", builtin.command_history, {})
    vim.keymap.set("n", "<C-l>", builtin.builtin, {})

    vim.keymap.set("n", "<C-b>", function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
            vim.cmd.OverseerRun()
        else
            overseer.run_action(tasks[1], "restart")
        end
    end, {})

    vim.keymap.set("n", "<M-b>", ":OverseerRun<CR>", {})
    vim.keymap.set("n", "<M-j>", ":OverseerToggle bottom<CR>", {})
    vim.keymap.set("n", "<M-h>", ":OverseerToggle left<CR>", {})
    vim.keymap.set("n", "<M-l>", ":OverseerToggle right<CR>", {})

end

vim.cmd.highlight({"HighlightYank", "guifg=#5fb3b3"})
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Hightlight selection on yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'HighlightYank', timeout = 500 }
  end,
})


if not vim.g.vscode then
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        local telescope = require("telescope.builtin")
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', telescope.lsp_definitions, opts)
        vim.keymap.set('n', 'gi', telescope.lsp_implementations, opts)
        vim.keymap.set('n', '<space>D', telescope.lsp_type_definitions, opts)
        vim.keymap.set('n', 'gr', telescope.lsp_references, opts)
      end,
    })
end
