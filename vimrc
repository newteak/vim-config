" set
set nocompatible

filetype plugin indent on
syntax on

set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2

set hlsearch
set incsearch
set ignorecase
set smartcase

set number
set relativenumber

set autoread

set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix,dos,mac
lang en_US.UTF-8

set hidden

set scrolloff=4

set showcmd
set wildmenu
set noshowmode

set nobackup
set noswapfile

au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif

for char in [ '_', '.', ':', ',', ';', '/', '*', '+', '%', '-', '#' ]
    execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
    execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
    execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
    execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

autocmd FileType sh setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd FileType java setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd FileType sql setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd FileType python setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd FileType vim setlocal shiftwidth=4 softtabstop=4 expandtab

xnoremap * :<C-u>call <SID>VisualSetSearch('/')<CR>/<C-R>=@/<CR><CR>
function! s:VisualSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

augroup format_options
  autocmd!
  autocmd BufEnter * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

" color
set colorcolumn=81
highlight ColorColumn ctermbg=236 ctermfg=red

highlight Comment ctermfg=green

highlight Pmenu ctermfg=black ctermbg=white
highlight PmenuSel ctermfg=yellow ctermbg=black

highlight CustomColorTodo ctermbg=green ctermfg=black guibg=#BFFF00 guifg=#000000
highlight CustomColorError ctermbg=red  ctermfg=black guibg=#FF0000 guifg=#000000
highlight CustomColorWarning ctermbg=yellow ctermfg=black guibg=#FFFF00 guifg=#000000
highlight CustomColorOptimize ctermbg=blue ctermfg=black guibg=#0000FF guifg=#000000
highlight CustomColorHack ctermbg=214 ctermfg=black guibg=#F7B124 guifg=#000000
highlight CustomColorHelp ctermbg=106 ctermfg=black guibg=#AAB01E guifg=#000000
highlight CustomColorDeprecated ctermbg=255 ctermfg=black guibg=#FFFFFF guifg=#000000

augroup HiglightTODO
  autocmd!
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorTodo', 'TODO', -1)
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorError', 'FIXME\|XXX', -1)
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorWarning', 'WARNING', -1)
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorOptimize', 'OPTIMIZE', -1)
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorHack', 'HACK', -1)
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorHelp', 'HELP', -1)
  autocmd WinEnter,VimEnter * :silent! call matchadd('CustomColorDeprecated', 'DEPRECATED', -1)
augroup END

set laststatus=2
set statusline=
set statusline+=\ %R                                       "Readonly or not
set statusline+=%m                                         "Modified
set statusline+=\ %F                                       "File full path
set statusline+=\ %l:%c                                    "Line:Col Number
set statusline+=\ %p%%\                                    "Row Percentage
set statusline+=%=                                         "Right side
set statusline+=\ %Y\ \|                                   "File type
set statusline+=\ %{&fileencoding?&fileencoding:&encoding} "Encoding
set statusline+=\[%{&fileformat}\]                         "Encoding2
set statusline+=\                                          "Empty char

" keymap
let mapleader=" "

nnoremap <SPACE> <Nop>

nnoremap Q <nop>

nnoremap <leader>R :source ~/.vim/vimrc<CR>
nnoremap <silent> <leader>f, :e ~/.vim/vimrc<CR>

nnoremap Y y$
nnoremap <C-y> y^
nnoremap <leader>Y "+y$
nnoremap <leader><C-y> "+y^
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p

nnoremap <leader>a ggVG

nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <silent> n nzzzv
nnoremap <silent> N Nzzzv

nnoremap <C-l> :nohl<CR>

nnoremap <leader>; :
vnoremap <leader>; :

nnoremap x "_x
vnoremap x "_x

inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ? ?<C-g>u

nnoremap <leader>. :Explore<CR>

nnoremap <F1> :h <C-r>=expand("<cword>")<CR>
vnoremap <F1> y :h <C-r>0

