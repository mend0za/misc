"set guifont=Anonymous\ Pro\ 12
"set guifont=Terminus\ 14 " GTK
set guifont=terminus-18 "Athena
set guioptions=cgi
colorscheme tortemod

set lines=40
set columns=125

"folding tunes
set foldmethod=syntax
set foldlevel=0
set foldcolumn=0



" IDE like Borland Pascal 7 :)
map <F2> :w<CR>
map <F7> :cprevious<CR>
map <F8> :cnext<CR>
map <F9> :!make<CR>

" buffers list scroll
map <F5> :bprev<CR>
map <F6> :bnext<CR>

" LaTeX tunes
let g:tex_fold_enabled=1
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
autocmd BufReadPost *.tex setlocal spell
autocmd BufReadPost *.[ch] setlocal spell
autocmd BufReadPost .vimprojects setlocal foldlevel=0

" cscope specific
set cscopetag
set csto=0
cscope add $HOME/.vim/cscope-kernel/cscope.out
nmap <C-[> :cscope find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-Bslash> :cscope find s <C-R>=expand("<cword>")<CR><CR>


let g:proj_window_width=25
Project
