call plug#begin("~/.config/nvim/plugged")

Plug 'vim-scripts/Smart-Tabs'
Plug 'neomake/neomake'

call plug#end()

"" assorted configuration
set clipboard+=unnamedplus
set ruler
set relativenumber

" set text width to (100-1) to automatically word wrap at 100 columns, stumbled upon this
" awesomeness by accident
set tw=99

"" tab configuration
" All of this together with smart tabs plugin results in automatic indent with
" tabs and align with spaces.
set noexpandtab
set copyindent
set preserveindent
set softtabstop=0
set shiftwidth=4
set tabstop=4
set cindent
set cinoptions=(0,u0,U0

"" scrolling configuration
set scrolloff=3
set sidescrolloff=5

"" incremental search configuration
set ignorecase
set smartcase
set gdefault

colorscheme wombat256

" neomake configuration
let g:neomake_custom_maker = { 'exe': 'build.sh' }

function! s:OpenProjectFunc(param)
	let g:neomake_custom_args = [ a:param ]
endfunction
command! -nargs=1 OpenProject call s:OpenProjectFunc(<f-args>)

map <F5> :Neomake! custom <CR>

"" window navigation keybinds
" vertical and horizontal split keybinds
map <C-s> :vsplit <CR> :wincmd l <CR>
map <A-s> :split <CR> :wincmd j <CR>

" keybinds to switch to left/down/up/right window
map <C-h> :wincmd h <CR>
map <C-j> :wincmd j <CR>
map <C-k> :wincmd k <CR>
map <C-l> :wincmd l <CR>


