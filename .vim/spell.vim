" Enable spell checking, even in program source files. Hit <F8> to
" highlight spelling errors. Hit it again to turn highlighting off.
"   ]s  Next misspelled word
"   [s  Previous misspelled word
"   z=  Make suggestions for current word
"   zg  Add to good words list
"   zug Remove word from good words list
setlocal spell spelllang=en_us  " American English spelling.
set spellfile=~/.words.utf8.add " My own word list is saved here.
" Toggle spelling with F8 key.
map <F8> :set spell!<CR><Bar>:echo "Spell check: " . strpart("OffOn", 3 * &spell, 3)<CR>
" Change the default highlighting colors and terminal attributes
highlight clear SpellBad
highlight clear SpellCap
highlight clear SpellLocal
highlight clear SpellRare
highlight SpellBad   cterm=underline,bold
highlight SpellBad   cterm=underline,bold
highlight SpellCap   cterm=underline,bold
highlight SpellLocal cterm=underline,bold
highlight SpellRare  cterm=underline,bold
" Limit list of suggestions to the top 10 items
set spellsuggest=best,10
" Turns spell checking off by default
set nospell
