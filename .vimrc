set nocompatible

set autoindent expandtab tabstop=2 softtabstop=2 shiftwidth=2
set backspace=2
set laststatus=2

set esckeys

syntax enable
set number
set colorcolumn=81

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
