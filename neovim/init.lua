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

function ReloadConfig()
    local hls_status = vim.v.hlsearch
    for name,_ in pairs(package.loaded) do
        if name:match('^cnull') then
            package.loaded[name] = nil
        end
    end

    dofile(vim.env.MYVIMRC)
    if hls_status == 0 then
        vim.opt.hlsearch = false
    end
end

vim.cmd("command! Reload lua ReloadConfig()")


if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.g.win32 = true
end

require("lazy").setup({
    { "echasnovski/mini.align",      version = "*" },
    { "echasnovski/mini.comment",    version = "*" },
    { "echasnovski/mini.jump",       version = "*" },
    { "echasnovski/mini.move",       version = "*" },
    { 'echasnovski/mini.sessions',   version = '*', enabled = not vim.g.vscode },
    { 'echasnovski/mini.starter',    version = '*', enabled = not vim.g.vscode },

    { 'hrsh7th/cmp-nvim-lsp' },
    { "saadparwaiz1/cmp_luasnip", enabled = not vim.g.vscode  },
    { "hrsh7th/nvim-cmp",         enabled = not vim.g.vscode  },      
    { "L3MON4D3/LuaSnip",         enabled = not vim.g.vscode, version = "2.*", build = "make install_jsregexp" },

    { "maxmx03/solarized.nvim", enabled = not vim.g.vscode },
    { "akinsho/bufferline.nvim", enabled = not vim.g.vscode, version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
    { "nvim-lualine/lualine.nvim",                enabled = not vim.g.vsode },
    { "nvim-tree/nvim-tree.lua", enabled = not vim.g.vscode, version = "*", dependencies = "nvim-tree/nvim-web-devicons" },

    { "neovim/nvim-lspconfig",                    enabled = not vim.g.vsode },
    { "williamboman/mason.nvim",                  enabled = not vim.g.vsode },
    { "williamboman/mason-lspconfig.nvim",        enabled = not vim.g.vsode },

    { "grouse/overseer.nvim",                   enabled = not vim.g.vscode, opts = {} },
    { "nvim-treesitter/nvim-treesitter",          enabled = not vim.g.vsode,  build = ":TSUpdate" },
    { "nvim-telescope/telescope.nvim",            enabled = not vim.g.vscode, tag = "0.1.2", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-fzy-native.nvim", enabled = not vim.g.vsode },
})

vim.g.loaded_netrw = 1 -- see nvim-tree
vim.g.loaded_netrwPlugin = 1

vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
vim.opt.clipboard:append{ 'unnamedplus' }
vim.opt.swapfile=false
vim.opt.undofile=true
vim.opt.termguicolors=true -- see bufferline.nvim
vim.opt.mousemoveevent=true

vim.opt.inccommand="split"
vim.opt.ignorecase=true
vim.opt.smartcase=true
vim.opt.gdefault=true

vim.opt.cindent = true
vim.opt.copyindent = true
vim.opt.cinoptions = "(0,u0,U0,:0,l1,g0"

vim.opt.cursorline=true
vim.opt.showmode=false
vim.opt.scrolloff=5
vim.opt.sidescrolloff=5
vim.opt.linebreak=true
vim.opt.breakindent=true
vim.opt.breakindentopt="shift:8"

vim.opt.expandtab=true
vim.opt.shiftwidth=4
vim.opt.softtabstop=0
vim.opt.tabstop=4

if vim.g.vscode then
    vim.opt.inccommand="nosplit"
end

vim.o.guifont = "UbuntuMono Nerd Font:h14"

if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_scroll_animation_length = 0


    local increment_scale_factor = function(delta)
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
    end

    vim.keymap.set("n", "<C-ScrollWheelUp>", function() increment_scale_factor(1/16) end, {});
    vim.keymap.set("n", "<C-ScrollWheelDown>", function() increment_scale_factor(-1/16) end, {});
end

if vim.g.fvim_loaded then
    vim.o.guifont = "Ubuntu Mono:h18"

    vim.keymap.set({"n", "i"}, "<C-ScrollWheelUp>", ":set guifont=+<CR>", { silent = true })
    vim.keymap.set({"n", "i"}, "<C-ScrollWheelDown>", ":set guifont=-<CR>", { silent = true })
    vim.keymap.set({"n", "i"}, "<M-CR>", ":FVimToggleFullScreen<CR>", { silent = true })
end

require("mini.align").setup()
require("mini.comment").setup()
require("mini.jump").setup()
require("mini.move").setup()

if not vim.g.vscode then
    require("solarized").setup({
        styles = {
            parameters = { italic = false },
            keywords   = { bold   = false },
        },
        colors = function() 
            if vim.o.background == "dark" then
                return {
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

                    tmp = "#ff0000"
                }
            else
                return {}
            end
        end,
        highlights = function(colors, colorhelper)
            if vim.o.background == "dark" then
                return {
                    MatchParen = { fg   = "#fcedfc", bg = "none" },

                    Function     = { fg   = "#ccb486"  },
                    Operator     = { fg   = "#fcedfc", },
                    Type         = { fg   = "#ceb069"  },
                    Identifier   = { fg   = "#d5c4a1"  },
                    Constant     = { fg   = "#e9e4c6", },
                    Macro        = { fg = "#84a89a"   },

                    Define       = { link = "Keyword"  },
                    PreProc      = { link = "Define"   },
                    Include      = { link = "Define"   },
                    PreCondit    = { link = "Define"   },

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

                    Error = { link = "Ignore" },

                    TelescopeNormal = { bg = colors.base03 },
                    TelescopeBorder = { bg = colors.base03 },
                }
            else
                return {
                    MatchParen = { fg   = "#000000", bg = "none" },
                    
                    Define       = { link = "Keyword"  },
                    PreProc      = { link = "Define"   },
                    Include      = { link = "Define"   },
                    PreCondit    = { link = "Define"   },

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
                    
                    Error = { link = "Ignore" },

                    TelescopeNormal = { bg = colors.base03 },
                    TelescopeBorder = { bg = colors.base03 },
                }
            end
        end
    })

    require("lualine").setup({
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'diagnostics'},
            lualine_c = {
                { 
                    'filename', 
                    symbols = {
                        modified = "●",
                        readonly = "",
                        unnamed = '[No Name]', 
                        newfile = '[New]',    
                    }
                }
            },
            lualine_x = {
                'encoding', 
                {
                    'fileformat', 
                    symbols = {
                        unix = "LF",
                        dos = "CRLF",
                        mac = "CR"
                    }
                },
                'filetype'
            },
            lualine_y = {},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {
                { 
                    'filename', 
                    symbols = {
                        modified = "●",
                        readonly = "",
                        unnamed = '[No Name]', 
                        newfile = '[New]',    
                    }
                }
            },
            lualine_x = {
                'encoding', 
                {
                    'fileformat', 
                    symbols = {
                        unix = "LF",
                        dos = "CRLF",
                        mac = "CR"
                    }
                },
                'filetype',
            },
            lualine_y = {},
            lualine_z = {'location'}
        }
    })

    require("bufferline").setup({ options = {
        right_mouse_command = false,
        indicator = { style = "underline" },
        show_buffer_icons = false,
        separator_style = "slant",
        hover = {
            enabled = true,
            delay = 0,
            reveal = { "close" }
        }

    }})

    require("nvim-tree").setup({
        disable_netrw = true,
        renderer = {
            icons = {
                show = {
                    file = false,
                    git = false,
                }
            }
        },
        actions = {
            open_file = {
                quit_on_open = true,
            }
        }
    })

    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
        completion = { autocomplete = false, },
        experimental = { ghost_text = true, },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body) 
            end,
        },
        mapping = {
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<Esc>'] = cmp.mapping(function(fallback)
                cmp.abort()
                fallback()
            end),
            ['<C-e>'] = cmp.mapping.abort(),
            ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
            ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.confirm({ select = true })
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },  
        confirmation = {
            default_behavior = cmp.ConfirmBehavior.Replace,
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' }, 
            { name = "buffer" },
            { name = "path" }
        },
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                local kind_icons = {
                    Text = "󰉿",
                    Method = "󰆧",
                    Function = "󰊕",
                    Constructor = "",
                    Field = " ",
                    Variable = "󰀫",
                    Class = "󰠱",
                    Interface = "",
                    Module = "",
                    Property = "󰜢",
                    Unit = "󰑭",
                    Value = "󰎠",
                    Enum = "",
                    Keyword = "󰌋",
                    Snippet = "",
                    Color = "󰏘",
                    File = "󰈙",
                    Reference = "",
                    Folder = "󰉋",
                    EnumMember = "",
                    Constant = "󰏿",
                    Struct = "",
                    Event = "",
                    Operator = "󰆕",
                    TypeParameter = " ",
                    Misc = " "
                }

                vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                vim_item.menu = ({
                    nvim_lsp = "[LSP]",
                    luasnip  = "[Snippet]",
                    buffer   = "[Buffer]",
                    path     = "[Path]",
                })[entry.source.name]

                return vim_item
            end,
        },  
    })



    require("overseer").setup({
        component_aliases = {
            default = {
              { "display_duration", detail_level = 1 },
              "on_output_summarize",
              "on_exit_set_status",
              "on_complete_notify",
              "on_complete_dispose",
              "on_result_diagnostics_quickfix",
            },
            default_vscode = {
                "default",
                { "on_result_diagnostics", remove_on_restart = true },
            }
        }
    })
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { "clangd" }
    })

    local cmp_caps = require("cmp_nvim_lsp").default_capabilities()
    local lsp = require("lspconfig")
    lsp.clangd.setup({ capabilities = cmp_caps })


    local actions = require("telescope.actions")
    require("telescope").setup({
        pickers = {
            find_files = { theme = "ivy", },
        },
    })
    require("telescope").load_extension("fzy_native")

    if not vim.g.win32 then
        --require("mini.animate").setup()
    end

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

vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('v', '>', '>gv', { silent = true })
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', "<CR>", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<C-q>", ":close<CR>", { silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })

-- NOTE(jesper): not actually sure if these work. They don't in neovide or nvim-qt, but I think that might be a client limitation, not having implemented the events properly
vim.keymap.set("n", "<X1Mouse>", "<C-i>", {})
vim.keymap.set("n", "<X2Mouse>", "<C-o>", {})

if not vim.g.vscode then
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '<C-j>', ":cnext<CR>", { silent = true })
    vim.keymap.set('n', '<C-k>', ":cprev<CR>", { silent = true })

    local builtin = require("telescope.builtin")
    vim.keymap.set('n', '<C-p>', builtin.find_files, {})
    vim.keymap.set("n", "<C-f>", builtin.live_grep, {})

    local overseer = require("overseer")
    vim.keymap.set("n", "<C-b>", function()
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
            vim.cmd.OverseerRun()
        else
            overseer.run_action(tasks[1], "restart")
        end
    end, {})

    vim.keymap.set("n", "<M-b>", ":OverseerRun<CR>", { silent = true })
    vim.keymap.set("n", "<M-j>", ":OverseerToggle bottom<CR>", { silent = true })
    vim.keymap.set("n", "<M-l>", ":OverseerToggle right<CR>", { silent = true })

    local nvim_tree = require("nvim-tree.api")
    vim.keymap.set("n", "<M-h>", nvim_tree.tree.toggle, {})

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
