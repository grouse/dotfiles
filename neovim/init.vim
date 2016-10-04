call plug#begin("~/.config/nvim/plugged")
	"" assorted plugins

	"" tool plugins
	Plug 'critiqjo/lldb.nvim'

	"" navigation related plugins
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'derekwyatt/vim-fswitch'
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

	"" editing related plugins
	Plug 'scrooloose/nerdcommenter'
	Plug 'matze/vim-move'
	Plug 'vim-scripts/Smart-Tabs'
	Plug 'godlygeek/tabular'

	"" ui/look and feel related plugins
	Plug 'equalsraf/neovim-gui-shim'
	Plug 'vim-airline/vim-airline'
	Plug 'machakann/vim-highlightedyank'
call plug#end()


"" assorted configuration
set clipboard+=unnamedplus
set relativenumber
set ruler
set noshowmode

set list
"set listchars=eol:⏎,tab: ,trail:⎵
set listchars=eol:⏎,tab:▶\ 


" set text width to (100-1) to automatically word wrap at 100 columns, stumbled upon this
" awesomeness by accident
set tw=99


"" tab configuration
" All of this together with smart tabs plugin results in automatic indent with
" tabs and align with spaces.
set cindent
set cinoptions=(0,u0,U0
set copyindent
set noexpandtab
set preserveindent
set shiftwidth=4
set softtabstop=0
set tabstop=4


"" scrolling configuration
set scrolloff=3
set sidescrolloff=5


"" incremental search configuration
set gdefault
set ignorecase
set smartcase


"" errorformats
" gcc
set errorformat+="%f:%l:%c: error: %m"
" msvc
set errorformat+="%f(%l): error %#: %m"


"" color scheme and syntax highlight configuration
syntax enable
set termguicolors
set cursorline
set background=dark

colorscheme grouse

" custom highlights 
" NOTE(jesper): should probably do this by overriding syntax linter files, but this seems the
" cleanest way of getting global highlights without having to edit syntax files for every single
" file type i'm interested in
function! SetCustomHighlights()
	syn keyword Note contained NOTE 
	syn keyword Todo contained TODO FIXME IMPORTANT

	syn cluster cCommentGroup contains=Note,Todo
	syn cluster vimCommentGroup contains=Note,Todo
endfunction()

au BufRead,BufNewFile * call SetCustomHighlights()


function! s:insert_file_header()
	let author    = 'Jesper Stefansson'
	let email     = 'jesper.stefansson@gmail.com'

	so ~/.config/nvim/templates/c.vim
	exe '%s/file: .*/file: ' . expand('%:t') . '/g'
	exe '%s/created: .*/created: ' . strftime('%Y-%m-%d') . '/g'
	exe '%s/authors: .*/authors: ' . author . ' (' . email . ')' 
endfunction()

command! InsertFileHeader :call s:insert_file_header()

au BufNewFile *.cpp call s:insert_file_header()



"" airline configuration
let g:airline_powerline_fonts = 1
let g:airline_theme = "grouse"

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


"" highlighted yank configuration
let g:highlightedyank_highlight_duration=200

"" custom variables
let g:project_dir         = "~/projects"
let g:project_compile_cmd = "build.sh"

if has ("win32")
	let g:project_compile_cmd = "build.bat"
endif

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

	put=a:data
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

	if has ("win32")
		new 
		setlocal buftype=nofile noswapfile
		let s:compile_job = jobstart([g:project_dir . g:project_compile_cmd], s:compile_callbacks)
	else
		let s:compile_job = jobstart(['bash'], s:compile_callbacks)

		call jobsend(s:compile_job, g:project_dir . g:project_compile_cmd ."\n")
		call jobsend(s:compile_job, "exit\n")b
	endif
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

"" compilation
map <leader>c :Compile <CR>
map <leader>n :CompileNextError <CR>
map <leader>p :CompilePrevError <CR>


"" NERDCommenter 
nmap <leader>/ :call NERDComment('n', 'Toggle') <CR>
xmap <leader>/ :call NERDComment('x', 'Toggle') <CR>


"" window navigation keybinds
" vertical and horizontal split keybinds
map <C-s> :vsplit <CR> :wincmd l <CR>
map <A-s> :split <CR> :wincmd j <CR>


"" fuzzy file and buffer find configuration
set wildignore+=*.o
set wildignore+=*/tmp/*,*.so,*.swp,*.a
set wildignore+=*\\tmp\\*,*.obj,*.swp,*.exe,*.lib,*.dll

let g:ctrlp_map = ''

if has("win32")
	let g:ctrlp_max_files = 0

	map <C-a> :CtrlP <CR> 
	map <C-p> :CtrlP <C-r>=g:project_dir<CR><CR>
else
	"map <C-p> :call denite#start([{'name': 'file_rec', 'args': [g:project_dir]}]) <CR>

	function! s:project_dir()
		return g:project_dir
	endfunction

	function! s:buflist()
		redir => ls
		silent ls
		redir END
		return split(ls, '\n')
	endfunction

	function! s:bufopen(e)
		execute 'buffer' matchstr(a:e, '^[ 0-9]*')
	endfunction

	map <C-p> :call fzf#run({
	\   'dir': <sid>project_dir(), 
	\	'sink': 'e'
	\	})<CR>

	map <A-p> :call fzf#run({
	\   'source':  reverse(<sid>buflist()),
	\   'sink':    function('<sid>bufopen'),
	\   'options': '+m',
	\   'down':    len(<sid>buflist()) + 2
	\ })<CR>


endif


"" source/header file switching
map <F4> :FSHere <CR>

