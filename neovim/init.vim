call plug#begin("~/.config/nvim/plugged")
	"" assorted plugins
	Plug 'kshenoy/vim-signature'
	Plug 'jiangmiao/auto-pairs'

	"" tool plugins
	Plug 'critiqjo/lldb.nvim'
	Plug 'tpope/vim-fugitive'

	"" navigation related plugins
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'derekwyatt/vim-fswitch'
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

	"" editing related plugins
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

let mapleader="\<Space>"

set list
set listchars=eol:⏎,tab:⤚⎼


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
set errorformat+="%f:%l:%c: error: %m"  " gcc
set errorformat+="%f(%l): error %#: %m" " msvc


"" color scheme and syntax highlight configuration
syntax enable
set termguicolors
set cursorline
set background=dark

colorscheme grouse

"" utility functions
function! s:warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

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


function! s:format_template()
	let author    = 'Jesper Stefansson'
	let email     = 'jesper.stefansson@gmail.com'

	exec '%s/@FILE/' . expand('%:t')
	exec '%s/@CREATED/' . strftime('%Y-%m-%d')
	exec '%s/@AUTHORS/' . author . ' (' . email . ')'
	exec '%s/@COPYRIGHT_YEAR/' . strftime('%Y')

	exec '%s/@HEADER_DEFINE_GUARD/' . toupper(expand('%:r')) . '_H'

	" NOTE(jesper): by doing this substitute last we move the cursor to this position
	exec '%s/@CURSOR//'
endfunction()

au BufNewFile *.c,*.cpp 0r ~/.config/nvim/templates/template.c
au BufNewFile *.h,*.hpp 0r ~/.config/nvim/templates/template.h

au BufNewFile *.c,*.h,*.cpp,*.hpp call s:format_template()


"" ctags configuration
let s:ctags_generate_job = -1


function! s:ctags_generate_on_output(job_id, data, event)
	echo a:data
endfunction()

function! s:ctags_generate_on_exit(job_id, data, event)
	let s:ctags_generate_job = -1
	if (a:data == 0)
		echo "ctags generated"
	else
		echo "ERROR: ctags not generated")
	endif
endfunction

function! s:ctags_generate()
	if s:ctags_generate_job != -1
		echo 'ctags are already being generated'
		return
	endif

	let cmd = 'ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ' . g:project_dir
	let ctags_generate_options= {
		\'on_stdout': function('s:ctags_generate_on_output'),
		\'on_stderr': function('s:ctags_generate_on_output'),
		\'on_exit'  : function('s:ctags_generate_on_exit'),
		\'detach'   : 1
	\}

	let s:ctags_generate_job = jobstart(cmd, ctags_generate_options)
endfunction

function! s:ctags_generate_cancel()
	if s:ctags_generate_job != -1
		jobstop(s:ctags_generate_job)
	endif
endfunction
		

command! GenerateCTags :call s:ctags_generate()
command! CancelCTagsJob :call s:ctags_generate_cancel()
	
"" airline configuration
let g:airline_powerline_fonts = 1

let g:airline#extensions#branch#enabled = 1

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_theme = "grouse"

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod  = ":t"

let g:airline_section_c = airline#section#create(["file"])

let g:airline_section_y = airline#section#create(["ffenc"])
let g:airline_section_z = airline#section#create(["%l:%c"])
let g:airline_section_error   = ""
let g:airline_section_warning = "" 


"" highlighted yank configuration
let g:highlightedyank_highlight_duration=300

"" custom variables
let g:project_dir         = "./"

"" custom functions
function! s:OpenProjectFunc(path)
	let g:project_dir         = a:path
endfunction


"" custom commands
command! -nargs=1 -complete=dir OpenProject call s:OpenProjectFunc(<f-args>)


"" compilation
let s:compile_job        = -1 

let s:compile_script     = 'build.sh'
if has('win32')
	let s:compile_script = 'build.bat'
endif

let g:compile_cmd_cache  = g:project_dir . '/' . s:compile_script . ' debug'

function! s:compile_on_output(job_id, data, event)
	" TODO(jesper): consider adding this to a no-file scratch buffer so we can easily view the
	" entire compilation output, but need to figure out how to add text to a buffer without having
	" to constantly switch back and forth, considering the async nature of this command.
	" NOTE(jesper): we can just open up the quickfix list, but I'd like to consider filtering the
	" additions to the quickfix list so that only contains the locations for warnings and errors
	" without any of the other compilation output
	cadde a:data
endfunction

function! s:compile_on_exit(job_id, data, event)
	let s:compile_job = -1
	call s:compile_next_error()
endfunction

function! s:compile_start(cmd)
	if s:compile_job != -1 
		echo "compilation job already in progress"
		return
	endif

	call setqflist([])

	let g:compile_cmd_cache = a:cmd

	let compile_opts = {
		\'on_stdout': function('s:compile_on_output'),
		\'on_stderr': function('s:compile_on_output'),
		\'on_exit'  : function('s:compile_on_exit'),
		\'opts'     : 1
	\}

	let s:compile_job = jobstart(a:cmd, compile_opts)
endfunction

function! s:compile_cancel()
	if s:compile_job != -1
		jobstop(s:compile_job)
		s:compile_job = -1
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

command! -nargs=1 Compile :call s:compile_start(<f-args>)
command! CompileCancel    :call s:compile_cancel()
command! CompileNextError :call s:compile_next_error()
command! CompilePrevError :call s:compile_prev_error()

map <leader>c :Compile <C-r>=g:compile_cmd_cache<CR>
map <leader>n :CompileNextError <CR>
map <leader>p :CompilePrevError <CR>

"" assorted keybinds
:nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

"" code commenting functions and motions
let b:comment_line = '\/\/'
let b:comment_selection_start = '\/*'
let b:comment_selection_end   = '*\/'

function! s:set_comment_characters(line, start, end)
	let b:comment_line = a:line
	let b:comment_selection_start = a:start
	let b:comment_selection_end = a:end
endfunction

au FileType vim call s:set_comment_characters('" ', '', '')
au FileType cpp call s:set_comment_characters('\/\/', '\/*', '*\/')

function! s:insert_comment_line(line_num, line)
	if match(a:line, '\s*'.b:comment_line.'.*') == -1
		let line = substitute(a:line, '\(\s*\)\(.*\)', '\1'.b:comment_line.'\2', "M")
		call setline(a:line_num, line)
	endif
endfunction

function! s:remove_comment_line(line_num, line)
	if match(a:line, '\s*'.b:comment_line.'.*') != -1
		let line = substitute(a:line, '\(\s*\)'.b:comment_line.'\(.*\)', '\1\2', "M")
		call setline(a:line_num, line)
	endif
endfunction

function! s:insert_comment_selection(start, end, line_num)
	let line = getline(a:line_num)

	if line == ''
		return
	endif

	let [num_left, num_middle, num_right] = [a:start, a:end - a:start, len(line) - a:end]
	let line = substitute(line, 
				\'\(.\{'.num_left.'}\)\(.\{'.num_middle.'}\)\(.\{'.num_right.'}\)', 
				\'\1'.b:comment_selection_start.' \2 '.b:comment_selection_end.'\3', "M")

	call setline(a:line_num, line)
endfunction

function! s:insert_comment(type, ...)
	let selection_save = &selection
	let register_save  = @@

	let &selection = "inclusive"

	" TODO(jesper): want to look into making the comment_line be column aligned when several lines
	" are commented out
	if a:0 || a:type == 'line'
		if a:0
			let [line_start, line_end] = [getpos("'<")[1], getpos("'>")[1]]
		else
			let [line_start, line_end] = [line("'['"), line("']")]
		endif


		if b:comment_line != '' 
			let start_line = getline(line_start)

			let uncomment = 0
			if match(start_line, '\s*'.b:comment_line.'.*') != -1
				let uncomment = 1
			endif

			for line_num in range(line_start, line_end)
				let line = getline(line_num)

				if line == ''
					continue
				endif

				if uncomment == 1
					call s:remove_comment_line(line_num, line)
				else
					call s:insert_comment_line(line_num, line)
				endif
			endfor
		elseif b:comment_selection_start != ''
			echo "not currently supported"
		else
			echo "can't comment current filetype"
		endif
	else 
		if b:comment_selection_start != '' 
			call s:insert_comment_selection((getpos("'[")[2] - 1), (getpos("']")[2] + 1), line("'["))
		elseif b:comment_line != ''
			call s:insert_comment_line(line("'["))
		else
			echo "can't comment current filetype"
		endif
	endif

	let &selection = selection_save
	let @@         = register_save
endfunction

" NOTE(jesper): probably not the best keybinds for this, but it'll do for now
nmap <silent> <leader>/ :<C-U>set opfunc=<SID>insert_comment<CR>g@
nmap <silent> <leader>// :<C-U>set opfunc=<SID>insert_comment<Bar>exe 'norm! 'v:count1.'g@_'<CR>
vmap <silent> <leader>/  :<C-U>call <SID>insert_comment(visualmode(), 1)<CR>

"" buffer management configuration
" close the current buffer and keep the window layout
" http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window
function! s:Bclose(bang, buffer)
  if empty(a:buffer)
    let btarget = bufnr('%')
  elseif a:buffer =~ '^\d\+$'
    let btarget = bufnr(str2nr(a:buffer))
  else
    let btarget = bufnr(a:buffer)
  endif
  if btarget < 0
    call s:warn('No matching buffer for '.a:buffer)
    return
  endif
  if empty(a:bang) && getbufvar(btarget, '&modified')
    call s:warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
    return
  endif
  " Numbers of windows that view target buffer which we will delete.
  let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
  let wcurrent = winnr()
  for w in wnums
    execute w.'wincmd w'
    let prevbuf = bufnr('#')
    if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
      buffer #
    else
      bprevious
    endif
    if btarget == bufnr('%')
      " Numbers of listed buffers which are not the target to be deleted.
      let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
      " Listed, not target, and not displayed.
      let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
      " Take the first buffer, if any (could be more intelligent).
      let bjump = (bhidden + blisted + [-1])[0]
      if bjump > 0
        execute 'buffer '.bjump
      else
        execute 'enew'.a:bang
      endif
    endif
  endfor
  execute 'bdelete'.a:bang.' '.btarget
  execute wcurrent.'wincmd w'
endfunction

command! -bang -complete=buffer -nargs=? Bclose call s:Bclose('<bang>', '<args>')
map <leader>bc :Bclose<CR>


"" window navigation keybinds
" vertical and horizontal split keybinds
map <C-s> :vsplit <CR> :wincmd l <CR>
map <A-s> :split <CR> :wincmd j <CR>


"" fuzzy file and buffer find configuration
set wildignore+=*.o
set wildignore+=*/tmp/*,*.so,*.swp,*.a
set wildignore+=*\\tmp\\*,*.obj,*.swp,*.exe,*.lib,*.dll

" disable default mappings
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

