func! DiffSetup()
  set nofoldenable foldcolumn=0 number
  wincmd b
  set nofoldenable foldcolumn=0 number
  "let &columns = &columns * 2
  wincmd =
  "winpos 0 0
  highlight DiffAdd    term=reverse cterm=none ctermbg=DarkGreen  ctermfg=White
  highlight DiffDelete term=reverse cterm=none ctermbg=DarkRed    ctermfg=White
  highlight DiffChange term=reverse cterm=none ctermbg=DarkYellow ctermfg=Black
  highlight DiffText   term=reverse cterm=bold ctermbg=DarkBlue   ctermfg=White
endfunc
