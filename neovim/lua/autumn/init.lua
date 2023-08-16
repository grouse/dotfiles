local M = {}

M.config = {}

local colors = {
    dark = {
        yellow  = "#FFEC51",
        orange  = "#F2AF29",
        red     = "#D95D39",
        magenta = "#d33682",
        violet  = "#6c71c4",
        blue    = "#006992",
        cyan    = "#2aa198",
        green   = "#2C8E49",
    },
    light = {
        yellow  = "#FFEC51",
        orange  = "#F2AF29",
        red     = "#D95D39",
        magenta = "#d33682",
        violet  = "#6c71c4",
        blue    = "#006992",
        cyan    = "#2aa198",
        green   = "#2C8E49",
    }
}

local defaults = {
    palette = "auto", -- dark, light, or auto (uses vim.o.background)
    sidebars = {
        "help", "qf", "OverseerList", "Trouble",
    },
    colors = {
        dark = {
            base00 = "#EDD9A3", -- fg main
            base01 = "#d36e2a", -- fg accent0, syntax keywords
            base02 = "#8ec07c", -- fg accent1, comments, text, strings
            base03 = "#84a89a", -- fg accent2, macros, annotations, pre-processor identifiers

            base10 = "#233329", -- bg main
            base11 = "#1d6656", -- bg accent0, visual
            base12 = "#3A5543", -- bg accent1, window accents, sidebars, cursorline, popup/floating background, 
            base13 = "#d36e2a", -- bg accent2, insert, selected menu item 

            base20 = "#132319",

            -- colors
            yellow  = colors.dark.yellow,
            orange  = colors.dark.orange,
            red     = colors.dark.red,
            magenta = colors.dark.magenta,
            violet  = colors.dark.violet,
            blue    = colors.dark.blue,
            cyan    = colors.dark.cyan,
            green   = colors.dark.green,

            -- diff
            add     = colors.dark.green,
            change  = colors.dark.yellow,
            delete  = colors.dark.red,

            -- diagnostics
            info    = colors.dark.cyan,
            hint    = colors.dark.green,
            warning = colors.dark.yellow,
            error   = colors.dark.red,
        },
        light = {
            base00 = "#1B2E28", -- fg main
            base01 = "#d36e2a", -- fg accent0, syntax keywords
            base02 = "#6ea05c", -- fg accent1, comments, text, strings
            base03 = "#84a89a", -- fg accent2, macros, annotations, pre-processor identifiers

            base10 = "#EDD9A3", -- fg main
            base11 = "#657b83", -- bg accent0, visual
            base12 = "#254041", -- bg accent1, window accents, sidebars, cursorline, popup/floating background, 
            base12 = "#DDC993", -- fg main
            base13 = "#d36e2a", -- bg accent2, insert, selected menu item 
            base14 = "#8ec07c", -- bg accent3, command

            -- colors
            yellow  = colors.light.yellow,
            orange  = colors.light.orange,
            red     = colors.light.red,
            magenta = colors.light.magenta,
            violet  = colors.light.violet,
            blue    = colors.light.blue,
            cyan    = colors.light.cyan,
            green   = colors.light.green,

            -- diff
            add     = colors.light.green,
            change  = colors.light.yellow,
            delete  = colors.light.red,

            -- diagnostics
            info    = colors.light.cyan,
            hint    = colors.light.green,
            warning = colors.light.yellow,
            error   = colors.light.red,
        }
    }
}

function M.get_colors()
    if M.config.palette == "light" or (M.config.palette == "auto" and vim.o.background == "light") then
        return M.config.colors.light
    else
        return M.config.colors.dark
    end
end

function M.highlight(group, hl)
    vim.api.nvim_set_hl(0, group, hl)
end

function M.setup(opts)
    opts = opts or {}

    if vim.g.colors_name then
        vim.cmd('hi clear')
    end

    if vim.fn.exists('syntax_on') then
        vim.cmd('syntax reset')
    end

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


return M
