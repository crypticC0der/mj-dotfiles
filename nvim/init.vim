set guicursor=
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
set foldmethod=syntax

cabbrev bterm bo term
call plug#begin("~/.config/nvim/plugged")
Plug 'junegunn/fzf.vim'
Plug 'jreybert/vimagit'
Plug 'tpope/vim-fugitive'
Plug 'preservim/tagbar'
Plug 'ghifarit53/tokyonight-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'takac/vim-hardtime'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'nvim-lua/completion-nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'terryma/vim-multiple-cursors'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'scrooloose/nerdtree'
Plug 'PhilRunninger/nerdtree-buffer-ops'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-surround'
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


"let g:airline_section_b = airline#section#create(['mode', ' ' ,'branch'] )
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
let g:hardtime_default_on = 1
let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 0
let g:airline_theme = "tokyonight"
set pumheight=20

"autocmd BufEnter * lua require'completion'.on_attach()
lua << EOF
require'lspinstall'.setup()

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
	require'lspconfig'[server].setup{on_attach=require'completion'.on_attach}
end



EOF
colorscheme tokyonight

"keybinds
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>
nmap <Enter> o<Esc>
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
nmap <F8> :TagbarToggle<CR>
nmap <C-a> :MarkdownPreviewToggle<CR>
nmap ; :Files<CR>
map <C-o> :NERDTreeToggle<CR>
nmap <C-s> :split<CR>
nmap <C-v> :vsplit<CR>
nmap <C-t> :tab new<CR> 
nmap <C-u> :set relativenumber!<CR> :set number! <CR>

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c
let g:airline_symbols.dirty ='!'
let g:airline_symbols.notexists='?'

autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
autocmd BufWinEnter * silent NERDTreeMirror

