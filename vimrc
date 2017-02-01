"author: REDSPHINX

set shell=/bin/bash

"vundle things
"""{{{
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

"""}}}

"/// PLUGINS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ///
"""{{{

Plugin 'nvie/vim-flake8'

Plugin 'vim-scripts/indentpython.vim'

Plugin 'scrooloose/nerdtree'
nnoremap q :NERDTreeToggle<CR>

Plugin 'pydave/vim-hiinterestingword'

Plugin 'mikewest/vimroom' 
nnoremap <Leader>vr :VimroomToggle<CR>

"seems to get stuck when installing
"Plugin 'Valloric/YouCompleteMe'

Plugin 'Raimondi/delimitMate'

Plugin 'scrooloose/nerdcommenter'

Plugin 'wesQ3/vim-windowswap' 
let g:windowswap_map_keys = 0 "prevent default bindings
nnoremap <silent> <leader>yw :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <silent> <leader>pw :call WindowSwap#DoWindowSwap()<CR>"

Plugin 'mattn/flappyvird-vim'

Plugin 'tpope/vim-fugitive'

Plugin 'itchyny/calendar.vim'
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1

"/// required

call vundle#end()
filetype plugin indent on

"""}}}

"/// COLORSCHEME - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ///
"""{{{
set t_Co=256
set background=dark
syntax enable
colorscheme molokai
"""}}}


"/// SEARCHING - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ///
"""{{{
" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

set hlsearch

"""}}}


"/// MISCELLANEOUS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ///
"""{{{
set nu
set wrap
set linebreak
set nolist
set formatoptions+=l
set smartindent
set tabstop=2
set shiftwidth=4
set expandtab
set showmatch
set undofile
set scrolloff=5

au FocusLost * :silent! wall

au VimResized * :wincmd =

set wildmode=longest:full
set wildmenu

set noswapfile

set backup

set backupdir=~/.vim/tmp/backup// " backups"

" Show matches for angular parentesis
set matchpairs+=<:>

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif

" Spellchecking
nnoremap <leader>sc :setlocal spell spelllang=en_us<CR>

"""}}}


"/// FOLDING - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ///
"""{{{
set foldmethod=marker

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" 'Focus' the current line.  Basically:
"
" 1. Close all folds.
" 2. Open just the folds containing the current line.
" 3. Move the line to a little bit (15 lines) above the center of the
" screen.
" 4. Pulse the cursor line.  My eyes are bad.
" 
" This mapping wipes out the z mark, which I never use.
"
" I use :sus for the rare times I want to actually background Vim.
nnoremap <c-z> mzzMzvzz15<c-e>`z:Pulse<cr>

function! MyFoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction
set foldtext=MyFoldText()

"jump folds
nnoremap <silent> <leader>a :call NextClosedFold('j')<cr>
nnoremap <silent> <leader>s :call NextClosedFold('k')<cr>
function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
    endwhile
    if open
        call winrestview(view)
    endif
endfunction

"""}}}


"/// HIGHLIGHTING - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ///
"""{{{
" Mappings
nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>

" Default Highlights
hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

"""}}}

"/// PYTHON - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ///
"""{{{
"correct indenting
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

"highlight whitespaces
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
set encoding=utf-8

"standard line highlighting
let python_highlight_all=1
syntax on

"run python inside vim with F9 key
nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>

"""}}}

