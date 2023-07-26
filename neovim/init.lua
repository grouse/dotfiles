if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.g.win32 = true
end

require("mini.align").setup()
require("mini.comment").setup()
require("mini.jump").setup()
require("mini.move").setup()

if not vim.g.vscode then
    require("kanagawa").setup()
    vim.cmd.colorscheme("kanagawa-wave")

    require("lualine").setup()

    require("telescope").setup()
    require("telescope").load_extension("fzy_native")

    if not vim.g.win32 then
        require("mini.animate").setup()
    end

    require("mini.statusline").setup()
    require("mini.tabline").setup()

    require("nvim-treesitter.install").prefer_git = false
    require("nvim-treesitter.configs").setup {
        ensure_installed = { "comment", "c", "cpp", "bash", "vim" },
        auto_install = false,
        highlight = {
            enable = true,
        },
        additional_vim_regex_highlighting = false,
    }
    require("nvim-treesitter").setup()
end

vim.opt.clipboard:append{ 'unnamedplus' }

vim.opt.ignorecase=true
vim.opt.smartcase=true
vim.opt.cursorline=true
vim.opt.inccommand="split"

vim.opt.expandtab=true
vim.opt.shiftwidth=4
vim.opt.softtabstop=0
vim.opt.tabstop=4

if vim.g.vscode then
	vim.opt.inccommand="nosplit"
end

vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', "<CR>", ":nohlsearch<CR>")

if not vim.g.vscode then
    local telescope = require("telescope.builtin")
    vim.keymap.set('n', '<C-p>', telescope.find_files, {})
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
