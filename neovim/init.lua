vim.g.loaded_netrw = 1 -- see nvim-tree
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ";"

vim.g.copilot = false
vim.g.tabnine = false

if not vim.g.vscode then
    vim.g.copilot = true
end

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
        cmp_tabnine   = "",
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

vim.opt.cursorline=true
vim.opt.showmode=false
vim.opt.pumheight=2
vim.opt.scrolloff=5
vim.opt.sidescrolloff=5

vim.opt.expandtab=true
vim.opt.shiftwidth=4
vim.opt.softtabstop=0
vim.opt.tabstop=4
vim.opt.linebreak=true
vim.opt.breakindent=true
vim.opt.breakindentopt="shift:8"

vim.opt.sessionoptions="curdir,folds,help,tabpages,winsize,terminal"

vim.o.fillchars = "foldopen:,foldsep: ,foldclose:"
vim.o.list = true
vim.o.listchars = "eol:,trail:·,tab: "

-- disabled due to shit performance on large files, e.g. flecs.c
-- vim.o.foldcolumn = "auto"
-- vim.o.foldlevel = 99
-- vim.o.foldlevelstart = 99
-- vim.o.foldenable = true

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

vim.o.guifont = "UbuntuMono Nerd Font:h14"

require("autumn").setup()
require("lazy").setup(
{
    {
        "junegunn/vim-easy-align",
        init = function()
            vim.keymap.set({ "v", "x", "n" }, "ga", ":EasyAlign<CR>", { desc = "align..." })
        end
    },
    {
        'numToStr/Comment.nvim',
        opts = {},
        event = "BufEnter",
    },
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
        init = function()
            vim.keymap.set("n", "<leader>te", require("tidy").toggle, { desc = "Toggle Tidy" })
        end
    },
    {
        "echasnovski/mini.starter",
        enabled = not vim.g.vscode,
        dependencies = { "echasnovski/mini.sessions", },
        config = function()
            local starter = require("mini.starter")
            starter.setup({
                items = {
                    starter.sections.recent_files(10, false, true),
                    starter.sections.sessions(10, true),
                    {
                        {
                            name = "Find file",
                            section = "Telescope",
                            action = function(opts) return require("telescope.builtin").find_files(opts) end,
                        },
                        {
                            name = "Help",
                            section = "Telescope",
                            action = function(opts) return require("telescope.builtin").help_tags(opts) end,
                        },
                    },
                    starter.sections.builtin_actions(),
                }
            })
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
        'echasnovski/mini.sessions',
        enabled = not vim.g.vscode,
        opts = {
            hooks = {
                pre = {
                    read = function()
                        if vim.v.this_session ~= '' then require("mini.sessions").write(nil, { force = true }) end
                    end
                }
            }
        },
        init = function()
            vim.api.nvim_create_user_command("OpenSession", function() require("mini.sessions").select() end, { desc = "Open session" })
            vim.api.nvim_create_user_command("CreateSession", function(opts)
                session_name = nil
                if opts and opts.fargs[1] then
                    session_name = opts.fargs[1]
                else
                    -- use the last part of the cwd as the session name
                    cwd = vim.fn.getcwd()
                    session_name = cwd:match("^.+[\\/](.+)$") .. ".vim"
                end

                require("mini.sessions").write(session_name)
            end, { nargs = "?", complete = "file", desc = "Create a new session" })
        end
    },
    {
        -- disabled due to shit performance on large files
        'kevinhwang91/nvim-ufo',
        enabled = false,
        dependencies = { 'kevinhwang91/promise-async' },
    },
    {
        "luukvbaal/statuscol.nvim",
        enabled = not vim.g.vscode,
        config = function()
            local builtin = require("statuscol.builtin")
            require("statuscol").setup({
                segments = {
                    {
                        text = { builtin.foldfunc },
                        condition = { builtin.not_empty },
                        click = "v:lua.ScFa"
                    },
                    {
                        sign = { name = { "Diagnostic" }, maxwidth = 1, auto = true },
                        click = "v:lua.ScSa"
                    },
                }
            })
        end
    },
    {
        'tzachar/cmp-tabnine',
        build = cmp_tabnine_build_path(),
        dependencies = { 'hrsh7th/nvim-cmp', },
        enabled = vim.g.tabnine,
        config = function()
            local tabnine = require('cmp_tabnine.config')

            tabnine:setup({
                max_lines = 1000,
                max_num_results = 20,
                sort = true,
                run_on_every_keystroke = true,
                snippet_placeholder = '..',
                ignored_file_types = {},
                show_prediction_strength = false
            })
        end
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        enabled = vim.g.copilot,
        opts = {
            event = "InsertEnter",
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                ["*"] = true,
            }
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    {
        "zbirenbaum/copilot-cmp",
        enabled = vim.g.copilot,
        dependencies = { "zbirenbaum/copilot.lua" },
        event = "InsertEnter",
        opts = {}
    },
    {
        "hrsh7th/nvim-cmp",
        enabled = not vim.g.vscode,
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            local comparators = {
                cmp.config.compare.score,
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.recently_used,
                cmp.config.compare.locality,
                cmp.config.compare.kind,
                cmp.config.compare.order,
                cmp.config.compare.length,
            }

            if vim.g.tabnine then
                table.insert(comparators, 0, require("cmp_tabnine.compare"))
            end

            if vim.g.copilot then
                table.insert(comparators, 0, require("copilot_cmp.comparators").prioritize)
            end

            cmp.setup({
                completion = { autocomplete = false },
                view = {
                    entries = {
                        name = 'custom',
                        selection_order = 'near_cursor',
                    }
                },
                window = {
                    documentation = {
                        winhighlight = 'Normal:CmpDocNormal,FloatBorder:CmpDocBorder,CursorLine:CmpDocSel,Search:None',
                    },
                    completion = {
                        col_offset = 10,
                        scrollbar = false,
                    }
                },
                experimental = { ghost_text = { hl_group = "GhostText" } },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ['<C-n>'] = cmp.mapping.complete(),
                    ['<Esc>'] = cmp.mapping(function(fallback)
                        cmp.abort()
                        fallback()
                    end),

                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

                    ["<C-p>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
                sources = cmp.config.sources({
                    { name = "copilot" },
                    { name = "cmp_tabnine" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "luasnip" },
                    { name = "path" },
                }),
                sorting = {
                    priority_weight = 2,
                    comparators = comparators,
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, item)
                        local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
                        if icon then
                            item.kind = icon
                            item.kind_hl_group = hl_group
                        elseif icons.kinds[item.kind] then
                            item.kind = icons.kinds[item.kind]
                        end

                        item.menu = ({
                            buffer        = "[Buffer]",
                            nvim_lsp      = "[LSP]",
                            luasnip       = "[LuaSnip]",
                            nvim_lua      = "[Lua]",
                            latex_symbols = "[LaTeX]",
                            copilot       = "[CoPilot]",
                            cmp_tabnine   = "[TabNine]",
                        })[entry.source.name]

                        return item
                    end,
                },
            })
        end
    },
    {
        "L3MON4D3/LuaSnip",
        enabled = not vim.g.vscode,
        build = "make install_jsregexp",
        lazy = true
    },
    { 'echasnovski/mini.starter',  enabled = not vim.g.vscode, },
    {
        "akinsho/bufferline.nvim",
        enabled = not vim.g.vscode,
        dependencies = "nvim-tree/nvim-web-devicons",
        branch = "main",
        opts = { options = {
            right_mouse_command = false,
            indicator = { style = "underline" },
            show_buffer_icons = false,
            separator_style = "slant",
            hover = {
                enabled = true,
                delay = 0,
                reveal = { "close" }
            },
        }},
        event = "BufEnter",
        keys = {
            { "[b", function() require("bufferline").cycle(-1) end, desc = "Previous buffer" },
            { "]b", function() require("bufferline").cycle(1) end, desc = "Next buffer" },
        }
    },
    {
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
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        keys = {
            { "<C-w>f", function() require("neo-tree.command").execute({ toggle = true, position = "left" }) end, desc = "File browser" },
        }
    },
    {
        "folke/trouble.nvim",
        enabled = not vim.g.vscode,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = { position = "right", },
        keys = {
            { "<C-w>d", function() require("trouble").toggle() end, desc = "View diagnostics" },
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
            vim.notify = require("notify")
        end
    },
    { "stevearc/dressing.nvim", enabled = not vim.g.vscode, opts = {} },
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
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }

            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
            capabilities.offsetEncoding =  'utf-16'

            local function on_attach(client, bufnr)
                if client.name ~= "lua_ls" then
                    -- disabling this in lua cause it is all sorts of funky in giant require blocks, for example
                    require("nvim-navic").attach(client, bufnr)

                    require("lualine").setup({
                        sections = {
                            lualine_c = {
                                { 'filename', symbols = icons.filename },
                                { "navic" },
                            },
                        }
                    })
                end

                vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
                vim.bo[bufnr].formatexpr = nil

                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,                           { desc = "Go to declaration",       buffer = bufnr })
                vim.keymap.set('n', 'gH', vim.lsp.buf.hover,                                 { desc = "Preview declaration",     buffer = bufnr })
                vim.keymap.set('n', 'gd', require("telescope.builtin").lsp_definitions,      { desc = "Find definition(s)",      buffer = bufnr })
                vim.keymap.set('n', 'gt', require("telescope.builtin").lsp_type_definitions, { desc = "Find type definition(s)", buffer = bufnr })
                vim.keymap.set('n', 'gi', require("telescope.builtin").lsp_implementations,  { desc = "Find implementation(s)",  buffer = bufnr })
                vim.keymap.set('n', 'gr', require("telescope.builtin").lsp_references,       { desc = "Find references",         buffer = bufnr })

                vim.keymap.set("n", "gC", vim.lsp.buf.code_action, { desc = "Code action",   buffer = bufnr })
                vim.keymap.set("n", "gR", vim.lsp.buf.rename,      { desc = "Rename symbol", buffer = bufnr })

                vim.keymap.set('n', '<C-f>', require("telescope.builtin").lsp_workspace_symbols, { desc = "Find symbol", buffer = bufnr })
            end

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(args)
                    local buffer = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    on_attach(client, buffer)
                end,
            })

            require("mason-lspconfig").setup_handlers {
                function(server_name)
                    require("lspconfig")[server_name].setup{ capabilities = capabilities }
                end,
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        log_level = vim.lsp.protocol.MessageType.Error,
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                completion = { callSnippet = "Replace" },
                                diagnostics = { globals = { "vim" }, },
                                workspace = {
                                    library = {
                                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                        [vim.fn.stdpath("config") .. "/lua"] = true,
                                    },
                                    checkThirdParty = false,
                                },
                            },
                        }
                    })
                end,
                ["rust_analyzer"] = function()
                    require("lspconfig").rust_analyzer.setup({
                        capabilities = capabilities,
                        settings = {
                            ['rust-analyzer'] = {
                                diagnostics = {
                                    enable = false
                                }
                            }
                        }
                    })
                end,
            }
        end
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
        "stevearc/overseer.nvim",
        enabled = not vim.g.vscode,
        opts = {
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
                    overseer.run_template()
                else
                    overseer.run_action(tasks[1], "restart")
                end
            end, desc = "Build last" },
            { "<M-b>", "<cmd>wa<CR><cmd>OverseerRun<CR>", desc = "Build select" },
            { "<C-w>b", "<cmd>OverseerToggle bottom<CR>" , desc = "Toggle build output" },

        }
    },
    {
        "andymass/vim-matchup",
        enabled = not vim.g.vscode,
        init = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup", fullwidth = true }
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "andymass/vim-matchup",
        },
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
                },
            })
            require("nvim-treesitter").setup()

            vim.treesitter.query.set("c", "indents", "")
            vim.treesitter.query.set("cpp", "indents", "")
        end
    },
    {
        -- disabled due to stuttering on large files
        "nvim-treesitter/nvim-treesitter-context",
        enabled = false,
        dependencies = { "nvim-treesitter/nvim-treesitter", },
        opts = {
            line_numbers = false,
            mode = "topline",
        }
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && " ..
            "cmake --build build --config Release && " ..
            "cmake --install build --prefix build"
    },
    {
        "nvim-telescope/telescope.nvim", branch = "0.1.x",
        enabled = not vim.g.vscode,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-telescope/telescope-file-browser.nvim"
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local themes = require("telescope.themes")

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
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_scroll_animation_length = 0


    local increment_scale_factor = function(delta)
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
    end

    vim.keymap.set("n", "<C-ScrollWheelUp>",   function() increment_scale_factor(1/16) end,  { desc = "Zoom in" })
    vim.keymap.set("n", "<C-ScrollWheelDown>", function() increment_scale_factor(-1/16) end, { desc = "Zoom out" })
end

if vim.g.fvim_loaded then
    vim.o.guifont = "Ubuntu Mono:h18"

    vim.keymap.set({"n", "i"}, "<C-ScrollWheelUp>", ":set guifont=+<CR>", { silent = true })
    vim.keymap.set({"n", "i"}, "<C-ScrollWheelDown>", ":set guifont=-<CR>", { silent = true })
    vim.keymap.set({"n", "i"}, "<M-CR>", ":FVimToggleFullScreen<CR>", { silent = true })
end

vim.keymap.set('v', '<', '<gv', { desc = "Decrease increment", silent = true })
vim.keymap.set('v', '>', '>gv', { desc = "Increase increment", silent = true })
vim.keymap.set('n', 'n', 'nzz', { desc = "Next search result", silent = true })
vim.keymap.set('n', 'N', 'Nzz', { desc = "Prev search result", silent = true })
vim.keymap.set('n', "<CR>", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<C-q>", ":close<CR>", { desc = "Close window", silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })

-- NOTE(jesper): not actually sure if these work. They don't in neovide or nvim-qt, but I think that might be a client limitation, not having implemented the events properly
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
