let g:airline#themes#grouse#palette = {}

"" colour palette
let s:base00 = '#232123' " darker background
let s:base01 = '#2a282a' " normal background
let s:base02 = '#353335' " lighter background

let s:base03 = '#6e6d6e' " accent foreground 00
let s:base04 = '#948068' " accent foreground 01
let s:base05 = '#aeae95' " normal foreground
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
let g:airline#themes#grouse#palette.normal_modified = {
      \ 'airline_c': [ s:yellow, s:base05 , 255     , 53      , ''     ] ,
      \ }


let s:I1   = [ s:base02, s:orange, 0, 0]
let s:I2   = [ s:base05, s:base02, 0, 0]
let s:I3   = [ s:base01, s:base05, 0, 0]
let g:airline#themes#grouse#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#grouse#palette.insert_modified = g:airline#themes#grouse#palette.insert

let g:airline#themes#grouse#palette.replace = copy(g:airline#themes#grouse#palette.insert)
let g:airline#themes#grouse#palette.replace_modified = g:airline#themes#grouse#palette.replace


let s:V1   = [ s:base02, s:yellow, 0, 0]
let s:V2   = [ s:base05, s:base02, 0, 0]
let s:V3   = [ s:base01, s:base05, 0, 0]
let g:airline#themes#grouse#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#grouse#palette.visual_modified = g:airline#themes#grouse#palette.visual


let s:IA1   = [ s:base02, s:yellow, 0, 0]
let s:IA2   = [ s:base05, s:base02, 0, 0]
let s:IA3   = [ s:base01, s:base05, 0, 0]
let g:airline#themes#grouse#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
let g:airline#themes#grouse#palette.inactive_modified = g:airline#themes#grouse#palette.inactive

let g:airline#themes#grouse#palette.accents = {
      \ 'red': [ s:red, '' , 160 , ''  ]
      \ }

if !get(g:, 'loaded_ctrlp', 0)
  finish
endif

let s:N1   = [ s:base05, s:base00, 0, 0]
let s:N2   = [ s:base05, s:base02, 0, 0]
let s:N3   = [ s:base01, s:base05, 0, 0]
let g:airline#themes#grouse#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ [ s:base05, s:base00, 0, 0, s:none ],
      \ [ s:base05, s:base02, 0, 0, s:none ],
      \ [ s:base01, s:base05, 0, 0, s:bold ])

