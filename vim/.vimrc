" Vimrc file.
"
" Maintainer: Nicolas Bonnec
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
    finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Management of console or GUI settings.
if has("gui_running")
    " We are in gVim
    " Linux
    if has("gui_gtk2")
        :set guifont=DejaVu\ Sans\ Mono\ 11
    " Windows
    elseif has("gui_win32")
        :set guifont=DejaVu_Sans_Mono:h11:cANSI:
    endif
else
    " We are in a console
    set background=dark
endif

" Manage colors.
if filereadable($VIMRUNTIME . "/colors/wombat256.vim") ||
            \ filereadable($HOME . "/.vim/colors/wombat256.vim")
    colorscheme wombat256
elseif filereadable($VIMRUNTIME . "/colors/wombat.vim") ||
            \ filereadable($HOME . "/.vim/colors/wombat.vim")
    colorscheme wombat
else
    colorscheme desert
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set history=50 " keep 50 lines of command line history
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
let &guioptions = substitute(&guioptions, "t", "", "g")

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        " Also don't do it when the mark is in the first line, that is the default
        " position when opening a file.
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif

    augroup END

else

    set autoindent " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

" Update the path with the dir where we opened Vim
set path=.,$PWD/**
" Now that we set the path to be recursive, disable
" the option that looking for completion in included files.
" Indeed, it can slow the process hard. We use tags instead.
set complete-=i

" Allow editing everywhere
set virtualedit=all

" No bells
set errorbells
set novisualbell
set vb t_vb=

" Show status bar
set laststatus=2

" Highlight current line
set cursorline

" Add visible lines when start or end of the screen (3 lines)
set scrolloff=3

" Backup
set nobackup

" No preview in ins-completion.
set completeopt=menu

" Commands completion on status line.
set wildmenu

" Don't redraw while executing macros
set lazyredraw

" K = :help
set keywordprg=

" Diff always vertical
set diffopt=vertical

" Use utf-8
set encoding=utf-8
set fileencoding=utf-8

"""""""""""""""""
" Developpement "
"""""""""""""""""

" Line numbers
set nu

" Tabulation of 4 spaces
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Show when a line exceeds 80 chars
highlight Overlength ctermbg=red ctermfg=white guibg=#592929
au BufWinEnter * match Overlength /\%81v.*/

" Highlight Tabs and Spaces
" highlight Tab ctermbg=darkgray guibg=darkgray
" au BufWinEnter * let w:m2=matchadd('Tab', '/[^\t]\zs\t\+/', -1)
highlight Space ctermbg=darkblue guibg=darkblue
au BufWinEnter * let w:m3=matchadd('Space', '\s\+$\| \+\ze\t', -1)
set list listchars=tab:\ \ ,trail:.

" Matches are memory greedy, shut them when the window is left
" Mybe it is redondant.
autocmd BufWinLeave * call clearmatches()

" Special indentation for switch / case
" Indentation when in unclosed (.
set cino=l1,(0

" Load Doxygen syntax
let g:load_doxygen_syntax=1

"""""""""""""""""
" Taglist
"""""""""""""""""
let Tlist_Use_Right_Window=1

"""""""""""""""""
" cscope
"""""""""""""""""
if has("cscope") && executable("cscope") && !has("gui_win32")
    set csto=0
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    " abbreviations
    cnoreabbrev csf cs find
    set csverb
endif

"""""""""""""
"  Mapping  "
"""""""""""""

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" After repeating command, return where we were.
map . .`[

" Switch tab.
noremap <A-h> gT
noremap <A-l> gt
" For dummy terminals
noremap <Esc>h gT
noremap <Esc>l gt

" Remap the Esc command
inoremap kj <Esc>
inoremap lk <Esc>

" omnicompletion : words
inoremap <leader>, <C-x><C-o>

" Build C symbols.
function! BuildSymbols()
    if has("cscope") && executable("cscope") && !has("gui_win32")
        " kill all connection.
        execute "cs kill -1"
        execute "!ctags -R && cscope -Rb"
        execute "cs add cscope.out"
    else
        execute "!ctags -R"
    endif
endfunction

" Build symbols with F2.
nnoremap <F2> :call BuildSymbols()<CR>

" Taglist with F3
nnoremap <F3> :TlistToggle<CR>

" Open a explorer on a vertical split of 26.
nnoremap <F4> :26Vexplore<CR>

" When you forgot to open the file as sudo.
cmap w!! %!sudo tee > /dev/null %

