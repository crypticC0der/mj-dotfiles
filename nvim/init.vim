set number
set relativenumber
set nocompatible
syntax on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set autoindent
set smartindent
set ignorecase
set smartcase
"set nohlsearch
set foldmethod=syntax
set clipboard=unnamed,unnamedplus
set foldlevelstart=99

cabbrev bterm bo term
call plug#begin("~/.config/nvim/plugged")
"Plug 'junegunn/fzf.vim'
Plug 'jreybert/vimagit'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'michaeljsmith/vim-indent-object'
Plug 'preservim/tagbar'
Plug 'ghifarit53/tokyonight-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'takac/vim-hardtime'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'scrooloose/nerdtree'
Plug 'PhilRunninger/nerdtree-buffer-ops'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'edkolev/tmuxline.vim'
call plug#end()
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_powerline_fonts = 1 
let g:airline#extensions#vimagit#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers=0
let g:airline#extensions#tabline#show_splits=1
let g:airline#extensions#tabline#show_tabs=1
let g:airline#extensions#tabline#tab_nr_type = 0 " tab number
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#tabs_label = 'T'
let g:hardtime_default_on = 1
let g:hardtime_allow_different_key = 1

nnoremap <Right> :echo "Stop being stupid"<CR>
vnoremap <Right> :<C-u>echo "Stop being stupid"<CR>
inoremap <Right> <C-o>:echo "Stop being stupid"<CR>
nnoremap <Up> :echo "Stop being stupid"<CR>
vnoremap <Up> :<C-u>echo "Stop being stupid"<CR>
inoremap <Up> <C-o>:echo "Stop being stupid"<CR>
nnoremap <Down> :echo "Stop being stupid"<CR>
vnoremap <Down> :<C-u>echo "Stop being stupid"<CR>
inoremap <Down> <C-o>:echo "Stop being stupid"<CR>
nnoremap <Left> :echo "Stop being stupid"<CR>
vnoremap <Left> :<C-u>echo "Stop being stupid"<CR>
inoremap <Left> <C-o>:echo "Stop being stupid"<CR>

if (&tildeop)
  nmap gcw guw~l
  nmap gcW guW~l
  nmap gciw guiw~l
  nmap gciW guiW~l
  nmap gcis guis~l
  nmap gc$ gu$~l
  nmap gcgc guu~l
  nmap gcc guu~l
  vmap gc gu~l
else
  nmap gcw guw~h
  nmap gcW guW~h
  nmap gciw guiw~h
  nmap gciW guiW~h
  nmap gcis guis~h
  nmap gc$ gu$~h
  nmap gcgc guu~h
  nmap gcc guu~h
  vmap gc gu~h
endif


"let g:airline_section_b = airline#section#create(['mode', ' ' ,'branch'] )
set termguicolors
colorscheme tokyonight
let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 0
let g:airline_theme = "tokyonight"
set pumheight=20

"keybinds
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>
nmap <Enter> o<Esc>
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
nmap <F8> :TagbarToggle<CR>
nmap <C-d> :MarkdownPreviewToggle<CR>
map <C-o> :NERDTreeToggle<CR>
nmap <C-s> :split<CR>
nmap <C-v> :vsplit<CR>
nmap <C-t> :tab new<CR> 
nmap <C-_> :noh<CR>

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c
let g:airline_symbols.dirty ='!'
let g:airline_symbols.notexists='?'

autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
   \ quit | endif
autocmd BufWinEnter * silent NERDTreeMirror
augroup RestoreCursorShapeOnExit
   autocmd!
   autocmd VimLeave * set guicursor=a:ver20
augroup END
