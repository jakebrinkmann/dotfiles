" (default is 4000 ms = 4 s)
set updatetime=50
" Highlight current cursor-line
set cursorline
" Line Numbers
set number
" Relative to current line
set norelativenumber
set nowrap
" Turn on highlighting search-hits
set hlsearch
" Start searching right away
set incsearch
" always show the status bar
set laststatus=2
" " configure termial title to look like: ~/.v/.vimrc [+]
set title
set titlestring=%{substitute(expand(\"%:~:h\"),\"\\\\(/\\\\.\\\\?.\\\\)[^/]*\",\"\\\\1\",\"g\")}%{\"/\".expand(\"%:t\")}%(\ %a%r%m%)
set titlelen=72
set titleold=
" enable 256 colors
set t_Co=256
set t_ut=
" set splits more naturally
set splitbelow
set splitright
" dont auto-resize windows
set noequalalways
" Set scroll offset so the active line stays towards the center.
set scrolloff=8
set sidescrolloff=5
" merge signcolumn and number column into one
set signcolumn=number
" show matching brackets/parenthesis
set showmatch
" syntax highlighting
syntax on
set synmaxcol=512

" Set the text width to 88 and create a vertical bar in 89th column. Some
" filetypes such as gitcommit have a custom width defined and we use autocmd
" here so our textwidth value takes precedence.
set colorcolumn=89
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Trailing whitespace is an ERROR
match Error /\s\+$/

" Show dots for spaces (listchars)
set list
set listchars=eol:↵,tab:▸\ ,trail:★,precedes:←,extends:→,space:·

" Setup cursor for Windows Terminal
if &term =~ '^xterm'
    " normal mode (blinking block = 0)
    let &t_EI = "\e[1 q"
    " insert mode (steady bar = 6)
    let &t_SI = "\e[6 q"
endif

" Window Resizing
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>
nnoremap <silent> <leader>. :resize +5<CR>
nnoremap <silent> <leader>, :resize -5<CR>
" move through split windows
nnoremap <silent> <leader><Up> :wincmd K<CR>
nnoremap <silent> <leader><Down> :wincmd J<CR>
nnoremap <silent> <leader><Left> :wincmd H<CR>
nnoremap <silent> <leader><Right> :wincmd L<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-l> :wincmd l<CR>
nnoremap <silent> == :wincmd =<CR>
" Re-select visual block after indenting
vnoremap < <gv
vnoremap > >gv
