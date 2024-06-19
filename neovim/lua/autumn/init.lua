local M = {}
local util = require("autumn.util")

M.config = {}


local colors = {
    base03 = "#0b352e",
    base02 = "#0d3f37",

    --- solarized
    -- base03 = "#002b36",
    -- base02 = "#073642",

    --- seleneized
    -- base03 = "#103c48",
    -- base02 = "#184956",

    base01 = "#586e75", -- fg tone2
    base00 = "#657b83", -- fg tone1
    base0  = "#53676d", -- fg main
    base1  = "#93a1a1", -- fg tone0

    -- base2  = "#ede4c7", -- bg tone0, window accents, sidebars, cursorline, popup/floating background
    -- base3  = "#fcf2d6", -- bg main

    base2  = "#ece3cc", -- bg tone0, window accents, sidebars, cursorline, popup/floating background
    base3  = "#fbf3db",

    --- solarized
    -- yellow  = "#b58900",
    -- orange  = "#cb4b16",
    -- red     = "#dc322f",
    -- magenta = "#d33682",
    -- violet  = "#6c71c4",
    -- blue    = "#268bd2",
    -- cyan    = "#2aa198",
    -- green   = "#859900",

    --- selenized
    red     = "#d2212d",
    green   = "#489100",
    yellow  = "#ad8900",
    blue    = "#0072d4",
    magenta = "#ca4898",
    cyan    = "#009c8f",
    orange  = "#c25d1e",
    violet  = "#8762c6",
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
            -- selection_bg = "#dfca88",
            selection_fg = "#6c6c6c",

            selection_bg = util.darken(colors.base3, 0.15),
            --selection_fg = util.darken(colors.base3, 0.35),
        },

        dark = {
            base0 = "#edd9a3",
            base1 = colors.base01,
            base2 = colors.base02,
            base3 = colors.base03,
            base00  = colors.base0,
            base01  = colors.base1,
            base02  = colors.base2,
            base03  = colors.base3,

            selection_bg = util.lighten(colors.base03, 0.15),
            selection_fg = util.lighten(colors.base03, 0.35),
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

function M.set(mode)
    M.load({ mode = palette })
    if mode == "light" then
        vim.cmd("colorscheme autumn-light")
    elseif mode == "dark" then
        vim.cmd("colorscheme autumn-dark")
    else
        vim.cmd("colorscheme autumn")
    end

end

M.setup = M.load

return M
