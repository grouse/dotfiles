" relative line numbering for victory
set relativenumber

" tab configuration
set tabstop=4
set shiftwidth=4

set ruler

" scrolling configuration
set scrolloff=3
set sidescrolloff=5

" incremental search configuration
set ignorecase
set smartcase
set gdefault

colorscheme wombat256

set listchars=tab:>-

" window navigation keybinds
" vertical and horizontal split keybinds
map <C-s> :vsplit <CR> :wincmd l <CR>
map <A-s> :split <CR> :wincmd j <CR>

" keybinds to switch to left/down/up/right window
map <C-h> :wincmd h <CR>
map <C-j> :wincmd j <CR>
map <C-k> :wincmd k <CR>
map <C-l> :wincmd l <CR>


