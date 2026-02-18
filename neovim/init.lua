vim.g.loaded_netrw = 1 -- see nvim-tree
vim.g.loaded_netrwPlugin = 1
vim.g.copilot = true and not vim.g.vscode

vim.keymap.set("n", "<space>", "<nop>", { silent = true, remap = false })
vim.g.mapleader = ";"

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

local function tprint (tbl, indent)
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint  .. k ..  "= "
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\r\n"
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\r\n"
        elseif (type(v) == "table") then
            toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", indent-2) .. "}"
    return toprint
end

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

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.g.win32 = true
end

local project_path;
if vim.g.win32 then
    project_path = "D:\\projects"
else
    project_path = "~/projects"
end

local icons = {
    kinds = {
        Array         = " ",
        Boolean       = "◩ ",
        Class         = ' ',
        Color         = "󰏘 ",
        Constant      = " ",
        Constructor   = " ",
        Enum          = " ",
        EnumMember    = ' ',
        Event         = ' ',
        Field         = " ",
        File          = ' ',
        Folder        = "󰉋 ",
        Function      = "󰊕 ",
        Interface     = " ",
        Key           = ' ',
        Keyword       = "󰌋 ",
        Method        = "󰊕 ",
        Misc          = " ",
        Module        = " ",
        Namespace     = ' ',
        Null          = "ﳠ ",
        Number        = " ",
        Object        = ' ',
        Operator      = ' ',
        Package       = ' ',
        Property      = "󰜢 ",
        Reference     = " ",
        Snippet       = " ",
        String        = ' ',
        Struct        = " ",
        Text          = "󰉿 ",
        TypeParameter = ' ',
        Unit          = "󰑭 ",
        Value         = "󰎠 ",
        Variable      = "󰀫 ",
        Copilot       = "",
    },
    sources = {
        nvim_lsp = "λ",
        buffer   = "Ω",
        path     = "🖫",
        luasnip  = "⋗",
        copilot  = "",
        nvim_lua = "Π",
        cmdline  = "⌘",
    },
    diagnostics = {
        Error = "",
        Warn = "",
        Hint = "",
        Info = ""
    },
    filename = {
        modified = "●",
        readonly = "",
        unnamed = '[No Name]',
        newfile = '[New]',
    },
    fileformat = {
        unix = "LF",
        dos = "CRLF",
        mac = "CR",
    }
}

-- Annoyingly this is mostly for neovim's luas throwing me tons of warnings and "tips" that I haven't figured out how to disable and I cba
vim.lsp.handlers["textDocument/publishDiagnostics"] = nil

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { focusable = false })
vim.lsp.handlers["textDocument/documentHighlight"] = nil

vim.opt.clipboard:append{ 'unnamedplus' }
vim.opt.backup=false
vim.opt.undofile=true
vim.opt.termguicolors=true
vim.opt.mousemoveevent=true

vim.opt.inccommand="split"
vim.opt.ignorecase=true
vim.opt.smartcase=true
vim.opt.gdefault=true

vim.opt.copyindent = true
vim.opt.cindent = true
vim.opt.cinoptions = ">s,(0,u0,Us,w1,Ws,m1,j1,J1,:0,l1,Ls,is,g0,E-s"

vim.o.guifont = "UbuntuMono Nerd Font:h14"
vim.opt.cursorline=true
vim.opt.showmode=false
vim.opt.pumheight=2
vim.opt.scrolloff=5
vim.opt.sidescrolloff=5

vim.opt.expandtab=true
vim.opt.shiftwidth=4
vim.opt.softtabstop=0
vim.opt.tabstop=4
vim.o.breakat=" !@*+;:,/?"
vim.opt.linebreak=true
vim.opt.breakindent=true
vim.opt.breakindentopt="shift:8"

vim.opt.sessionoptions="curdir,folds,help,tabpages,winsize,terminal"

vim.opt.swapfile=false

vim.o.fillchars = "foldopen:,foldsep: ,foldclose:"
vim.o.list = true
vim.o.listchars = "trail:·,tab:  "

-- disabled due to shit performance on large files, e.g. flecs.c
-- vim.o.foldcolumn = "auto"
-- vim.o.foldlevel = 99
-- vim.o.foldlevelstart = 99
-- vim.o.foldenable = true

vim.diagnostic.config({
    virtual_text = false
})


if vim.g.vscode then
    vim.opt.inccommand="nosplit"
end

local function cmp_tabnine_build_path()
    if vim.loop.os_uname().sysname == "Windows_NT" then
        return "powershell ./install.ps1"
    else
        return "./install.sh"
    end
end

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    callback = function()
        if vim.bo.filetype == "gdscript" then
            vim.bo.expandtab=false
        end
    end
})

require("lazy").setup(
{
    {
        "ellisonleao/gruvbox.nvim",
        enabled = not vim.g.vscode,
        priority = 1000 ,
        config = true,
        opts = {
            contrast = "soft",
            bold = false,
            italic = {
                strings = false,
                emphasis = true,
                comments = false,
                operators = false,
                folds = true,
            },
        },
        init = function() require("gruvbox").setup() end

    },

    {
        "sainnhe/gruvbox-material",
        enabled = not vim.g.vscode,
        init = function() 
            vim.g.gruvbox_material_background = "soft" 
            vim.g.gruvbox_material_disable_italic_comment = true
        end
    },

    {
        "junegunn/vim-easy-align",
        init = function()
            vim.keymap.set({ "v", "x", "n" }, "ga", ":EasyAlign<CR>", { desc = "align..." })
        end
    },

    { 'numToStr/Comment.nvim', opts = {}, event = "BufEnter" },

    {
        "echasnovski/mini.move",
        opts = {
            mappings = {
                up = "",        down = "",
                left = "",      right = "",
                line_up = "",   line_down = "",
                line_left = "", line_right = "",
            }
        },
        keys = {
            { "<M-k>", function() require("mini.move").move_selection("up") end, desc = "Move up", mode = "x" },
            { "<M-j>", function() require("mini.move").move_selection("down") end, desc = "Move down", mode = "x" },
            { "<M-k>", function() require("mini.move").move_line("up") end, desc = "Move line up", mode = "n" },
            { "<M-j>", function() require("mini.move").move_line("down") end, desc = "Move line down", mode = "n" },

        }
    },

    {
        "mcauley-penney/tidy.nvim",
        opts = { filetype_exclude = { "markdown", "diff" } },
        keys = {
            { "<leader>te", function() require("tidy").toggle() end, desc = "Toggle Tidy" },
            { "<leader>tt", function() require("tidy").run() end, desc = "Toggle Tidy" },
        },
    },

    {
        "goolord/alpha-nvim",
        enabled = not vim.g.vscode,
        dependencies = { "rmagatti/auto-session" },
        config = function()
            local alpha = require "alpha"
            local dashboard = require "alpha.themes.dashboard"

            dashboard.section.buttons.val = {
                dashboard.button("f", "  > Find file",    "<CMD>Telescope find_files<CR>"),

                dashboard.button("n", "  > New File",     "<CMD>ene!<CR>"),
                dashboard.button("p", "  > Projects ",    "<CMD>SessionSearch<CR>"),
                dashboard.button("r", "  > Recent files", "<CMD>Telescope oldfiles <CR>"),
                dashboard.button("t", "󰊄  > Find Text",    "<CMD>Telescope live_grep<CR>"),

                dashboard.button("q", "󰅖  > Quit NVIM",    ":qa<CR>"),
            }

            alpha.setup(dashboard.opts)
        end
    },

    {
        "folke/which-key.nvim",
        enabled = not vim.g.vscode,
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            icons = {
                breadcrumb = "»",
                separator = "  ",
                group = "+",
            },
        }
    },

    {
        "rmagatti/auto-session",
        dependencies = { "nvim-telescope/telescope.nvim" },
        enabled = not vim.g.vscode,
        opts = {}
    },

    {
        "luukvbaal/statuscol.nvim",
        enabled = false,
        config = function()
            local builtin = require("statuscol.builtin")
            require("statuscol").setup({
                setopt = true,
                segments = {
                    { sign = { namespace = { "diagnostic/signs" }, maxwidth = 1, auto = true } },
                }
            })
        end
    },

    {
        "zbirenbaum/copilot.lua",
        enabled = vim.g.copilot,
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = { ["*"] = true }
        },
    },

    {
        "zbirenbaum/copilot-cmp",
        enabled = vim.g.copilot,
        dependencies = { "zbirenbaum/copilot.lua" },
        event = "InsertEnter",
        opts = {}
    },

    { "nvim-lua/plenary.nvim", branch = "master" },

    { "j-hui/fidget.nvim", opts = {} },

    {
        "olimorris/codecompanion.nvim",
        enabled = vim.g.copilot,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp",
        },
        opts = {
            interactions = {
                chat = { adapter = "copilot" },
            },
        },
        keys = {
            { "<leader>cc", "<cmd>CodeCompanionChat<cr>", desc = "CodeCompanion Chat", mode = { "n", "v" } },
            { "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion Actions", mode = { "n", "v" } },
            { "<leader>ct", "<cmd>CodeCompanionToggle<cr>", desc = "CodeCompanion Toggle", mode = "n" },
            { "<leader>ce", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to CodeCompanion", mode = "v" },
        },
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        enabled = not vim.g.vscode,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons'
        },
        file_types = { "markdown", "codecompanion" },
        init = function() require("render-markdown").setup() end,
        keys = {
            { "<leader>md", function() require("render-markdown").toggle() end, { "n" }, desc = "Toggle Markdown Rendering" }
        }
    },

    {
        "gorbit99/codewindow.nvim",
        enabled = not vim.g.vscode,
        opts = {
            auto_enable = true,
            minimap_width = 10,
            relative = "editor",
        },
        keys = {
            { "<leader>mm", function() require("codewindow").toggle_minimap() end, { "n" }, desc = "Toggle Minimap" },
        },
    },

    {
        "hrsh7th/nvim-cmp",
        enabled = not vim.g.vscode,
        branch = "main",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-path",
            "onsails/lspkind.nvim",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            local comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,
                cmp.config.compare.recently_used,
                cmp.config.compare.locality,
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            }

            local sources = cmp.config.sources({
                { name = "path" },
                { name = "nvim_lsp" },
                { name = "nvim_lsp_signature_help" },
                { name = "luasnip" },
            })

            local copilot_sources = sources;
            if vim.g.copilot then
                table.insert(comparators, 0, require("copilot_cmp.comparators").prioritize)

                copilot_sources = cmp.config.sources({
                    { name = "copilot" },
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "luasnip" },
                })

            end

            cmp.setup({
                view = {
                    entries = {
                        name = "custom",
                        selection_order = "near_cursor",
                    }
                },
                window = {
                    documentation = { max_height = 15 },
                    completion    = { max_height = 5 },
                },
                experimental = { ghost_text = { hl_group = "GhostText" } },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                enabled = function() return vim.g.autocomplete end,
                mapping = {
                    ['<C-n>'] = cmp.mapping.complete({ config = { sources = copilot_sources } }),
                    ['<C-space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-k>"] = cmp.mapping.select_prev_item(),

                    ['<Up>'] = cmp.mapping.scroll_docs(-2),
                    ['<Down>'] = cmp.mapping.scroll_docs(2),


                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        elseif cmp.visible() then
                            if luasnip.expandable() then
                                luasnip.expand()
                            else
                                cmp.confirm({ select = true })
                            end
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                },
                sources = sources,
                sorting = {
                    priority_weight = 2,
                    comparators = comparators,
                },
                formatting = {
                    fields = { 'icon', 'abbr', 'menu' },
                    format = function(entry, vim_item)
                        vim_item = lspkind.cmp_format({
                            maxwidth = { menu = 30, abbr = 50 },
                            ellipsis_char = '...',
                            show_labelDetails = true,
                        })(entry, vim_item)

                        local source_icon = icons.sources[entry.source.name] or ""
                        vim_item.menu = (vim_item.menu or "") .. " " .. source_icon
                        return vim_item
                    end,
                },
            })

            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    {
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' }
                        }
                    }
                })
            })
        end
    },

    {
        "L3MON4D3/LuaSnip",
        enabled = not vim.g.vscode,
        build = "make install_jsregexp",
        lazy = true
    },

    { -- buffer tabs
        "akinsho/bufferline.nvim",
        enabled = not vim.g.vscode,
        dependencies = "nvim-tree/nvim-web-devicons",
        branch = "main",
        opts = { options = {
            right_mouse_command = function(bufnum) 
                print("copied: ", vim.api.nvim_buf_get_name(bufnum))
                vim.fn.setreg("+", vim.api.nvim_buf_get_name(bufnum))
            end,
            middle_mouse_command = "bdelete! %d",       
            indicator = { style = "underline" },
            show_close_icon = false,
            show_buffer_icons = false,
            separator_style = "slant",
        }},
        event = "BufEnter",
        keys = {
            { "[b", function() require("bufferline").cycle(-1) end, desc = "Previous buffer" },
            { "]b", function() require("bufferline").cycle(1) end, desc = "Next buffer" },
        }
    },

    { -- statusbar
        "nvim-lualine/lualine.nvim",
        enabled = not vim.g.vscode,
        opts = {
            theme = "auto",
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'diagnostics'},
                lualine_c = {
                    { 'filename', symbols = icons.filename },
                },
                lualine_x = {
                    'encoding',
                    { 'fileformat', symbols = icons.fileformat },
                    'filetype'
                },
                lualine_y = {},
                lualine_z = {'location'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {'diagnostics'},
                lualine_c = { { 'filename', symbols = icons.filename } },
                lualine_x = {
                    'encoding',
                    { 'fileformat', symbols = icons.fileformat },
                    'filetype',
                },
                lualine_y = {},
                lualine_z = {'location'}
            }
        }
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        enabled = not vim.g.vscode,
        branch = "v3.x",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", 
            "MunifTanjim/nui.nvim",
        },
        keys = {
            { "<leader>f", function() require("neo-tree.command").execute({ toggle = true, position = "left" }) end, desc = "File browser" },
        }
    },

    {
        "rcarriga/nvim-notify",
        enabled = not vim.g.vscode,
        opts = {
            fps = 30,
            timeout = 2000,
            render = "compact",
            stages = "static",
        },
        init = function()
            vim.notify = vim.schedule_wrap(require("notify"))
            -- vim.notify = require("notify")
        end
    },

    {
        "williamboman/mason.nvim",
        enabled = not vim.g.vscode,
        cmd = "Mason",
        build = ":MasonUpdate",
    },

    {
        "neovim/nvim-lspconfig",
        enabled = not vim.g.vscode,
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "folke/neodev.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd" },
                automatic_installation = true,
            })

            require("neodev").setup()

            for type, icon in pairs(icons.diagnostics) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
            capabilities.offsetEncoding = { "utf-16" } 
            capabilities.positionEncodings = { "utf-16" } 

            vim.lsp.config('*', {
                capabilities = capabilities,
            })

            vim.lsp.config("lua_ls", {
                log_level = vim.lsp.protocol.MessageType.Error,
                capabilities = capabilities,
                completion = { callSnippet = "Replace" },
                diagnostics = { globals = { "vim" }, },
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.stdpath("config") .. "/lua"] = true,
                    },
                    checkThirdParty = false,
                },
            })

            vim.lsp.config("rust_analyzer", {
                capabilities = capabilities,
                diagnostics = {
                    enable = false
                }
            })

            vim.lsp.config("copilot", {
                capabilities = capabilities,
            })

            vim.lsp.config("clangd", {
                capabilities = capabilities,
                cmd = { "clangd", "--header-insertion=never" },
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(args)
                    local buffer = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    client.server_capabilities.semanticTokensProvider = nil

                    if client.name ~= "lua_ls" then
                        -- disabling this in lua cause it is all sorts of funky in giant require blocks, for example
                        require("nvim-navic").attach(client, buffer)

                        require("lualine").setup({
                            sections = {
                                lualine_c = {
                                    { 'filename', symbols = icons.filename },
                                    { "navic" },
                                },
                            }
                        })
                    end
                    
                    if client.name == "clangd" then
                        vim.keymap.set('n', '<M-o>', ":LspClangdSwitchSourceHeader<CR>", { desc = "Switch header/source", buffer = buffer })
                    end

                    vim.bo[buffer].omnifunc = 'v:lua.vim.lsp.omnifunc'
                    vim.bo[buffer].formatexpr = nil

                    vim.keymap.set('n', 'gD',    vim.lsp.buf.declaration,                            { desc = "Go to declaration",       buffer = buffer })
                    vim.keymap.set('n', 'gh',    vim.lsp.buf.hover,                                  { desc = "Preview declaration",     buffer = buffer })
                    vim.keymap.set('n', 'gk',    vim.lsp.buf.signature_help,                         { desc = "See signature help",      buffer = buffer })
                    vim.keymap.set('n', 'gd',    require("telescope.builtin").lsp_definitions,       { desc = "Find definition(s)",      buffer = buffer })
                    vim.keymap.set('n', 'grt',   require("telescope.builtin").lsp_type_definitions,  { desc = "Find type definition(s)", buffer = buffer })
                    vim.keymap.set('n', 'gri',   require("telescope.builtin").lsp_implementations,   { desc = "Find implementation(s)",  buffer = buffer })
                    vim.keymap.set('n', 'grr',   require("telescope.builtin").lsp_references,        { desc = "Find references",         buffer = buffer })
                    vim.keymap.set('n', '<C-f>', require("telescope.builtin").lsp_workspace_symbols, { desc = "Find symbol",             buffer = buffer })
                    vim.keymap.set('n', 'gra',   vim.lsp.buf.code_action,                            { desc = "Code action...",          buffer = buffer })
                end,
            })

        end
    },

    {
        "hedyhli/outline.nvim",
        opts = {},
        keys = {
            { "<leader>o", function() require("outline").toggle() end, desc = "Toggle outliner" },
        }
    },

    {
        "SmiteshP/nvim-navic",
        enabled = not vim.g.vscode,
        lazy = true,
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lualine/lualine.nvim",
        },
        opts = {
            separator = "  ",
            highlight = false,
            depth_limit = 5,
            depth_limit_indicator = "..",
            icons = icons.kinds,
        },
        init = function()
            vim.g.navic_silence = true
        end,
    },

    {
        'stevearc/stickybuf.nvim',
        opts = {},
    },

    {
        "stevearc/quicker.nvim",
        enabled = not vim.g.vscode,
        opts = {},
        keys = {
            { "<leader>q", function() require("quicker").toggle() end, desc = "Toggle quickfix window" },
        }
    },

    {
        "stevearc/overseer.nvim",
        dependencies = {
            "stevearc/quicker.nvim",
        },
        enabled = not vim.g.vscode,
        opts = {
            component_aliases = {
                default = {
                    { "on_result_diagnostics_quickfix", open = false },
                    { "on_output_quickfix", close = true },
                    "on_exit_set_status",
                    "on_complete_notify",
                    "on_complete_dispose",
                },
                default_vscode = {
                    "default",
                    { "on_result_diagnostics", remove_on_restart = true },
                    "on_result_diagnostics_quickfix",
                }
            }
        },
        keys = {
            { "<C-b>", function()
                local overseer = require("overseer")
                vim.cmd(":wa")
                local tasks = overseer.list_tasks({ recent_first = true })
                if vim.tbl_isempty(tasks) then
                    overseer.run_task()
                else
                    overseer.run_action(tasks[1], "restart")
                end
            end, desc = "Build last" },
            { "<M-b>", "<cmd>wa<CR><cmd>OverseerRun<CR>", desc = "Build select" },
            { "<leader>b", "<cmd>OverseerToggle bottom<CR>" , desc = "Toggle build output" },

        }
    },

    {
        "andymass/vim-matchup",
        enabled = false,--not vim.g.vscode,
        init = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup", fullwidth = true }
            vim.g.matchup_matchparen_deferred = 1
            vim.g.matchup_matchparen_insert_timeout = 5

        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
        --dependencies = { "andymass/vim-matchup", },
        enabled = not vim.g.vscode,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.install").prefer_git = false
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "comment", "c", "cpp", "bash", "vim", "lua" },
                auto_install = true,
                highlight = { enable = true },
                matchup = {
                    enable = true,
                    disable_virtual_text = true,
                    include_match_words = false,
                },
            })
            require("nvim-treesitter").setup()

            vim.treesitter.query.set("c", "indents", "")
            vim.treesitter.query.set("cpp", "indents", "")
        end
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        enabled = not vim.g.vscode,
        opts = {
            max_lines = 10,
            multiline_threshold = 1,
            mode = "topline",
        }
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },

    {
        "nvim-telescope/telescope.nvim", branch = "master",
        enabled = not vim.g.vscode,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            "nvim-telescope/telescope-project.nvim",
        },
        config = function()
            local telescope = require("telescope")
            local actions   = require("telescope.actions")
            local themes    = require("telescope.themes")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<Esc>"] = actions.close,
                        }
                    },
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { truncate = true, }
                },
                extensions = {
                    ["ui-select"] = { themes.get_dropdown() },
                    file_browser = {
                        theme = "ivy",
                        hijack_netrw = true,
                    },
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    }
                }
            })

            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
            telescope.load_extension("file_browser")
        end,
        keys = {
            {
                "<M-p>",
                function()
                    require("telescope.builtin").keymaps({
                        filter = function(entry) return entry.desc end,
                        modes = { vim.api.nvim_get_mode()["mode"] },
                    })
                end,
                { "n", "i", },
                desc = "Keymaps"
            },
            {
                "<M-;>",
                function()
                    require("telescope.builtin").commands({
                        filter = function(entry) return entry.desc end,
                    })
                end,
                desc = "Commands"
            },
            { '<C-p>', function() require("telescope.builtin").find_files() end, desc = "Find file" },
            { "<M-/>", function() require("telescope.builtin").live_grep() end, desc = "Grep files" },
        }
    },
},
{
    defaults = {
        version = "*",
    },
    dev = {
        path = project_path,
        patterns = { "grouse" },
        fallback =  true,
    }
})

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("hl_colorscheme", {}),
    desc = "post-colorscheme hooks to tweak highlight groups etc",
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "HighlightYank", { fg =  "#009c8f" })
    end
})

function toggle_dark_mode()
    if vim.o.background == "light" then
        vim.o.background = "dark"
    else
        vim.o.background = "light"
    end
end
vim.api.nvim_create_user_command("ToggleDarkmode", toggle_dark_mode, { desc = "Switch between light and dark mode" })
vim.keymap.set("n", "<f10>", function() toggle_dark_mode() end, { desc = "Toggle dark mode" })

vim.g.autocomplete = true
function toggle_autocomplete()
    vim.g.autocomplete = not vim.g.autocomplete
end
vim.api.nvim_create_user_command("ToggleAutocomplete", toggle_autocomplete, { desc = "Toggle cmp autocompletion" })
vim.keymap.set("n", "<leader>ac", toggle_autocomplete, { desc = "Toggle autocompletion" })

if not vim.g.vscode then
    vim.cmd([[colorscheme gruvbox-material]])
end

vim.keymap.set("n", "za", "za", { desc = "Toggle fold" })
vim.keymap.set("n", "zc", "zc", { desc = "Close fold" })
vim.keymap.set("n", "zo", "zo", { desc = "Open fold" })
vim.keymap.set("n", "zR", "zR", { desc = "Open all folds" })
vim.keymap.set("n", "zM", "zM", { desc = "Close all folds" })

vim.keymap.set("n", "<C-s>", ":w", { desc = "Save", silent = true })
vim.keymap.set("n", "<C-S-s>", ":wa", { desc = "Save all", silent = true })

vim.keymap.set("n", "<M-left>", ":tabNext<CR>", { silent = true, desc = "Previous tab page" })
vim.keymap.set("n", "<M-right>", ":tabnext<CR>", { silent = true, desc = "Next tab page" })
vim.keymap.set("n", "<M-1>", function() vim.api.nvim_set_current_tabpage(1) end, { desc = "Open 1st tab page" })
vim.keymap.set("n", "<M-2>", function() vim.api.nvim_set_current_tabpage(2) end, { desc = "Open 2nd tab page" })
vim.keymap.set("n", "<M-3>", function() vim.api.nvim_set_current_tabpage(3) end, { desc = "Open 3rd tab page" })
vim.keymap.set("n", "<M-4>", function() vim.api.nvim_set_current_tabpage(4) end, { desc = "Open 4th tab page" })

if vim.g.neovide then
    vim.o.guifont = "UbuntuMono Nerd Font:h14"
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_scroll_animation_length = 0
    vim.g.neovide_floating_corner_radius = 10.0
end

vim.keymap.set('v', '<', '<gv', { desc = "Decrease increment", silent = true })
vim.keymap.set('v', '>', '>gv', { desc = "Increase increment", silent = true })
vim.keymap.set('n', 'n', 'nzz', { desc = "Next search result", silent = true })
vim.keymap.set('n', 'N', 'Nzz', { desc = "Prev search result", silent = true })
vim.keymap.set('n', "<CR>", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<C-q>", ":close<CR>", { desc = "Close window", silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })

vim.keymap.set("n", "<X1Mouse>", "<C-o>", { desc = "Jump next" })
vim.keymap.set("n", "<X2Mouse>", "<C-i>", { desc = "Jump prev" })

if not vim.g.vscode then
    vim.keymap.set("n", '<leader>d', vim.diagnostic.open_float, { desc = "Open diagnostic" })
    vim.keymap.set('n', '<C-j>',
        function()
            local size = #vim.fn.getqflist()
            if size == 0 or size == nil then return end

            if size == 1 then
                vim.cmd("clast!")
            else
                vim.cmd("cnext!")
            end
        end,
        { desc = "Next diagnostic" })
    vim.keymap.set('n', '<C-k>',
        function()
            local size = #vim.fn.getqflist()
            if size == 0 then return end

            if size == 1 then
                vim.cmd("cfirst!")
            else
                vim.cmd("cprev!")
            end
        end,
        { desc = "Prev diagnostic" })

    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" });
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" });
end

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', {}),
    desc = 'Hightlight selection on yank',
    pattern = '*',
    callback = function()
        vim.highlight.on_yank { higroup = 'HighlightYank', timeout = 500 }
    end,
})

if not vim.g.win32 then
    local pipepath = vim.fn.stdpath("cache") .. "/server.pipe"
    if not vim.loop.fs_stat(pipepath) then
        vim.fn.serverstart(pipepath)
    end
end
