" === General Settings ===
syntax on                   " Enable syntax highlighting
set nocompatible            " Disable vi compatibility
filetype plugin indent on   " Enable filetype detection, plugins, and indentation
set paste

" === Indentation ===
set autoindent              " Auto-indent new lines
set smartindent             " Enable smart indentation
set expandtab               " Use spaces instead of tabs
set tabstop=3               " Number of spaces per tab
set softtabstop=3           " Number of spaces for editing operations
set shiftwidth=3            " Number of spaces for auto-indentation

" === UI/UX ===
set number                  " Show line numbers
set relativenumber          " Show relative line numbers
set cursorline              " Highlight the current line
set cursorcolumn            " Highlight the current column
set showmatch               " Highlight matching brackets
set scrolloff=5             " Keep 5 lines above/below the cursor
set sidescrolloff=5         " Keep 5 columns to the left/right of the cursor
set wildmenu                " Enable command-line completion
set wildmode=longest:full   " Complete the longest common match
set laststatus=2            " Always show the status line
set showcmd                 " Show partial commands in the status line
set title                   " Set the terminal title

" === Search ===
set ignorecase              " Case-insensitive search
set smartcase               " Case-sensitive search if the query contains uppercase
set incsearch               " Incremental search (search as you type)
set hlsearch                " Highlight search results

" === Performance ===
set lazyredraw              " Don't redraw the screen during macros
set ttyfast                 " Faster terminal rendering

" === Key Mappings ===
let mapleader = ","         " Set the leader key to comma

" Clear search highlights
nnoremap <leader><space> :nohlsearch<CR>

" Save and quit shortcuts
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Move between buffers
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>
