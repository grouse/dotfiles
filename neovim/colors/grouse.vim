" initialisation
if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif

hi clear
syntax reset

let g:colors_name='grouse'

" setup emphasis
let s:none      = 'NONE'

let s:bold      = 'bold'
let s:italic    = 'italic'
let s:underline = 'underline'
let s:undercurl = 'undercurl'
let s:inverse   = 'inverse'

"" colour palette
let s:base00 = '#2a282a' " darker background
let s:base01 = '#2a282a' " normal background
let s:base02 = '#2a282a' " lighter background

let s:base03 = '#6e6d6e' " accent foreground 00
let s:base04 = '#948068' " accent foreground 01
let s:base05 = '#aeaa95' " normal foreground
let s:base06 = '#a08526' " accent foreground 10
let s:base07 = '#f7fffe' " accent foreground 11

" accents
let s:red     = '#EC5f67' 
let s:orange  = '#F99157'
let s:yellow  = '#c3cd3b'
let s:green   = '#7dba6d'

function! s:hl(group, fg, bg, attr)
	exec "hi " . a:group . " guifg=" . a:fg . " guibg=" . a:bg . " gui=" . a:attr
	exec "hi " . a:group . " ctermfg=none ctermbg=none cterm=none"
endfunction

"" editor colors 
call s:hl("CursorLine",   s:none, s:base02, s:none)
call s:hl("CursorLineNr", s:none, s:none, s:none)
call s:hl("LineNr",       s:base03, s:base00, s:none)
call s:hl("VertSplit",    s:base00, s:base00, s:none)
call s:hl("Visual",       s:none, s:none, s:inverse)
call s:hl("VisualNOS",    s:none, s:none, s:inverse)
call s:hl("Normal",       s:base05, s:base01, s:none)

" unset
call s:hl("ColorColumn",  s:none, s:none, s:none)
call s:hl("Bold",         s:none, s:none, s:none)
call s:hl("Debug",        s:none, s:none, s:none)
call s:hl("Directory",    s:none, s:none, s:none)
call s:hl("ErrorMsg",     s:none, s:none, s:none)
call s:hl("Exception",    s:none, s:none, s:none)
call s:hl("FoldColumn",   s:none, s:none, s:none)
call s:hl("Folded",       s:none, s:none, s:none)
call s:hl("IncSearch",    s:none, s:none, s:none)
call s:hl("Italic",       s:none, s:none, s:none)
call s:hl("Macro",        s:none, s:none, s:none)
call s:hl("MatchParen",   s:none, s:none, s:none)
call s:hl("ModeMsg",      s:none, s:none, s:none)
call s:hl("MoreMsg",      s:none, s:none, s:none)
call s:hl("Question",     s:none, s:none, s:none)
call s:hl("Search",       s:none, s:none, s:none)
call s:hl("SpecialKey",   s:none, s:none, s:none)
call s:hl("TooLong",      s:none, s:none, s:none)
call s:hl("Underlined",   s:none, s:none, s:none)
call s:hl("WarningMsg",   s:none, s:none, s:none)
call s:hl("WildMenu",     s:none, s:none, s:none)
call s:hl("Title",        s:none, s:none, s:none)
call s:hl("Conceal",      s:none, s:none, s:none)
call s:hl("Cursor",       s:none, s:none, s:none)
call s:hl("NonText",      s:none, s:none, s:none)
call s:hl("SignColumn",   s:none, s:none, s:none)
call s:hl("SpecialKey",   s:none, s:none, s:none)
call s:hl("StatusLine",   s:none, s:none, s:none)
call s:hl("StatusLineNC", s:none, s:none, s:none)
call s:hl("CursorColumn", s:none, s:none, s:none)
call s:hl("PMenu",        s:none, s:none, s:none)
call s:hl("PMenuSel",     s:none, s:none, s:none)
call s:hl("TabLine",      s:none, s:none, s:none)
call s:hl("TabLineFill",  s:none, s:none, s:none)
call s:hl("TabLineSel",   s:none, s:none, s:none)

"" standard syntax highlighting 
call s:hl("Comment",      s:base03, s:none, s:none)
call s:hl("Keyword",      s:none, s:none, s:none)
call s:hl("Note",         s:yellow, s:none, s:none)
call s:hl("String",       s:green, s:none, s:none)
call s:hl("Todo",         s:red, s:none, s:none)

call s:hl("Statement",    s:base06, s:none, s:none)
call s:hl("Type",         s:base06, s:none, s:none)
call s:hl("StorageClass", s:base06, s:none, s:none)
call s:hl("cStorageClass", s:base06, s:none, s:none)

call s:hl("Number",       s:base07, s:none, s:none)
call s:hl("cNumber",      s:base07, s:none, s:none)
call s:hl("Float",        s:base07, s:none, s:none)
call s:hl("Constant",     s:base07, s:none, s:none)

call s:hl("Operator",     s:red, s:none, s:none)
call s:hl("cOperator",     s:red, s:none, s:none)

" unset
call s:hl("Boolean",      s:none, s:none, s:none)
call s:hl("Character",    s:none, s:none, s:none)
call s:hl("Conditional",  s:none, s:none, s:none)
call s:hl("Define",       s:none, s:none, s:none)
call s:hl("Delimiter",    s:none, s:none, s:none)
call s:hl("Function",     s:none, s:none, s:none)
call s:hl("Identifier",   s:none, s:none, s:none)
call s:hl("Include",      s:none, s:none, s:none)
call s:hl("Label",        s:none, s:none, s:none)
call s:hl("PreProc",      s:none, s:none, s:none)
call s:hl("Repeat",       s:none, s:none, s:none)
call s:hl("Special",      s:none, s:none, s:none)
call s:hl("SpecialChar",  s:none, s:none, s:none)
call s:hl("Structure",    s:none, s:none, s:none)
call s:hl("Tag",          s:none, s:none, s:none)
call s:hl("Typedef",      s:none, s:none, s:none)

"" plugins

"" tools
" diff highlighting 
call s:hl("DiffAdd",     s:none, s:none, s:none)
call s:hl("DiffChange",  s:none, s:none, s:none)
call s:hl("DiffDelete",  s:none, s:none, s:none)
call s:hl("DiffText",    s:none, s:none, s:none)
call s:hl("DiffAdded",   s:none, s:none, s:none)
call s:hl("DiffFile",    s:none, s:none, s:none)
call s:hl("DiffNewFile", s:none, s:none, s:none)
call s:hl("DiffLine",    s:none, s:none, s:none)
call s:hl("DiffRemoved", s:none, s:none, s:none)

" git highlighting 
call s:hl("gitCommitOverflow", s:none, s:none, s:none)
call s:hl("gitCommitSummary",  s:none, s:none, s:none)

"" programming languages
" C highlighting 
call s:hl("cPreCondit", s:none, s:none, s:none)

" C# highlighting 
call s:hl("csClass",                s:none, s:none, s:none)
call s:hl("csAttribute",            s:none, s:none, s:none)
call s:hl("csModifier",             s:none, s:none, s:none)
call s:hl("csType",                 s:none, s:none, s:none)
call s:hl("csUnspecifiedStatement", s:none, s:none, s:none)
call s:hl("csContextualStatement",  s:none, s:none, s:none)
call s:hl("csNewDecleration",       s:none, s:none, s:none)

" CSS highlighting 
call s:hl("cssBraces",    s:none, s:none, s:none)
call s:hl("cssClassName", s:none, s:none, s:none)
call s:hl("cssColor",     s:none, s:none, s:none)

" HTML highlighting 
call s:hl("htmlBold",   s:none, s:none, s:none)
call s:hl("htmlItalic", s:none, s:none, s:none)
call s:hl("htmlEndTag", s:none, s:none, s:none)
call s:hl("htmlTag",    s:none, s:none, s:none)
call s:hl("xmlTag",     s:none, s:none, s:none)
call s:hl("xmlEndTag",  s:none, s:none, s:none)

" JavaScript highlighting 
call s:hl("javaScript",       s:none, s:none, s:none)
call s:hl("javaScriptBraces", s:none, s:none, s:none)
call s:hl("javaScriptNumber", s:none, s:none, s:none)

" Markdown highlighting 
call s:hl("markdownCode",             s:none, s:none, s:none)
call s:hl("markdownError",            s:none, s:none, s:none)
call s:hl("markdownCodeBlock",        s:none, s:none, s:none)
call s:hl("markdownHeadingDelimiter", s:none, s:none, s:none)
call s:hl("markdownItalic",           s:none, s:none, s:none)
call s:hl("markdownBold",             s:none, s:none, s:none)
call s:hl("markdownCodeDelimiter",    s:none, s:none, s:none)

" PHP highlighting 
call s:hl("phpMemberSelector", s:none, s:none, s:none)
call s:hl("phpComparison",     s:none, s:none, s:none)
call s:hl("phpParent",         s:none, s:none, s:none)

" Python highlighting
call s:hl("pythonOperator", s:none, s:none, s:none)
call s:hl("pythonRepeat",   s:none, s:none, s:none)

" Ruby highlighting
call s:hl("rubyAttribute",              s:none, s:none, s:none)
call s:hl("rubyConstant",               s:none, s:none, s:none)
call s:hl("rubyInterpolation",          s:none, s:none, s:none)
call s:hl("rubyInterpolationDelimiter", s:none, s:none, s:none)
call s:hl("rubyRegexp",                 s:none, s:none, s:none)
call s:hl("rubySymbol",                 s:none, s:none, s:none)
call s:hl("rubyStringDelimiter",        s:none, s:none, s:none)

