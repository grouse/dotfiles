local M = {}

M.config = {}

local colors = {
    base03 = "#20352e", -- bg tone2
    base02 = "#244238", -- bg tone1

    base01 = "#586e75", -- fg tone2
    base00 = "#657b83", -- fg tone1
    base0  = "#839496", -- fg main
    base1  = "#93a1a1", -- fg tone0

    base2  = "#ede4c7", -- bg tone0, window accents, sidebars, cursorline, popup/floating background
    base3  = "#fcf2d6", -- bg main

    yellow  = "#b58900",
    orange  = "#cb4b16",
    red     = "#dc322f",
    magenta = "#d33682",
    violet  = "#6c71c4",
    blue    = "#268bd2",
    cyan    = "#2aa198",
    green   = "#859900",
}

local defaults = {
    palette = "auto", -- dark, light, or auto (uses vim.o.background)
    sidebars = {
        "help", "qf", "OverseerList", "Trouble",
    },
    colors = {
        state = {
            -- diff
            add     = colors.green,
            change  = colors.yellow,
            delete  = colors.red,

            -- diagnostics
            info    = colors.cyan,
            hint    = colors.green,
            warning = colors.yellow,
            error   = colors.red,
        },

        light = {
        },

        dark = {
            base0 = "#EDD9A3",
            base1 = colors.base01,
            base2 = colors.base02,
            base3 = colors.base03,
            base00  = colors.base0,
            base01  = colors.base1,
            base02  = colors.base2,
            base03  = colors.base3,
        },
    }
}

function M.get_colors()
    if M.config.palette == "light" or (M.config.palette == "auto" and vim.o.background == "light") then
        M.config.palette = "light"
        return vim.tbl_deep_extend("force", {}, colors, M.config.colors.state, M.config.colors.light)
    else
        M.config.palette = "dark"
        return vim.tbl_deep_extend("force", {}, colors, M.config.colors.state, M.config.colors.dark)
    end
end

function M.highlight(group, hl)
    vim.api.nvim_set_hl(0, group, hl)
end

function M.load(opts)
    opts = opts or {}

    vim.cmd('hi clear')
    if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
    if not vim.o.background then vim.o.background = "dark" end

    vim.o.termguicolors = true
    vim.g.colors_name = "autumn"

    M.config = {}
    M.config = vim.tbl_deep_extend("force", {}, defaults, opts)
    local colors = M.get_colors()
    local highlights = require("autumn.highlights").setup(opts, colors)

    for group, hl in pairs(highlights) do
        M.highlight(group, hl)
    end

    local group = vim.api.nvim_create_augroup("autumn", { clear = true })

    vim.api.nvim_create_autocmd("ColorSchemePre", {
        group = group,
        callback = function() vim.api.nvim_del_augroup_by_id(group) end,
    })

    local function set_whl()
        local win = vim.api.nvim_get_current_win()
        local whl = vim.split(vim.wo[win].winhighlight, ",")
        vim.list_extend(whl, { "Normal:NormalSB", "CursorLine:CursorLineSB", "SignColumn:SignColumnSB" })
        whl = vim.tbl_filter(function(hl)
            return hl ~= ""
        end, whl)
        vim.opt_local.winhighlight = table.concat(whl, ",")
    end

    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = table.concat(M.config.sidebars, ","),
        callback = set_whl,
    })
end

M.setup = M.load

return M
