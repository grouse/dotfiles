call plug#begin("~/.config/nvim/plugged")

Plug 'vim-scripts/Smart-Tabs'
Plug 'neomake/neomake'
Plug 'kassio/neoterm'

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

"" neoterm configuration
let g:neoterm_position = 'horizontal'
let g:neoterm_size = 15

"" custom variables
let g:project_dir = "~/projects"

"" custom functions
function! s:OpenProjectFunc(path)
	let g:project_dir = a:path
	let g:neomake_cpp_custom_args = [ a:path ]
endfunction

function! s:CompileProjectFunc()
	let cmd = g:project_dir . "/build.sh"
	call neoterm#do(cmd)
endfunction

"" custom commands
command! -nargs=1 -complete=dir OpenProject call s:OpenProjectFunc(<f-args>)
command! CompileProject call s:CompileProjectFunc()

"" leader keybinds
let mapleader=","

" the h at the end is a complete hack to stop the cursor from moving a character to the right, I 
" assume this is caused by some weird clash remapping 'c'?
map <leader>c :CompileProject <CR> h

"" window navigation keybinds
" vertical and horizontal split keybinds
map <C-s> :vsplit <CR> :wincmd l <CR>
map <A-s> :split <CR> :wincmd j <CR>

" keybinds to switch to left/down/up/right window
map <C-h> :wincmd h <CR>
map <C-j> :wincmd j <CR>
map <C-k> :wincmd k <CR>
map <C-l> :wincmd l <CR>


