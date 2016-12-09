let g:airline#themes#grouse#palette = {}

"" emphasis
" TODO(jesper): these could be useful to add some emphasis to some syntax without making a rainbow
let s:bold      = 'bold'
let s:italic    = 'italic'
let s:underline = 'underline'
let s:undercurl = 'undercurl'
let s:inverse   = 'inverse'

"" colour palette
" backgrounds
let s:base00 = '#232123' " darker
let s:base01 = '#2a282a' " normal
let s:base02 = '#353335' " lighter

" foregrounds
let s:base03 = '#6e6d6e' " comments, disabled code
let s:base04 = '#948068' " preprocessor, include, module, etc

let s:base05 = '#c6b391' " normal

let s:base06 = '#a09066' " code keywords, statements, etc
let s:base07 = '#ece6d6' " number, boolean, null, etc

" special colours
let s:black   = '#131313'
let s:red     = '#E5786D'
let s:orange  = '#f99157'
let s:yellow  = '#c3cd3b'
let s:green   = '#7dba6d'
let s:cyan    = '#5fb3b3'
let s:blue    = '#94AFCC'


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
