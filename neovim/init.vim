"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   /\        |\
"  /|\\       ||\                                  _
"  ||\\\      |||                                  `'
"  |||\\\     |||   .;;;;;;.   .;;;;;;. ;.      .; .; , .,.  .,.
"  ||| \\\    |||  /;      :  .;      :. \\    //  || ||; '|/' '|,
"  |||  \\\   |||  ||======'  |;      ;|  \\  //   || ||   ||   ||
"  |||   \\\  |||  |;     ,;  ';      :'   \`;/    || ||   ||   ||
"  |||    \\\ |||   `'===='    `'===='`     \/     || ||   ||   ||
"  |||     \\\||/
"  \||      \\\/
"   \|       \/
"
"            Jesper Stefansson (jesper.stefansson@gmail.com)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin("~/.config/nvim/plugged")
	"" assorted plugins
	Plug 'kshenoy/vim-signature'
	Plug 'tpope/vim-speeddating'
	Plug 'bkad/CamelCaseMotion'

	"" tool plugins
	Plug 'critiqjo/lldb.nvim'
	Plug 'tpope/vim-fugitive'
	Plug 'mileszs/ack.vim'

	"" navigation related plugins
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'derekwyatt/vim-fswitch'
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

	"" editing related plugins
	Plug 'vim-scripts/Smart-Tabs'
	Plug 'junegunn/vim-easy-align'
	Plug 'ntpeters/vim-better-whitespace'

	"" ui/look and feel related plugins
	Plug 'equalsraf/neovim-gui-shim'
	Plug 'vim-airline/vim-airline'
	Plug 'machakann/vim-highlightedyank'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Appearance
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" disable line numbers by default, use <F2> to toggle
set norelativenumber nonumber

set ruler
set noshowmode
set cursorline
set termguicolors

let &colorcolumn="80,".join(range(100,280),",")

set background=dark
colorscheme grouse

" use line cursor in insert mode
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Core behaviour
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup nowritebackup noswapfile autoread
set hidden " Allow buffer switching without saving

" enable inccommand for incremental substitute, nvim you glorious bastard
set inccommand=split

" make splits open below/to the right of the current buffer
set splitbelow splitright

" let terminal resize scale the internal windows
autocmd VimResized * :wincmd =

" cache undo history to file so that it's possible to undo after reopening a
" recently closed file
set undofile undodir=$HOME/.cache/nvim/undo
set undolevels=1000 undoreload=10000

"" scrolling configuration
set scrolloff=5 sidescrolloff=5

"" incremental search configuration
set gdefault ignorecase smartcase

set wildignore+=*.o
set wildignore+=*/tmp/*,*.so,*.swp,*.a
set wildignore+=*\\tmp\\*,*.obj,*.swp,*.exe,*.lib,*.dll

"" errorformats
"gcc/clang
set errorformat=%f:%l:%c:\ %trror:\ %m
set errorformat+=%f:%l:%c:\ fatal\ %trror:\ %m
set errorformat+=%f:%l:%c:\ %tarning:\ %m
set errorformat+=%f:%l:\ %m

"msvc
set errorformat+=%f(%l):\ %trror\ %m
set errorformat+=%f(%l):\ %tarning\ %m
set errorformat+=%f(%l)\ :\ %tarning\ %m


" Automatically cd to the directory of the opened file
autocmd BufEnter * silent! lcd %:p:h

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Editing/Formatting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
set list listchars=tab:⤚⎼
set textwidth=80

"" indentation & alignment
set cinoptions=(0  " align continuation lines with next non-whitespace character
                   " after the unclosed parenthesis
set cinoptions+=u0 " same as ( but one level deeper
set cinoptions+=U0 " ignore indent specified by ( and u
set cinoptions+=:0 " place case labels on same level as the switch
set cinoptions+=l1 " align new lines to case label instead of following statement
set cinoptions+=g0 " align C++ class member visibility label with class statement

set cindent
set nosmarttab     " make BS behave like a normal backspace when deleting spaces

set copyindent noexpandtab preserveindent
set shiftwidth=4 softtabstop=0 tabstop=4

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Core keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader="\<Space>"

" override the keybinding for ex mode. maybe one day I'll find a use for it, but
" for now it's amazingly annoying to hit accidentally
nmap Q q

" toggle line numbers
nmap <silent> <F2> :windo set relativenumber!<CR>
imap <silent> <F2> <ESC>:windo set relativenumber!<CR>a

map <silent> <leader>n :cnext<CR>
map <silent> <leader>p :cprev<CR>

" let capital Y copy from cursor to end of line, instead of entire line
map Y y$
map ; :

" reselect visual block after indenting
vnoremap < <gv
vnoremap > >gv

" center view around cursor when moving to next/previous match in search
nnoremap <silent> n nzz
nnoremap <silent> N Nzz

" center view around cursor when moving up/down with C-u etc
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
nnoremap <C-f> <C-f>zz
nnoremap <C-b> <C-b>zz
vnoremap <C-u> <C-u>zz
vnoremap <C-d> <C-d>zz
vnoremap <C-f> <C-f>zz
vnoremap <C-b> <C-b>zz

" insert today's date into the buffer in the common different formats
nmap <silent> <leader>yt  a<C-R>=strftime("%Y-%m-%d %T")<CR><ESC>
nmap <silent> <leader>ymd a<C-R>=strftime("%Y-%m-%d")<CR><ESC>
nmap <silent> <leader>hms a<C-R>=strftime("%T")<CR><ESC>

" clear the search highlight when pressing enter
nnoremap <silent> <CR> :nohlsearch<CR>

" start a subsitute search for the word under the cursor
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" vertical and horizontal split keybinds
map <silent> <C-s> :vsplit <CR>
map <silent> <A-s> :split <CR>

" move cursor to window left/right/down/up
map sh <C-w>h
map sl <C-w>l
map sj <C-w>j
map sk <C-w>k

" move window to split left/right/down/up
map Sh <C-w>H
map Sl <C-w>L
map Sj <C-w>J
map Sk <C-w>K

" tab keybinds
map <silent> <C-t> :tabnew<CR>
map <silent> <C-q> :tabclose<CR>
map <silent> <A-1> 1gt
map <silent> <A-2> 2gt
map <silent> <A-3> 3gt
map <silent> <A-4> 4gt
map <silent> <A-5> 5gt
map <silent> <A-6> 6gt
map <silent> <A-7> 7gt
map <silent> <A-8> 8gt
map <silent> <A-9> 9gt

" buffer keybinds
map <silent> <A-j> :bprevious<CR>
map <silent> <A-k> :bnext<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ack.vim
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

"" vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled = 1

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_theme = "grouse"

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod  = ":t"

let g:airline_section_c = airline#section#create(["file"])

let g:airline_section_y = airline#section#create(["ffenc"])
let g:airline_section_z = airline#section#create(["%l:%v"])
let g:airline_section_error   = ""
let g:airline_section_warning = ""


"" highlighted yank
let g:highlightedyank_highlight_duration=350


"" CamelCaseMotion
" NOTE(jesper): put behind leader keybinds for now because the word motion
" isn't 100% accurate to the usual vim behaviour (in non-camelcase/underscore
" motions) which is throwing me off a lot
map <silent> <leader>w <Plug>CamelCaseMotion_w
map <silent> <leader>b <Plug>CamelCaseMotion_b
map <silent> <leader>e <Plug>CamelCaseMotion_e
map <silent> <leader>ge <Plug>CamelCaseMotion_ge

omap <silent> <leader>iw <Plug>CamelCaseMotion_iw
omap <silent> <leader>ib <Plug>CamelCaseMotion_ib
omap <silent> <leader>ie <Plug>CamelCaseMotion_ie

xmap <silent> <leader>iw <Plug>CamelCaseMotion_iw
xmap <silent> <leader>ib <Plug>CamelCaseMotion_ib
xmap <silent> <leader>ie <Plug>CamelCaseMotion_ie


"" Fuzzy file searching
" disable default mappings
let g:ctrlp_map = ''

if has("win32")
let g:ctrlp_map = ''
	let g:ctrlp_max_files = 0

	map <C-a> :CtrlP <CR>
	map <C-p> :CtrlP <C-r>=t:project_dir<CR><CR>
else
	function! s:project_dir()
		return t:project_dir
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


"" FSwitch
map <silent> <F4><F4> :FSHere<CR>
map <silent> <F4>j :FSBelow<CR>
map <silent> <F4>k :FSAbove<CR>
map <silent> <F4>l :FSRight<CR>
map <silent> <F4>h :FSLeft<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Extended behaviour
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction


" restore the cursor position when opening a file
function! s:restore_cursor_position()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction
au BufReadPost * call s:restore_cursor_position()

" in git commit message windows, put the cursor at the start
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])


" handmade way of making my preferred indentation style for switch cases work
" NOTE(jesper): this was a lot easier and cleaner than I thought it'd be, might
" be interesting to look into similar solutions for automatic code formatting
function! Indent(line_num)
	let l:indent = cindent(a:line_num)

	if a:line_num == 0
		return l:indent
	endif

	let l:prev_line = split(getline(a:line_num - 1), " ")[0]

	let l:prev_line = substitute(l:prev_line, '\s*', '', "M")
	let l:prev_line = substitute(l:prev_line, '\s+$', '', "M")

	if l:prev_line ==# "case"
		let l:line  = split(getline(a:line_num), " ")[0]

		let l:line = substitute(l:line, '\s*', '', "M")
		let l:line = substitute(l:line, '\s+$', '', "M")

		if l:line ==# "{"
			let l:indent = cindent(a:line_num - 1)
		endif
	endif

	return l:indent
endfunction
set indentexpr=Indent(line(\".\"))


" create a horizontal scratch buffer with 5 lines height
function! s:create_scratch_buffer()
	new | resize 5
	setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
endfunction
command! Scratch :call s:create_scratch_buffer()


"" custom highlights
" NOTE(jesper): should probably do this by overriding syntax linter files, but
" this seems the cleanest way of getting global highlights without having to
" edit syntax files for every single file type i'm interested in
function! SetCustomHighlights()
	syn keyword Note contained NOTE
	syn keyword Note contained NOTE:

	syn keyword Todo contained TODO  FIXME  IMPORTANT  HACK
	syn keyword Todo contained TODO: FIXME: IMPORTANT: HACK:

	syn cluster cCommentGroup contains=Note,Todo
	syn cluster vimCommentGroup contains=Note,Todo
endfunction()
au BufRead,BufNewFile * call SetCustomHighlights()


"" template insertion and formatting"
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

	let cmd = 'ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ' . t:project_dir
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


"" Project configuration
let t:project_dir = getcwd()

function! s:OpenProjectFunc(path)
	let t:project_dir = a:path
	let t:compile_cmd_cache = t:project_dir . '/' . t:compile_script
endfunction
command! -nargs=1 -complete=dir OpenProject call s:OpenProjectFunc(<f-args>)

"" Project compilation
let t:compile_job        = -1
let t:compile_script     = 'build.sh'

if has('win32')
	let t:compile_script = 'build.bat'
endif

let t:compile_cmd_cache = t:project_dir . '/' . t:compile_script

function! s:compile_on_output(job_id, data, event)
	cadde a:data
endfunction

function! s:compile_on_exit(job_id, data, event)
	let t:compile_job = -1
	" TODO(jesper): currently this throws a multiline error if the quickfix list
	" doesn't contain any valid errors. It's an obvious enough notification, but
	" should really fix it
	cnext
endfunction

function! s:compile_start(cmd)
	if t:compile_job != -1
		echo "compilation job already in progress"
		return
	endif

	call setqflist([])

	let t:compile_cmd_cache = a:cmd

	let compile_opts = {
		\'on_stdout': function('s:compile_on_output'),
		\'on_stderr': function('s:compile_on_output'),
		\'on_exit'  : function('s:compile_on_exit'),
		\'opts'     : 1
	\}

	let t:compile_job = jobstart(a:cmd, compile_opts)
endfunction

function! s:compile_cancel()
	if t:compile_job != -1
		jobstop(t:compile_job)
		t:compile_job = -1
	endif
endfunction

command! -nargs=1 Compile :call s:compile_start(<f-args>)
command! CompileCancel    :call s:compile_cancel()

map <leader>c :Compile <C-r>=t:compile_cmd_cache<CR>


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


" NOTE(jesper): HACK: when creating a new tab it seems the tab scoped variables
" defined in this init.vim script aren't initialised for the new tab, so we
" need to it ourselves
let g:creating_tab = 0

function! s:create_tab()
	let g:creating_tab = 1
endfunction

function! s:enter_tab()
	if g:creating_tab == 1
		let g:creating_tab = 0

		let t:project_dir = getcwd()

		let t:compile_job    = -1
		let t:compile_script = 'build.sh'

		if has('win32')
			let t:compile_script = 'build.bat'
		endif

		let t:compile_cmd_cache = t:project_dir . '/' . t:compile_script
	endif
endfunction

au TabNew *   :call s:create_tab()
au TabEnter * :call s:enter_tab()

