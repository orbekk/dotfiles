let mapleader = ","
syntax on

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" TODO(orbekk): Try ctrlp.vim instead.
" Plugin 'wincent/command-t'
" Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'chriskempson/base16-vim'
Plugin 'chriskempson/vim-tomorrow-theme'
Plugin 'gmarik/Vundle.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/unite-outline'
Plugin 'Shougo/neomru.vim'
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

if executable('ag')
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts =
\ '-i --vimgrep --ignore ' .
\ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
endif

" let g:unite_source_rec_find_command =
" \ ['-path', '*/.git/*', '-prune', '-o', '-path', '*/\.*', '-prune', 
" \ '-o', '-type', 'l', '-print']

let g:unite_source_history_yank_enable = 1
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=files   -start-insert file_mru file_rec/async:!<cr>
nnoremap <leader>r :<C-u>Unite -no-split -buffer-name=mru     -start-insert file_rec/git<cr>
nnoremap <leader>o :<C-u>Unite -no-split -buffer-name=outline -start-insert outline<cr>
nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
nnoremap <leader>b :<C-u>Unite -no-split -buffer-name=buffer  buffer bookmark<cr>
nnoremap <leader>g :<C-u>Unite -no-split -buffer-name=grep  -start-insert grep<cr>

" map <leader>t :CtrlP<CR>
" map <leader>b :CtrlPBuffer<CR>
" map <leader>r :CtrlPMRU<CR>

set wildignore+=*.class,target/*,project/*

"set guifont=DroidSansMono\ 10
set guifont="Source Code Pro 10"
set guioptions-=m
set guioptions-=M
set guioptions-=T
set guioptions-=r
set guioptions-=L
if &t_Co > 255 || has('gui_running')
  set background=dark
  let base16colorspace=256
  colorscheme base16-tomorrow
endif

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
