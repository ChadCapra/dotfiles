syntax enable

set esckeys
set laststatus=2

set tabstop=2 softtabstop=2 shiftwidth=2
set expandtab
set smartindent

set number
set nowrap
set smartcase
set incsearch

set colorcolumn=81

if !has('gui_running')
  set t_Co=256
endif

" open splits in more natural way
set splitbelow
set splitright

" set leader to space
let mapleader = "\<Space>"

nmap <leader>w :w<cr>
nmap <leader>q :q<cr>
