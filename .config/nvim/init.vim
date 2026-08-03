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
set termguicolors
set rtp+=/opt/homebrew/opt/fzf

" Render whitespace, matching Cursor's editor.renderWhitespace = "all".
" Colour comes from hl-Whitespace, which catppuccin sets to surface1 (#45475a) —
" already dimmer than Comment, so the dots stay faint.
set list
set listchars=tab:→\ ,space:·,trail:·,nbsp:␣

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
Plug 'nvim-tree/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'catppuccin/nvim', { 'as': 'catppuccin-mocha' }
call plug#end()

" Set colorscheme
colorscheme catppuccin-mocha

" Airline: minimal. Branch and git hunks live in the tmux bar, the file path
" lives in the bufferline, so the statusline only carries mode, buffer name,
" diagnostics and cursor position.
let g:airline_section_b = ''
let g:airline_section_c = '%t%m'
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline_section_z = '%l:%v'
let g:airline_skip_empty_sections = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#nvimlsp#enabled = 1
let g:airline#extensions#bufferline#enabled = 0

" Bufferline
set showtabline=2
lua << EOF
require('bufferline').setup({
  options = {
    diagnostics = 'nvim_lsp',
    separator_style = 'thin',
    show_buffer_close_icons = false,
    offsets = { { filetype = 'nerdtree', text = 'Files', highlight = 'Directory' } },
  },
})
EOF

nnoremap <silent> ]b <cmd>BufferLineCycleNext<cr>
nnoremap <silent> [b <cmd>BufferLineCyclePrev<cr>
nnoremap <silent> <leader>bp <cmd>BufferLinePick<cr>
nnoremap <silent> <leader>bd <cmd>bdelete<cr>
nnoremap <silent> <leader>1 <cmd>BufferLineGoToBuffer 1<cr>
nnoremap <silent> <leader>2 <cmd>BufferLineGoToBuffer 2<cr>
nnoremap <silent> <leader>3 <cmd>BufferLineGoToBuffer 3<cr>
nnoremap <silent> <leader>4 <cmd>BufferLineGoToBuffer 4<cr>
nnoremap <silent> <leader>5 <cmd>BufferLineGoToBuffer 5<cr>

" Key mappings
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fs <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
nnoremap <leader>fd <cmd>Telescope diagnostics<cr>

" LSP
lua << EOF
-- gopls ships semantic tokens disabled by default; without them Go files fall
-- back to the coarse regex syntax file (strings and blocks only).
vim.lsp.config('gopls', {
  settings = {
    gopls = {
      semanticTokens = true,
    },
  },
})

vim.lsp.enable({ 'gopls', 'rust_analyzer' })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, opts)
  end,
})

-- Format and organise imports on save for Go
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 2000 })
    local params = vim.lsp.util.make_range_params(0, 'utf-16')
    params.context = { only = { 'source.organizeImports' } }
    local results = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 2000)
    for _, res in pairs(results or {}) do
      for _, action in pairs(res.result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, 'utf-16')
        end
      end
    end
  end,
})
EOF

" Tmux navigation mappings
nnoremap <C-h> :TmuxNavigateLeft<CR>
nnoremap <C-j> :TmuxNavigateDown<CR>
nnoremap <C-k> :TmuxNavigateUp<CR>
nnoremap <C-l> :TmuxNavigateRight<CR>
