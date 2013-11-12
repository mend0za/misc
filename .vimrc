syntax on
set vb t_vb=
set smartindent
set smarttab
set autoindent
set autoread
"set paste
filetype plugin indent on
runtime ftplugin/man.vim
colorscheme elflord

set mouse=a

set number


"==How to run specified command with selected filetype
"autocmd BufEnter *.html setlocal indentexpr=
autocmd BufEnter *.c setlocal autoindent
autocmd BufEnter *.c,*.h,*.cpp,*.hpp,*.cc source ~/.vim/c.vim	" Linux Kernel coding style 
autocmd BufRead *.rb set expandtab autoindent smarttab smartindent ts=2 sw=2 sts=2
autocmd BufEnter *.csv setlocal syntax=cpp
autocmd BufEnter *.md setlocal syntax=markdown
autocmd BufEnter control.modules.in setlocal syntax=debcontrol

" Buildroot-related issues
autocmd BufEnter Config.in setlocal syntax=kconfig
autocmd BufEnter *.in setlocal syntax=kconfig
autocmd BufEnter Makefile.*in setlocal syntax=make
autocmd BufEnter *.mk.in setlocal syntax=make

autocmd BufEnter svn-commit.* setlocal spell
autocmd BufEnter *.txt setlocal spell

set spelllang=en_us,ru_ru

"language C
set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,cp1251,koi8
set laststatus=2

set splitbelow
set splitright

" ctags and scsope
"set tags=./tags,./TAGS,tags,TAGS 

"set csprg=/usr/bin/cscope
"set csto=1
"set cscopequickfix=s-,c-,d-,i-,t-,e-
"cs add ~/cscope/cscope.out
"set cst
"set cspc=4
"nmap <F11> :split<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>


set spelllang=en_us

set viewoptions=cursor,folds
autocmd BufWinLeave *.[ch] mkview
autocmd BufWinEnter *.[ch] silent loadview

