" Generated by Color Theme Generator at Sweyla
" http://sweyla.com/themes/seed/939829/

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

" Set environment to 256 colours
set t_Co=256

let colors_name = "sweyla939829"

if version >= 700
  hi CursorLine     guibg=#030005 ctermbg=16
  hi CursorColumn   guibg=#030005 ctermbg=16
  hi MatchParen     guifg=#9FACDE guibg=#030005 gui=bold ctermfg=146 ctermbg=16 cterm=bold
  hi Pmenu          guifg=#FFFFFF guibg=#323232 ctermfg=255 ctermbg=236
  hi PmenuSel       guifg=#FFFFFF guibg=#FF497F ctermfg=255 ctermbg=204
endif

" Background and menu colors
hi Cursor           guifg=NONE guibg=#FFFFFF ctermbg=255 gui=none
hi Normal           guifg=#FFFFFF guibg=#030005 gui=none ctermfg=255 ctermbg=16 cterm=none
hi NonText          guifg=#FFFFFF guibg=#120F14 gui=none ctermfg=255 ctermbg=233 cterm=none
hi LineNr           guifg=#323034 guibg=#1C191E gui=none ctermfg=236 ctermbg=234 cterm=none
hi StatusLine       guifg=#FFFFFF guibg=#350E1D gui=italic ctermfg=255 ctermbg=234 cterm=italic
hi StatusLineNC     guifg=#FFFFFF guibg=#2B282D gui=none ctermfg=255 ctermbg=235 cterm=none
hi VertSplit        guifg=#FFFFFF guibg=#1C191E gui=none ctermfg=255 ctermbg=234 cterm=none
hi Folded           guifg=#FFFFFF guibg=#030005 gui=none ctermfg=255 ctermbg=16 cterm=none
hi Title            guifg=#FF497F guibg=NONE	gui=bold ctermfg=204 ctermbg=NONE cterm=bold
hi Visual           guifg=#59C8FF guibg=#323232 gui=none ctermfg=81 ctermbg=236 cterm=none
hi SpecialKey       guifg=#FF66FF guibg=#120F14 gui=none ctermfg=207 ctermbg=233 cterm=none
"hi DiffChange       guibg=#4E4C03 gui=none ctermbg=58 cterm=none
"hi DiffAdd          guibg=#272550 gui=none ctermbg=235 cterm=none
"hi DiffText         guibg=#673269 gui=none ctermbg=241 cterm=none
"hi DiffDelete       guibg=#420003 gui=none ctermbg=52 cterm=none
 
hi DiffChange       guibg=#4C4C09 gui=none ctermbg=234 cterm=none
hi DiffAdd          guibg=#252556 gui=none ctermbg=17 cterm=none
hi DiffText         guibg=#66326E gui=none ctermbg=22 cterm=none
hi DiffDelete       guibg=#3F000A gui=none ctermbg=0 ctermfg=196 cterm=none
hi TabLineFill      guibg=#5E5E5E gui=none ctermbg=235 ctermfg=228 cterm=none
hi TabLineSel       guifg=#59C8FF gui=bold ctermfg=81 cterm=bold


" Syntax highlighting
hi Comment guifg=#FF497F gui=none ctermfg=204 cterm=none
hi Constant guifg=#FF66FF gui=none ctermfg=207 cterm=none
hi Number guifg=#FF66FF gui=none ctermfg=207 cterm=none
hi Identifier guifg=#E66488 gui=none ctermfg=168 cterm=none
hi Statement guifg=#9FACDE gui=none ctermfg=146 cterm=none
hi Function guifg=#4369C7 gui=none ctermfg=62 cterm=none
hi Special guifg=#C400C9 gui=none ctermfg=164 cterm=none
hi PreProc guifg=#C400C9 gui=none ctermfg=164 cterm=none
hi Keyword guifg=#9FACDE gui=none ctermfg=146 cterm=none
hi String guifg=#59C8FF gui=none ctermfg=81 cterm=none
hi Type guifg=#D823FF gui=none ctermfg=165 cterm=none
hi pythonBuiltin guifg=#E66488 gui=none ctermfg=168 cterm=none
hi TabLineFill guifg=#255069 gui=none ctermfg=23 cterm=none

