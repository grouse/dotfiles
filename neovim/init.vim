call plug#begin("~/.config/nvim/plugged")

Plug 'vim-scripts/Smart-Tabs'

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

colorscheme wombat256

"" custom variables
let g:project_dir         = "~/projects"
let g:project_compile_cmd = "~/projects/build.sh"

"" custom functions
function! s:OpenProjectFunc(path)
	let g:project_dir         = a:path
	let g:project_compile_cmd = g:project_dir . "/build.sh"
endfunction

"" custom commands
command! -nargs=1 -complete=dir OpenProject call s:OpenProjectFunc(<f-args>)

"" compilation
let s:compile_output = 0
let s:compile_job    = -1 

function! s:compile_on_output(job_id, data, event)
	if s:compile_output
		let old_window         = winnr()
		let compilation_window = bufwinnr("compilation")

		if compilation_window == -1
			" NOTE: trying to create a compilation buffer/window here incurs a race condition
		endif

		" NOTE: this causes us to actually switch windows, append to buffer, switch back. Not only 
		" does this send "on-window-change" type events inside vim, it's a horrifically slow 
		" implementation.  
		" TODO: investigate solution to append to buffer by name/index without having to switch to 
		" it
		exe compilation_window . "wincmd w"
		call append(line('$'), a:data)
		exe old_window . "wincmd w"
	endif

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
	if s:compile_output
		" TODO: create compilation window + buffer if not created. This needs to be done here so 
		" that compile_on_output can assume the existance of a compilation buffer
	endif

	if s:compile_job != -1 
		echo "compilation job already in progress"
		return
	endif

	call setqflist([])

	let s:compile_job = jobstart(['bash'], s:compile_callbacks)

	call jobsend(s:compile_job, g:project_compile_cmd . "\n")
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

" the h at the end is a complete hack to stop the cursor from moving a character to the right, I 
" assume this is caused by some weird clash remapping 'c'?
"map <leader>cc :Neomake! custom <CR>
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

