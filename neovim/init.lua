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
    { 'hrsh7th/cmp-nvim-lsp' },

    { "saadparwaiz1/cmp_luasnip", enabled = not vim.g.vscode  },
    { "hrsh7th/nvim-cmp",         enabled = not vim.g.vscode  },      
    { "L3MON4D3/LuaSnip",         enabled = not vim.g.vscode, version = "2.*", build = "make install_jsregexp" },

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
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    
    local function cmp_select_or_fallback(fallback)
        if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
            fallback()
        end
    end

    cmp.setup({
        completion = { autocomplete = false, },
        experimental = { ghost_text = true, },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body) 
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping(function(fallback)
                cmp.complete()
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            end),
            ['<Esc>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.abort()
                else
                    fallback()
                end
            end),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["("] = cmp.mapping(cmp_select_or_fallback),
            ["."] = cmp.mapping(cmp_select_or_fallback),
            ["::"] = cmp.mapping(cmp_select_or_fallback),
            ["<CR>"] = cmp.mapping({
                i = cmp_select_or_fallback,
                s = cmp.mapping.confirm({ select = true }),
                c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            }),
        }),
        sources = cmp.config.sources(
            {
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {{ name = 'buffer' }})
    })

    require("overseer").setup()
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { "clangd" }
    })

    local cmp_caps = require("cmp_nvim_lsp").default_capabilities()
    local lsp = require("lspconfig")
    lsp.clangd.setup({ capabilities = cmp_caps })

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

            Error = { link = "Ignore" },
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
vim.opt.gdefault=true

vim.opt.cursorline=true
vim.opt.showmode=false

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
end


vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('v', '>', '>gv', { silent = true })
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', "<CR>", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<C-q>", ":bd<CR>", { silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })

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

    vim.keymap.set("n", "<M-b>", ":OverseerRun<CR>", { silent = true })
    vim.keymap.set("n", "<M-j>", ":OverseerToggle bottom<CR>", { silent = true })
    vim.keymap.set("n", "<M-h>", ":OverseerToggle left<CR>", { silent = true })
    vim.keymap.set("n", "<M-l>", ":OverseerToggle right<CR>", { silent = true })
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
