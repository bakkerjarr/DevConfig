" Turn on the ruler for cursor position
set ruler

" Show line numbers
set nu

" use arrow keys and other useful things
set nocompatible

" size of a hard tabstop
set tabstop=4

" size of an 'indent'
set shiftwidth=4

" a combination of spaces and tabs are used to simulate tab stops at a width
" other than the (hard)tabstop
set softtabstop=4

" always uses spaces instead of tab characters
set expandtab

" use auto-indentation
set autoindent

" syntax highlighting
syntax on

" Map keys for switching tabs (previous then next)
map <F7> :tabp<CR>
map <F8> :tabn<CR>
