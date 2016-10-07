let g:airline#themes#grouse#palette = {}

"" colour palette
let s:base00 = '#232123' " darker background
let s:base01 = '#2a282a' " normal background
let s:base02 = '#353335' " lighter background

let s:base03 = '#6e6d6e' " accent foreground 00
let s:base04 = '#948068' " accent foreground 01
let s:base05 = '#c6b391' " normal foreground
let s:base06 = '#a08066' " accent foreground 10
let s:base07 = '#f7fffe' " accent foreground 11

" special colours 
let s:red     = '#ec5f67' 
let s:orange  = '#f99157'
let s:yellow  = '#c3cd3b'
let s:green   = '#7dba6d'

let s:none      = 'none'

"" emphasis
let s:bold      = 'bold'
let s:italic    = 'italic'
let s:underline = 'underline'
let s:undercurl = 'undercurl'
let s:inverse   = 'inverse'


let s:N1   = [ s:base05, s:base00, 0, 0]
let s:N2   = [ s:base05, s:base02, 0, 0]
let s:N3   = [ s:base01, s:base05, 0, 0]
let g:airline#themes#grouse#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#grouse#palette.insert = copy(g:airline#themes#grouse#palette.normal)
let g:airline#themes#grouse#palette.replace = copy(g:airline#themes#grouse#palette.normal)
let g:airline#themes#grouse#palette.visual = copy(g:airline#themes#grouse#palette.normal)

let s:IA1   = [ s:base03, s:base02, 0, 0]
let s:IA2   = [ s:base03, s:base02, 0, 0]
let s:IA3   = [ s:base03, s:base02, 0, 0]
let g:airline#themes#grouse#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)

let g:airline#themes#grouse#palette.accents = {
	\ 'red':   [ s:red, '', 0, '' ],
	\ 'green': [ s:green, '', 0, '' ],
	\ 'yellow': [ s:yellow, '', 0, '' ],
	\ 'orange': [ s:orange, '', 0, '' ],
	\ }

if get(g:, 'loaded_ctrlp', 0)
	let g:airline#themes#grouse#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
		\ [ s:base05, s:base00, 0, 0, s:none ],
		\ [ s:base05, s:base02, 0, 0, s:none ],
		\ [ s:base01, s:base05, 0, 0, s:bold ])
endif
