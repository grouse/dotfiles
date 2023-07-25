require("mini.align").setup()
require("mini.comment").setup()
require("mini.jump").setup()
require("mini.move").setup()

if not vim.g.vscode then
    require("mini.animate").setup()
    require("mini.statusline").setup()
    require("mini.tabline").setup()
end

vim.opt.clipboard='unnamedplus'

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

vim.keymap.set('v', '<', '<silent><gv')
vim.keymap.set('v', '>', '<silent>>gv')
vim.keymap.set('n', 'n', '<silent>nzz')
vim.keymap.set('n', 'N', '<silent>Nzz')
vim.keymap.set('n', "<CR>", "<silent>:nohlsearch<CR>")

vim.cmd.highlight({"HighlightYank", "guifg=#5fb3b3"})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Hightlight selection on yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'HighlightYank', timeout = 500 }
  end,
})
