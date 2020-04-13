if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugin Bundles
call plug#begin('~/.vim/plugged')
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive', { 'tag': 'v2.5' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'HerringtonDarkholme/yats.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'csexton/trailertrash.vim'
Plug 'srcery-colors/srcery-vim'
Plug 'matveyt/vim-modest'
Plug 'dense-analysis/ale'
Plug 'rafi/awesome-vim-colorschemes'
call plug#end()

" let g:deoplete#enable_at_startup = 1
" Ctrl-P Config
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_custom_ignore = 'node_modules\|__pycache__\|DS_Store\|git\|vendor\|dist\|build\|pkgdata\|*.pyc'
let g:ale_virtualtext_cursor = 1
let g:airline_theme='badwolf'
let g:ts_lang_serv = [ 'typescript-language-server', '--stdio' ]
let g:LanguageClient_serverCommands = {
    \ 'typescript': g:ts_lang_serv,
    \ 'typescript.tsx': g:ts_lang_serv,
    \ 'javascript': g:ts_lang_serv,
    \ 'javascript.jsx': g:ts_lang_serv,
    \ }

" Airline Config
set laststatus=2
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F1> :Buffers<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <F3> :call LanguageClient#explainErrorAtPoint()<CR>

colorscheme srcery
syntax on
set showmode                    " always show what mode we're currently editing in
set nowrap                      " don't wrap lines
set tabstop=4                   " a tab is four spaces
set smarttab
set tags=tags
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
set expandtab                   " expand tabs by default (overloadable per file type later)
set shiftwidth=4                " number of spaces to use for autoindenting
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set incsearch           " search as characters are entered
set hlsearch
set showmatch
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set autoindent                  " always set autoindenting on
set copyindent                  " copy the previous indentation on autoindenting
set number                      " always show line numbers
set ignorecase                  " ignore case when searching
set smartcase                   " ignore case if search pattern is all lowercase,
set timeout timeoutlen=200 ttimeoutlen=100
set undofile
set undodir=~/.vimundo/
set buftype=""
set termguicolors
set hidden
