call plug#begin("~/.config/nvim/plugged")

	Plug 'vim-scripts/Smart-Tabs'
	Plug 'derekwyatt/vim-fswitch'
	Plug 'mhartington/oceanic-next'
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'

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

"" errorformats
" gcc
set errorformat+="%f:%l:%c: error: %m"

"" color scheme and syntax highlight configuration
" third-party colorscheme
set background=dark
colorscheme OceanicNext 

" custom overrides
function! SetCustomHighlights()
	syn keyword myNote contained NOTE 
	syn keyword myTodo contained TODO FIXME IMPORTANT

	hi myNote guibg=none guifg=#ffff00 ctermfg=yellow
	hi myTodo guibg=none guifg=#ff0000 ctermfg=red

	syn cluster cCommentGroup contains=myNote,myTodo
	syn cluster vimCommentGroup contains=myNote,myTodo
endfunction()

au BufRead,BufNewFile * call SetCustomHighlights()

"" airline configuration
let g:airline_powerline_fonts = 1
let g:airline_theme = "oceanicnext"

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod  = ":t"

let g:airline_section_a = airline#section#create(["mode"])
let g:airline_section_b = airline#section#create(["%m%t"])
let g:airline_section_c = "" 

let g:airline_section_x = "" 
let g:airline_section_y = airline#section#create(["ffenc"])
let g:airline_section_z = airline#section#create(["%l:%c"])
let g:airline_section_error   = ""
let g:airline_section_warning = "" 

"" custom variables
let g:project_dir         = "~/projects"
let g:project_compile_cmd = "build.sh"

"" custom functions
function! s:OpenProjectFunc(path)
	let g:project_dir         = a:path
endfunction

"" custom commands
command! -nargs=1 -complete=dir OpenProject call s:OpenProjectFunc(<f-args>)

"" compilation
let s:compile_job        = -1 

function! s:compile_on_output(job_id, data, event)
	cadde a:data
endfunction

function! s:compile_on_exit(job_id, data, event)
	call jobstop(s:compile_job)
	let s:compile_job = -1

	cnext
endfunction

let s:compile_callbacks = {
	\'on_stdout': function('s:compile_on_output'),
	\'on_stderr': function('s:compile_on_output'),
	\'on_exit'  : function('s:compile_on_exit')
\}

function! s:compile_start()
	if s:compile_job != -1 
		echo "compilation job already in progress"
		return
	endif

	" NOTE: consider using own implementation of location-list to get more customisable features
	" like separate warning and error lists, adding the compile error + any corresponding notes,
	" which gcc/clang puts on preceding line and is often useful, as a dropdown/overlay type UI
	" thing.
	" NOTE: quickfix/location list does give us some built in features like being able to see the 
	" contents with an easy command, replacing the compilation buffer output. Potentially it's
	" possible to neatly extend the quickfix functionality to be able to do what we want.
	call setqflist([])

	let s:compile_job = jobstart(['bash'], s:compile_callbacks)

	call jobsend(s:compile_job, g:project_dir . "/" . g:project_compile_cmd . "\n")
	call jobsend(s:compile_job, "exit\n")
endfunction

function! s:compile_next_error()
	" TODO: wrap
	cnext
endfunction

function! s:compile_prev_error()
	" TODO: wrap
	cprev
endfunction

command! Compile call s:compile_start()
command! CompileNextError call s:compile_next_error()
command! CompilePrevError call s:compile_prev_error()

"" leader keybinds
let mapleader=","

map <leader>c :Compile <CR>
map <leader>n :CompileNextError <CR>
map <leader>p :CompilePrevError <CR>


"" window navigation keybinds
" vertical and horizontal split keybinds
map <C-s> :vsplit <CR> :wincmd l <CR>
map <A-s> :split <CR> :wincmd j <CR>

" keybinds to switch to left/down/up/right window
map <C-h> :wincmd h <CR>
map <C-j> :wincmd j <CR>
map <C-k> :wincmd k <CR>
map <C-l> :wincmd l <CR>

"" fuzzy file and buffer find configuration
map <C-p> :CtrlP <CR> 
map <A-p> :CtrlPBuffer <CR>
map <C-a> :CtrlP <C-r>=g:project_dir<CR><CR>

"" source/header file switching
map <F4> :FSHere <CR>
