let mapleader = ","
syntax on

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" TODO(orbekk): Try ctrlp.vim instead.
" Plugin 'wincent/command-t'
Plugin 'chriskempson/vim-tomorrow-theme'
Plugin 'gmarik/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
call vundle#end()

set modeline
set tabpagemax=20
set autoread
set noswapfile
set timeoutlen=1000
set ignorecase
set expandtab
set shiftwidth=2
set softtabstop=2
set smarttab
set smartcase
set incsearch
set autoindent
set formatoptions=crt
setglobal fileencoding=utf-8
set fileencodings=ucs-bomb,utf-8,latin1
set virtualedit=block
set hidden
set confirm
inoremap <C-c> <nop>
set hlsearch

filetype plugin on
filetype indent on

setlocal complete+=ktags

nmap <silent> <C-N> :silent noh<CR>
map <leader>cd :cd %:p:h<CR>:pwd<CR>

map <leader>t :CtrlP<CR>
map <leader>b :CtrlPBuffer<CR>
map <leader>r :CtrlPMRU<CR>

set wildignore+=*.class,target/*,project/*

"set guifont=DroidSansMono\ 10
set guifont="Source Code Pro 10"
set guioptions-=m
set guioptions-=T
set guioptions-=r
colorscheme Tomorrow-Night

set colorcolumn=81

map <leader>R :source ~/.vimrc<CR>

function! GetFileBase()
  return substitute(expand("%"),
      \ '\(.\{-}\)\(_test\|_unittest\)\?\.\(h\|cc\)$', '\1', "")
endfunction

" Switch between cc, h, test/unittest files.
function! EditCc()
  exec "edit " . fnameescape(GetFileBase() . ".cc")
endfunction
map <leader>cc :silent :call EditCc()<CR>

function! EditH()
  exec "edit " . fnameescape(GetFileBase() . ".h")
endfunction
map <leader>h :silent :call EditH()<CR>

function! EditTest()
  let file_base = GetFileBase()
  if (filereadable(file_base . "_unittest.cc"))
    exec "edit " . fnameescape(file_base . "_unittest.cc")
  else
    exec "edit " . fnameescape(file_base . "_test.cc")
  endif
endfunction
map <leader>te :silent :call EditTest()<CR>

source ~/.vimrc.local
