scriptencoding utf-8
if exists("did_load_filetypes")
  finish
endif

" Associate unknown filetypes.
augroup filetypedetect
  au! BufRead,BufNewFile *.gclient                  setf python
  au! BufRead,BufNewFile *.glue                     setf python
  au! BufRead,BufNewFile *.{gyp,gypi,gclient}       setf python
  au! BufRead,BufNewFile *.{proto,protodevel}       setf proto
  au! BufRead,BufNewFile .tmux.conf*                setf tmux
augroup END

" Some languages prefers tabs.
autocmd FileType make           set noexpandtab
autocmd FileType sql            set expandtab sw=2 sts=2
