local M = {}

M.config = {}

local defaults = {
    palette = "auto", -- dark, light, or auto (uses vim.o.background)
    colors = {
        dark = {
            base00 = "#D5C4A1", -- fg main
            base01 = "#d36e2a", -- fg accent0, syntax keywords
            base02 = "#8ec07c", -- fg accent1, comments, text, strings
            base03 = "#84a89a", -- fg accent2, macros, annotations, pre-processor identifiers

            base10 = "#1B2E28", -- bg main
            base11 = "#657b83", -- bg accent0, visual
            base12 = "#254041", -- bg accent1, window accents, sidebars, cursorline, popup/floating background, 
            base13 = "#d36e2a", -- bg accent2, insert, selected menu item 
            base14 = "#8ec07c", -- bg accent3, command

            -- colors
            yellow  = "#b58900",
            orange  = "#cb4b16",
            red     = "#dc322f",
            magenta = "#d33682",
            violet  = "#6c71c4",
            blue    = "#268bd2",
            cyan    = "#2aa198",
            green   = "#859900",

            -- diff
            add     = "#859900",
            change  = "#b58900",
            delete  = "#dc322f",

            -- diagnostics
            info    = "#268bd2",
            hint    = "#859900",
            warning = "#b58900",
            error   = "#dc322f",
        },
        light = {
            base00 = "#1B2E28", -- fg main
            base01 = "#d36e2a", -- fg accent0, syntax keywords
            base02 = "#8ec07c", -- fg accent1, comments, text, strings
            base03 = "#84a89a", -- fg accent2, macros, annotations, pre-processor identifiers

            base10 = "#D5C4A1", -- bg main
            base11 = "#657b83", -- bg accent0, visual
            base12 = "#254041", -- bg accent1, window accents, sidebars, cursorline, popup/floating background, 
            base13 = "#d36e2a", -- bg accent2, insert, selected menu item 
            base14 = "#8ec07c", -- bg accent3, command

            -- colors
            yellow  = "#b58900",
            orange  = "#cb4b16",
            red     = "#dc322f",
            magenta = "#d33682",
            violet  = "#6c71c4",
            blue    = "#268bd2",
            cyan    = "#2aa198",
            green   = "#859900",

            -- diff
            add     = "#859900",
            change  = "#b58900",
            delete  = "#dc322f",

            -- diagnostics
            info    = "#268bd2",
            hint    = "#859900",
            warning = "#b58900",
            error   = "#dc322f",
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

    M.config = vim.tbl_deep_extend("force", {}, defaults, opts)
    local colors = M.get_colors()
    local highlights = require("autumn.highlights").setup(opts, colors)

    for group, hl in pairs(highlights) do
        M.highlight(group, hl)
    end
end


return M
