" Plugins Section

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
  " Snippet
  Plug 'SirVer/ultisnips'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " Write
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-speeddating'
  Plug 'tommcdo/vim-lion'

  " Quick Move
  Plug 'airblade/vim-gitgutter'
  Plug 'easymotion/vim-easymotion'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " Utils
  Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

  " OS Support
  Plug 'vim-scripts/fcitx.vim'

  " Color
  Plug 'ap/vim-css-color'
  Plug 'machakann/vim-highlightedyank'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'morhetz/gruvbox'
call plug#end()

" plugin name: ultisnips
let g:UltiSnipsExpandTrigger="<C-y>"
let g:UltiSnipsJumpForwardTrigger='<TAB>'
let g:UltiSnipsJumpBackwardTrigger='<S-TAB>'
let g:coc_snippet_next='<TAB>'
let g:coc_snippet_prev='<S-TAB>'

let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=['~/.local/share/snippets/ultisnips']

" resolve when insert mode keyon function freeeze
if has('nvim')
    au VimEnter * if exists('#UltiSnips_AutoTrigger')
        \ |     exe 'au! UltiSnips_AutoTrigger'
        \ |     aug! UltiSnips_AutoTrigger
        \ | endif
endif

" plugin name: coc
function! InstallCocPlugins()
  CocInstall coc-java
  CocInstall coc-html
  CocInstall coc-vetur
  CocInstall coc-tsserver
  CocInstall coc-lists
  CocInstall coc-snippets
endfunction

function! UnInstallCocPlugins()
  CocUninstall coc-java
  CocUninstall coc-html
  CocUninstall coc-vetur
  CocUninstall coc-tsserver
  CocUninstall coc-lists
  CocUninstall coc-snippets
endfunction

function! InstallCocSnipPlugins()
  CocInstall coc-lists
  CocInstall coc-snippets
endfunction

" plugin name: vim-gitgutter
let g:gitgutter_map_keys=0
let g:gitgutter_set_sign_backgrounds=0

" plugin name: easymotion
let g:EasyMotion_do_mapping=0
let g:EasyMotion_smartcase=1

" plugin name: vim-wiki
let g:vimwiki_list=[
    \{
    \   'path': '~/Documents/wiki/',
    \   'syntax' : 'markdown',
    \   'ext' : '.md',
    \   'diary_rel_path': './today',
    \},
    \{
    \   'path': '~/Documents/company-wiki/',
    \   'syntax' : 'markdown',
    \   'ext' : '.md',
    \   'index' : 'index',
    \   'diary_rel_path': './today',
    \},
\]

let g:auto_template_list=[
    \{
    \   'path': '~/Documents/wiki/',
    \},
    \{
    \   'path': '~/Documents/wiki/language/',
    \},
    \{
    \   'path': '~/Documents/wiki/cook/',
    \},
    \{
    \   'path': '~/Documents/company-wiki/',
    \},
\]

" set conceallevel
let g:vimwiki_conceallevel=0
let g:indentLine_conceallevel=0
let g:vimwiki_global_ext=0

" disable table shortcut
let g:vimwiki_table_mappings=0

" disable auto fold
let g:vimwiki_folding='custom'

augroup vimwikiauto
    " <C-s> move table column to right
    autocmd FileType vimwiki inoremap <C-s> <C-r>=vimwiki#tbl#kbd_tab()<CR>
    " <C-a> move table column to left
    autocmd FileType vimwiki inoremap <C-a> <Left><C-r>=vimwiki#tbl#kbd_shift_tab()<CR>
augroup END

autocmd FileType vimwiki nnoremap <C-h> :VimwikiGoBackLink<CR>

let g:md_modify_disabled=0

function! LastModified()
    if g:md_modify_disabled
        return
    endif
    if &modified
        " echo('markdown updated time modified')
        let save_cursor=getpos(".")
        let n=min([10, line("$")])
        keepjumps exe '1,' . n . 's#^\(.\{,10}lastmod\s*: \).*#\1' .
            \ strftime('%Y-%m-%d %H:%M:%S+0900') . '#e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfun

" Thank you johngrib!
" rep: https://github.com/johngrib/dotfiles
function! NewTemplate()
    let l:wiki_directory=v:false
    for wiki in g:auto_template_list
        if expand('%:p:h') . '/' == expand(wiki.path)
            let l:wiki_directory=v:true
            break
        endif
    endfor
    if !l:wiki_directory
        return
    endif
    if line("$") > 1
        return
    endif

    let l:template=[]
    call add(l:template, '---')
    call add(l:template, 'title      : "' . expand('%:t:r') . expand('"'))
    call add(l:template, 'summary    : "' . expand('%:t:r') . expand('"'))
    call add(l:template, 'date       : ' . strftime('%Y-%m-%d %H:%M:%S+0900'))
    call add(l:template, 'lastmod    : ' . strftime('%Y-%m-%d %H:%M:%S+0900'))
    call add(l:template, 'tags       : [""]')
    call add(l:template, 'categories : [""]')
    call add(l:template, 'draft      : true')
    call add(l:template, '---')
    call add(l:template, '')
    call setline(1, l:template)
    execute 'normal! G'
    execute 'normal! $'

    echom 'new wiki page has created'
endfunction

augroup vimwikiauto
    autocmd BufWritePre *wiki/*.md call LastModified()
    autocmd BufRead,BufNewFile *wiki/*.md call NewTemplate()
    autocmd BufWritePre *post/*.md call LastModified()
    autocmd BufRead,BufNewFile *post/*.md call NewTemplate()
augroup END

" Thank you johngrib!
" rep: https://github.com/johngrib/dotfiles
function! UpdateBookProgress()
  let l:save_cursor=getpos(".")
  let l:awk_command="awk '{print int($4 * 100 / $6), \"\\% :\", $4, $5, $6 }'"
  %g,\v^\d+ \% : \d+ \/ \d+,exe "normal! V!" . l:awk_command . "\<CR>"
  call setpos('.', l:save_cursor)
endfunction

augroup todoauto
  autocmd BufWritePre *wiki/book-*.md call UpdateBookProgress()
augroup END

" plugin name: vim-highlightedyank
let g:highlightedyank_highlight_duration=150
highlight HighlightedyankRegion cterm=reverse gui=reverse

" plugin name: vim-indent-guides
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_exclude_filetypes=['help']

" plugin name: vim-better-whitespace
let g:better_whitespace_enabled=0

set nocompatible

if has("syntax")
  syntax on
end

" Set Section
filetype plugin indent on

set autoindent

set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2

set hlsearch
set incsearch
set ignorecase
set smartcase

set autoread

set encoding=utf-8
set fencs=utf-8
lang en_US.UTF-8
set fileformats=unix,dos,mac

set history=9999

set backspace=2

set hidden

set noerrorbells

set scrolloff=8

set wildmenu

set showcmd
set showmode

set number
set relativenumber

set nobackup
set noswapfile

set signcolumn=yes:1

set listchars=tab:→\ ,trail:-,eol:↲,extends:»,precedes:«,nbsp:%,space:·
set showbreak=↪

set updatetime=100

let g:netrw_banner = 0

" remember cusor postion
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif

for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '%', '-', '#' ]
    execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
    execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
    execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
    execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

" add custome file type
autocmd BufNewFile,BufRead *.msg set filetype=message

" set indent by filetype
autocmd FileType sh setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd FileType java setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd FileType sql setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd FileType python setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd FileType vimwiki setlocal shiftwidth=4 tabstop=4 expandtab

" https://github.com/vim/vim/blob/v8.2.0/runtime/indent/html.vim#L217-L220
let g:html_indent_inctags = 'p'

" vim visual star search
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

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Color Section
set t_Co=256

let g:gruvbox_termcolors=256
let g:gruvbox_improved_warnings = 1
let g:gruvbox_transparent_bg=1
colorscheme gruvbox

set colorcolumn=81

highlight ColorColumn cterm=NONE ctermbg=236 ctermfg=red guibg=#3c3839 guifg=#ff0000
highlight SignColumn cterm=NONE ctermbg=NONE ctermfg=NONE

if !&diff
  set cursorline
endif
highlight CursorLine cterm=NONE ctermbg=235 guibg=#3c3839

highlight Comment ctermfg=green

highlight CocUnusedHighlight ctermbg=red ctermfg=black

highlight GitGutterAdd    ctermfg=2 guifg=#00ff00
highlight GitGutterChange ctermfg=3 guifg=#ffff00
highlight GitGutterDelete ctermfg=1 guifg=#ff0000

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

" status bar
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
set statusline+=\ 

" Thank you luke smith
autocmd BufWritePost bm-files,bm-dirs !shortcuts
autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

"Key Mapping Section
let mapleader=" "

nnoremap <SPACE> <Nop>

nnoremap <silent> <leader><ENTER> :Marks<CR>

" When I press double space, I press as hard as possible. That make my boss think
" I'm a good programmer.
nnoremap <leader><SPACE> :CocAction<CR>
inoremap <silent><expr> <c-space> coc#refresh()

nnoremap <silent> Q <nop>

" DRY: Don't Repeat Yassnippet.
nnoremap <C-e> :Snippets<CR>
inoremap <C-e> <ESC>:Snippets<CR>

" RELOAD
nnoremap <leader>R :source $XDG_CONFIG_HOME/nvim/init.vim<CR>

nnoremap Y y$
nnoremap <C-y> y^
nnoremap <leader>Y "+y$
nnoremap <leader><C-y> "+y^
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p

nnoremap <leader>a ggVG

" We are fzf familiy. vim for life.
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>r :History<CR>
nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <leader>s :Lines<CR>
vnoremap <silent> <leader>s y:Lines <C-r>0<CR>
nnoremap <silent> <c-s> :Snippets<CR>
inoremap <silent> <expr> <c-s> coc#refresh()
nmap <leader>x <plug>(fzf-maps-n)
xmap <leader>x <plug>(fzf-maps-x)
omap <leader>x <plug>(fzf-maps-o)

"vim's "s" is ready for snipper.
nnoremap s <Nop>

nmap <silent> sf <Plug>(easymotion-bd-fl)
vmap <silent> sf <Plug>(easymotion-bd-fl)
nmap <silent> ss <Plug>(easymotion-bd-f2)
vmap <silent> ss <Plug>(easymotion-bd-f2)
nmap <silent> sn <Plug>(easymotion-f2)
vmap <silent> sn <Plug>(easymotion-f2)
nmap <silent> sp <Plug>(easymotion-F2)
vmap <silent> sp <Plug>(easymotion-F2)

nmap <silent> sh <Plug>(easymotion-bl)
vmap <silent> sh <Plug>(easymotion-bl)
nmap <silent> sk <Plug>(easymotion-k)
vmap <silent> sk <Plug>(easymotion-k)
nmap <silent> sj <Plug>(easymotion-j)
vmap <silent> sj <Plug>(easymotion-j)
nmap <silent> sl <Plug>(easymotion-wl)
vmap <silent> sl <Plug>(easymotion-wl)

nmap <silent> s. <Plug>(easymotion-repeat)
vmap <silent> s. <Plug>(easymotion-repeat)

" "g" is vim's goto func.
nnoremap <silent> gc <Plug>(coc-declaration)
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> g[ :GitGutterPrevHunk<CR>
nnoremap <silent> g] :GitGutterNextHunk<CR>

" Move like ninja🥷.
noremap <leader>` <C-^>
nnoremap <leader>h ^
vnoremap <leader>h ^
nnoremap <leader>j 7j
vnoremap <leader>j 7j
nnoremap <leader>k 7k
vnoremap <leader>k 7k
nnoremap <leader>l $
vnoremap <leader>l $

" <c-j> key is missing part of vim. I found this feature
nnoremap <C-j> i<CR><ESC>

nnoremap <C-l> :nohl<CR>

nnoremap <leader>; :
vnoremap <leader>; :

nnoremap \ :Rg<CR>

nnoremap x "_x
vnoremap x "_x

" Private DB
let g:vimwiki_map_prefix = '<Leader>v'
nmap <leader>vv <Plug>VimwikiIndex
nmap <leader>vi <Plug>VimwikiDiaryIndex
nmap <leader>v<leader>v <Plug>VimwikiMakeDiaryNote
nmap <leader>v<leader>i <Plug>VimwikiDiaryGenerateLinks
nmap <leader>vt :VimwikiTable<CR>

nnoremap <silent> <leader>b :Buffers<cr>

nnoremap <silent> n nzzzv
nnoremap <silent> N Nzzzv

nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap J mzJ`z
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ? ?<C-g>u

nnoremap <silent> <leader>. :Explore<CR>
nnoremap <silent> <leader>, :e $XDG_CONFIG_HOME/nvim/init.vim<CR>

nnoremap <silent> <F1> :h <C-r>=expand("<cword>")<CR>
vnoremap <silent> <F1> y :h <C-r>0
nnoremap <silent> <F2> :Explore<CR>
nnoremap <silent> <F4> :UltiSnipsEdit<cr>
nnoremap <silent> <F7> :call ToggleQuickFix()<CR>
nnoremap <silent> <F8> :CocList outline<cr>
nnoremap <silent> <F12> :IndentGuidesToggle<CR>:set list!<CR>:ToggleWhitespace<CR>

" Function Section
function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    CocDiagnostics 5
  else
    lclose
  endif
endfunction

function! Preserve(command)
    " Save the last search.
    let search = @/
    " Save the current cursor position.
    let cursor_position = getpos('.')
    " Save the current window position.
    normal! H
    let window_position = getpos('.')
    call setpos('.', cursor_position)
    " Execute the command.
    execute a:command
    " Restore the last search.
    let @/ = search
    " Restore the previous window position.
    call setpos('.', window_position)
    normal! zt
    " Restore the previous cursor position.
    call setpos('.', cursor_position)
endfunction

function! GrepToList(re)
  cexpr []
  execute 'silent! noautocmd bufdo vimgrepadd /' . a:re . '/j %'
  cw
endfunction
