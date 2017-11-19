"==============================================================================
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
"==============================================================================
"= Table of Contents
"==============================================================================
"  a) Plugins
"  b) Appearance
"  c) Core behaviour
"  d) Editing/Formatting
"  e) Core keybindings
"  f) Plugin configuration
"  g) Extended behaviour
"  h) Autocmd groups
"
"==============================================================================
"= a) Plugins
"==============================================================================
call plug#begin("~/.config/nvim/plugged")
    "" assorted plugins
    Plug 'kshenoy/vim-signature'
    Plug 'tpope/vim-speeddating'
    Plug 'bkad/CamelCaseMotion'

    "" tool plugins
    Plug 'critiqjo/lldb.nvim'
    Plug 'tpope/vim-fugitive'

    "" navigation related plugins
    Plug 'derekwyatt/vim-fswitch'
if has("win32")
    Plug 'ctrlpvim/ctrlp.vim'
else
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
endif

    "" editing related plugins
    Plug 'vim-scripts/Smart-Tabs'
    Plug 'junegunn/vim-easy-align'
    Plug 'ntpeters/vim-better-whitespace'

    "" ui/look and feel related plugins
    Plug 'equalsraf/neovim-gui-shim'
    Plug 'vim-airline/vim-airline'
    Plug 'machakann/vim-highlightedyank'
call plug#end()

source ~/.config/nvim/local.vim

if !exists("strip_whitespace_on_save")
    let strip_whitespace_on_save = 1
endif

if !exists("spaces_for_tabs")
    let spaces_for_tabs = 0
endif

"==============================================================================
"= b) Appearance
"==============================================================================
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

"==============================================================================
"= c) Core behaviour
"==============================================================================
set nobackup nowritebackup noswapfile autoread
set hidden " Allow buffer switching without saving

set mouse=a " why do I only need to enable this on my arch machien!??!?!?


" enable inccommand for incremental substitute, nvim you glorious bastard
set inccommand=split

" make splits open below/to the right of the current buffer
set splitbelow splitright

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
if has("win32")
    " msvc
    set errorformat=%f(%l):\ %trror\ %m
    set errorformat+=%f(%l):\ %tarning\ %m
    set errorformat+=%f(%l)\ :\ %tarning\ %m
else
    " gcc/clang
    set errorformat=%f:%l:%c:\ %trror:%m
    set errorformat+=%f:%l:%c:\ fatal\ %trror:%m
    set errorformat+=%f:%l:%c:\ %tarning:%m
    set errorformat+=%f:%l:%m
endif


"==============================================================================
"= d) Editing/Formatting
"==============================================================================
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

set copyindent preserveindent
set shiftwidth=4 softtabstop=0 tabstop=4

if spaces_for_tabs == 1
    set expandtab
else
    set noexpandtab
endif

"==============================================================================
"= e) Core keybindings
"==============================================================================
let mapleader="\<Space>"

" override the keybinding for ex mode. maybe one day I'll find a use for it, but
" for now it's amazingly annoying to hit accidentally
nmap Q q

" toggle line numbers
nmap <silent> <F2> :windo set relativenumber!<CR>
imap <silent> <F2> <ESC>:windo set relativenumber!<CR>a

" quickfix list navigation
map <silent> <C-j> :cnext<CR>
map <silent> <C-k> :cprev<CR>

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

"==============================================================================
"= f) Plugin configuration
"==============================================================================
"" vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)


"" vim-airline
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


"" vim-highlightedyank
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


"" ctrlp.vim | fzf
" disable default mappings
let g:ctrlp_map = ''

if has("win32")
    let g:ctrlp_max_files = 0

    map <C-a> :CtrlP <CR>
    map <C-p> :CtrlP <C-r>=t:project_dir<CR><CR>
else
    " change the fzf command to follow symlinks (-L)
    let $FZF_DEFAULT_COMMAND="find -L * -path '*/\.*' -prune -o -type f -print -o -type l -print 2> /dev/null"

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
    \   'sink': 'e',
    \   'down': '30%'
    \ })<CR>

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

"==============================================================================
"= g) Extended behaviour
"==============================================================================
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
function! s:custom_syntax()
    syn keyword Note contained NOTE
    syn keyword Note contained NOTE:

    syn keyword Todo contained TODO  FIXME  IMPORTANT  HACK
    syn keyword Todo contained TODO: FIXME: IMPORTANT: HACK:

    syn cluster cCommentGroup contains=Note,Todo
    syn cluster vimCommentGroup contains=Note,Todo
endfunction()


"" template insertion and formatting"
function! s:format_template(template)
    let l:file = '~/.config/nvim/templates/'.a:template
    silent execute "0read ".fnameescape(l:file)

    let author    = 'Jesper Stefansson'
    let email     = 'jesper.stefansson@gmail.com'

    silent exec '%s/@FILE/' . expand('%:t')
    silent exec '%s/@CREATED/' . strftime('%Y-%m-%d')
    silent exec '%s/@AUTHORS/' . author . ' (' . email . ')'
    silent exec '%s/@COPYRIGHT_YEAR/' . strftime('%Y')

    silent exec '%s/@HEADER_DEFINE_GUARD/' . toupper(expand('%:r')) . '_H'

    " NOTE(jesper): by doing this substitute last we move the cursor to this position
    silent exec '%s/@CURSOR//'
endfunction()


"" Project configuration
function! s:OpenProjectFunc(path)
    let t:project_dir = a:path
    let t:compile_cmd_cache = t:project_dir . '/' . t:compile_script
endfunction
command! -nargs=1 -complete=dir OpenProject call s:OpenProjectFunc(<f-args>)


"" Project searching
let g:project_search_job = -1
let g:project_search_goto_first = 0

function! s:project_search_on_output(job_id, data, event)
    cadde a:data
    redraw!

    if g:project_search_goto_first == 1
        execute "cc"
        let g:project_search_goto_first = 0
    endif
endfunction

function! s:project_search_on_exit(job_id, data, event)
    let g:project_search_job = -1
endfunction

function! s:project_search(term, folder)
    if g:project_search_job != -1
        echo "project search in progress"
        return
    endif

    call setqflist([])

    let search_opts = {
        \'on_stdout': function('s:project_search_on_output'),
        \'on_stderr': function('s:project_search_on_output'),
        \'on_exit'  : function('s:project_search_on_exit')
    \}

    let g:project_search_goto_first = 1
    let g:project_search_job = jobstart('ag --vimgrep -s "'.a:term.'" '.a:folder, search_opts)

    execute "botright copen"
endfunction

function! s:project_search_cancel()
    if g:project_search_job != -1
        jobstop(g:project_search_job)
        g:project_search_job = -1
    endif
endfunction

command! SearchCancel :call s:project_search_cancel()
command! -nargs=1 Search :call s:project_search(<q-args>, t:project_dir)
command! -nargs=1 SearchCWD :call s:project_search(<q-args>, getcwd())


"" Project compilation
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

function! s:set_comment_characters(cline)
    let b:comment_line = a:cline
endfunction

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
        else
            echo "can't comment current filetype"
        endif
    endif

    let &selection = selection_save
    let @@         = register_save
endfunction

nmap <silent> <A-/> :<C-U>set opfunc=<SID>insert_comment<Bar>exe 'norm! 'v:count1.'g@_'<CR>
vmap <silent> <A-/>  :<C-U>call <SID>insert_comment(visualmode(), 1)<CR>


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
function! s:init_tab_variables_pre()
    let g:creating_tab = 1
endfunction

function! s:init_tab_variables()
    if g:creating_tab == 1
        let t:project_dir    = getcwd()
        let t:compile_job    = -1
        let t:compile_script = 'build.sh'

        if has('win32')
            let t:compile_script = 'build.bat'
        endif

        let t:compile_cmd_cache = t:project_dir . '/' . t:compile_script

        let g:creating_tab = 0
    endif
endfunction

"==============================================================================
"= h) Autocmd groups
"==============================================================================
augroup syntax-highlight
    autocmd BufNewFile,BufRead *.glsl set filetype=glsl
augroup end

augroup vim-on-save
    autocmd!

    if strip_whitespace_on_save == 1
        autocmd BufWritePre * :StripWhitespace
    endif
augroup end

augroup init-tab-variables
    autocmd!
    autocmd VimEnter,TabNew   * :call s:init_tab_variables_pre()
    autocmd VimEnter,TabEnter * :call s:init_tab_variables()
augroup end

augroup vim-resize-windows
    autocmd!
    autocmd VimResized * :wincmd =
augroup end

augroup restore-cursor-pos
    autocmd!
    autocmd BufReadPost * call s:restore_cursor_position()
    autocmd FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
augroup end

augroup custom-highlights
    autocmd!
    autocmd BufRead,BufNewFile * call s:custom_syntax()
augroup end

augroup auto-file-templates
    autocmd!
    autocmd BufNewFile *.c,*.cpp call s:format_template('c.vim')
    autocmd BufNewFile *.h,*.hpp call s:format_template('h.vim')
augroup end

augroup filetype-comment-style
    autocmd!
    autocmd FileType vim    call s:set_comment_characters('" ')

    autocmd FileType c      call s:set_comment_characters('\/\/')
    autocmd FileType cpp    call s:set_comment_characters('\/\/')
    autocmd FileType objcpp call s:set_comment_characters('\/\/')
augroup end

