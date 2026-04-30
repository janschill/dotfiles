let mapleader = " "

" Basic settings
set number
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set mouse=a
set clipboard+=unnamedplus
set rtp+=/opt/homebrew/opt/fzf

" Plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ThePrimeagen/vim-be-good'
Plug 'christoomey/vim-tmux-navigator'
Plug 'catppuccin/nvim', { 'as': 'catppuccin-mocha' }
call plug#end()

" Set colorscheme
colorscheme catppuccin-mocha

" Key mappings
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>

" Tmux navigation mappings
nnoremap <C-h> :TmuxNavigateLeft<CR>
nnoremap <C-j> :TmuxNavigateDown<CR>
nnoremap <C-k> :TmuxNavigateUp<CR>
nnoremap <C-l> :TmuxNavigateRight<CR>
