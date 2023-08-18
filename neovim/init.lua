vim.g.loaded_netrw = 1 -- see nvim-tree
vim.g.loaded_netrwPlugin = 1

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

local project_path;
if vim.g.win32 then
    project_path = "D:\\projects"
else
    project_path = "~/projects"
end

local icons = {
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
}

-- Annoyingly this is mostly for neovim's luas throwing me tons of warnings and "tips" that I haven't figured out how to disable and I cba
vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { focusable = false })

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
vim.opt.cinoptions = ">s,(0,u0,Us,Ws,:0,l1,is,g0,E-s"

vim.opt.cursorline=true
vim.opt.showmode=false
vim.opt.pumheight=5
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

if vim.g.vscode then
    vim.opt.inccommand="nosplit"
end

vim.o.guifont = "UbuntuMono Nerd Font:h14"

require("autumn").setup()

require("lazy").setup(
{
    { "echasnovski/mini.align",   version = "*", opts = {}},
    { "echasnovski/mini.comment", version = "*", opts = {}},
    { "echasnovski/mini.move",    version = "*", opts = {}},
    { 
        "echasnovski/mini.starter", 
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        version = "*", 
        config = function()
            local starter = require("mini.starter")
            starter.setup({
                items = {
                    starter.sections.sessions(5, true),
                    starter.sections.recent_files(5, false, false),
                    starter.sections.telescope(),
                    starter.sections.builtin_actions(),
                }
            })
        end
    },
    { 
        'echasnovski/mini.sessions',   
        version = '*', 
        enabled = not vim.g.vscode,
        opts = {
            directory = vim.fn.stdpath("data") .. "/session",
            file = "session.vim",
            hooks = {
                pre = {
                    read = function()
                        if vim.v.this_session ~= '' then require("mini.sessions").write(nil, { force = true }) end
                    end
                }
            }
        }
    },
    { 
        "hrsh7th/nvim-cmp",         
        enabled = not vim.g.vscode,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "saadparwaiz1/cmp_luasnip",
        },
        init = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                window = {
                    documentation = {
                        winhighlight = 'Normal:CppDocNormal,FloatBorder:CppDocBorder,CursorLine:CppDocSel,Search:None',
                    }
                },
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
                    ["<CR>"] = cmp.mapping({
                        i = function(fallback)
                            if cmp.visible() and cmp.get_active_entry() then
                                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                            else
                                fallback()
                            end
                        end,
                        s = cmp.mapping.confirm({ select = true }),
                        c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                    })
                },
                confirmation = {
                    default_behavior = cmp.ConfirmBehavior.Replace,
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = "nvim_lsp_signature_help" },
                    { name = 'luasnip' },
                    { name = "buffer" },
                    { name = "path" }
                }),
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, item)
                        local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
                        if icon then
                            item.kind = icon
                            item.kind_hl_group = hl_group
                        elseif icons[item.kind] then
                            item.kind = icons[item.kind]
                        end

                        item.menu = ({
                            buffer = "[Buffer]",
                            nvim_lsp = "[LSP]",
                            luasnip = "[LuaSnip]",
                            nvim_lua = "[Lua]",
                            latex_symbols = "[LaTeX]",
                        })[entry.source.name]

                        return item
                    end,
                },
            })
        end
    },
    { "L3MON4D3/LuaSnip",         enabled = not vim.g.vscode, version = "2.*", build = "make install_jsregexp" },
    { 'echasnovski/mini.starter',  version = '*',              enabled = not vim.g.vscode },
    {
        "akinsho/bufferline.nvim",
        enabled = not vim.g.vscode,
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
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
        init = function()
            vim.keymap.set({ "n", "i" }, "<M-o>", function() require("bufferline").cycle(1) end)
            vim.keymap.set({ "n", "i" }, "<M-i>", function() require("bufferline").cycle(-1) end)
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        enabled = not vim.g.vsode,
        opts = {
            theme = "auto",
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'diagnostics'},
                lualine_c = {
                    { 'filename', symbols = { modified = "●", readonly = "", unnamed = '[No Name]', newfile = '[New]' } },
                    { "navic" },
                },
                lualine_x = {
                    'encoding',
                    { 'fileformat', symbols = { unix = "LF", dos = "CRLF", mac = "CR" } },
                    'filetype'
                },
                lualine_y = {},
                lualine_z = {'location'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {'diagnostics'},
                lualine_c = {
                    { 'filename', symbols = { modified = "●", readonly = "", unnamed = '[No Name]', newfile = '[New]' } },
                },
                lualine_x = {
                    'encoding',
                    { 'fileformat', symbols = { unix = "LF", dos = "CRLF", mac = "CR" } },
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
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        opts = {
        },
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        opts = {
            position = "right",
        },
    },
    {
        "rcarriga/nvim-notify",
        enabled = not vim.g.vscode,
        opts = {
            fps = 60,
            timeout = 2000,
            render = "compact",
            stages = "slide",
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
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", },
        enabled = not vim.g.vsode,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "SmiteshP/nvim-navic",
            "folke/neodev.nvim",
        },
        enabled = not vim.g.vsode,
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd" },
                automatic_installation = true,
            })

            require("neodev").setup()

            local signs = { Error = "", Warn = "", Hint = "", Info = "" }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			local function on_attach(client, bufnr)
                if client.name ~= "lua_ls" then
                    -- disabling this in lua cause it is all sorts of funky in giant require blocks, for example
                    require("nvim-navic").attach(client, bufnr)
                end

                vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

                vim.keymap.set('n', 'gD',       vim.lsp.buf.declaration, { desc = "Go to declaration", buffer = bufnr })
                vim.keymap.set('n', 'K',        vim.lsp.buf.hover, { desc = "Preview declaration", buffer = bufnr })
                vim.keymap.set('n', 'gd',       require("telescope.builtin").lsp_definitions, { desc = "Find definition(s)", buffer = bufnr })
                vim.keymap.set('n', 'gi',       require("telescope.builtin").lsp_implementations, { desc = "Find implementation(s)", buffer = bufnr })
                vim.keymap.set('n', '<space>D', require("telescope.builtin").lsp_type_definitions, { desc = "Find type definition(s)", buffer = bufnr })
                vim.keymap.set('n', 'gr',       require("telescope.builtin").lsp_references, { desc = "Find references", buffer = bufnr })

                vim.keymap.set("n", "gR", vim.lsp.buf.rename, { desc = "Rename symbol", buffer = bufnr })
                vim.keymap.set("n", "gC", vim.lsp.buf.code_action, { desc = "Code action", buffer = bufnr })
            end

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(args)
                    local buffer = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    on_attach(client, buffer)
                end,
            })

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

            require("lspconfig").clangd.setup({
                capabilities = capabilities,
            })

            require("lspconfig").rust_analyzer.setup({
                capabilities = capabilities,
                settings = {
                    ['rust-analyzer'] = {
                        diagnostics = {
                            enable = false;
                        }
                    }
                }
            })
        end
    },
    {
        "SmiteshP/nvim-navic",
        enabled = not vim.g.vscode,
        dependencies = { "neovim/nvim-lspconfig" },
        opts = {
            separator = "  ",
            highlight = false,
            depth_limit = 5,
            depth_limit_indicator = "..",
            icons = icons,
        },
        init = function()
            vim.g.navic_silence = true
        end
    },

    {
        "grouse/overseer.nvim",
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
                }
            }
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        enabled = not vim.g.vsode, 
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.install").prefer_git = false
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "comment", "c", "cpp", "bash", "vim", "lua" },
                auto_install = true,
                highlight = {
                    enable = true,
                },
                additional_vim_regex_highlighting = false,

            })
            require("nvim-treesitter").setup()
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            line_numbers = false,
            mode = "topline", 
        }
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.2",
        enabled = not vim.g.vscode,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzy-native.nvim",
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
                        }
                    },
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = {
                        truncate = true,
                    }
                },
                pickers = {
                    find_files = { theme = "ivy" },
                    live_grep = { theme = "ivy" },
                    keymaps = { theme = "ivy" },
                },
                extensions = {
                    ["ui-select"] = { themes.get_dropdown() },
                    file_browser = {
                        theme = "ivy",
                        hijack_netrw = true,
                    }
                }
            })

            telescope.load_extension("fzy_native")
            telescope.load_extension("ui-select")
            telescope.load_extension("file_browser")
        end
    },
    {
        "uga-rosa/ccc.nvim",
        opts = {
            highlighter = {
                auto_enable = true,
                lsp = true,
            },
        }
    },
},
{
    defaults = {
        lazy = false,
    },
    dev = {
        path = project_path,
        patterns = { "grouse" },
        fallback =  true,
    }
})


vim.keymap.set("n", "<C-s>", ":w", { desc = "Save", silent = true })
vim.keymap.set("n", "<C-S-s>", ":wa", { desc = "Save all", silent = true })
vim.keymap.set("n", "<M-`>", require("mini.sessions").select, { desc = "Open session" })
vim.keymap.set("n", "<M-s>", require("mini.sessions").write, { desc = "Write session" })

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
vim.keymap.set("n", "<X1Mouse>", "<C-i>", { desc = "Jump next" })
vim.keymap.set("n", "<X2Mouse>", "<C-o>", { desc = "Jump prev" })

if not vim.g.vscode then
    vim.keymap.set("n", "<M-h>", ":Neotree toggle left<CR>", { silent = true, desc = "File browser" })

    vim.keymap.set("n", "<M-l>", require("trouble").toggle, { desc = "View diagnostics" })
    vim.keymap.set("n", '<space>e', vim.diagnostic.open_float, { desc = "Open diagnostic" })
    vim.keymap.set('n', '<C-j>', 
        function()
            local size = #vim.fn.getqflist()
            if size == 0 then return end

            local current = vim.fn.getqflist({ id = 0 }).id
            if current == size-1 or size == 1 then
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

            local current = vim.fn.getqflist({ id = 0 }).id
            if current == size-1 or size == 1 then
                vim.cmd("cfirst!")
            else
                vim.cmd("cprev!")
            end
        end,
        { desc = "Prev diagnostic" })


    vim.keymap.set("n", "<C-b>", function()
        local overseer = require("overseer")
        vim.cmd(":wa")
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
            overseer.run_template()
        else
            overseer.run_action(tasks[1], "restart")
        end
    end, { desc = "Build last" })

    vim.keymap.set("n", "<M-b>", ":wa<CR>:OverseerRun<CR>", { desc = "Build select", silent = true })
    vim.keymap.set("n", "<M-j>", ":OverseerToggle bottom<CR>", { desc = "Toggle build output", silent = true })

    vim.keymap.set({"n", "i", "c" }, "<M-p>", 
        function()
            require("telescope.builtin").keymaps({
                filter = function(entry) return entry.desc end,
                modes = { vim.api.nvim_get_mode()["mode"] },
            })
        end, 
        { desc = "Command palette" })
    vim.keymap.set('n', '<C-p>', require("telescope.builtin").find_files, { desc = "Find file" })
    vim.keymap.set("n", "<C-f>", require("telescope.builtin").live_grep, { desc = "Grep files" })
end

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', {}),
    desc = 'Hightlight selection on yank',
    pattern = '*',
    callback = function()
        vim.highlight.on_yank { higroup = 'HighlightYank', timeout = 500 }
    end,
})
