try
    colorscheme gruvbox
catch
    colorscheme desert
endtry
set background=dark
set noshowmode

" ======================================================================================
" ┏━┓╺┳╸┏━┓╺┳╸╻ ╻┏━┓╻  ╻┏┓╻┏━╸
" ┗━┓ ┃ ┣━┫ ┃ ┃ ┃┗━┓┃  ┃┃┗┫┣╸
" ┗━┛ ╹ ╹ ╹ ╹ ┗━┛┗━┛┗━╸╹╹ ╹┗━╸
" github.com/xero/dotfiles
let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'active': {
  \   'left': [ [ 'filename' ],
  \             [ 'linter',  'gitbranch' ] ],
  \   'right': [ [ 'percent', 'lineinfo' ],
  \              [ 'fileencoding', 'filetype' ] ]
  \ },
  \ 'inactive': { 'left': [['filename']] },
  \ 'component_function': {
  \   'modified': 'WizMod',
  \   'readonly': 'WizRO',
  \   'gitbranch': 'WizGit',
  \   'filename': 'WizName',
  \   'filetype': 'WizType',
  \   'fileencoding': 'WizEncoding',
  \   'mode': 'WizMode',
  \ },
  \ 'component_expand': {
  \   'linter': 'WizErrors',
  \ },
  \ 'component_type': {
  \   'readonly': 'error',
  \   'linter': 'error'
  \ },
  \ 'separator': { 'left': '▊▋▌▍▎', 'right': '▎▍▌▋▊' },
  \ 'subseparator': { 'left': '▏', 'right': '▕' }
  \ }

function! WizMod()
  return &ft =~ 'help\|vimfiler' ? '' : &modified ? '» ' : &modifiable ? '' : ''
endfunction

function! WizRO()
  return &ft !~? 'help\|vimfiler' && &readonly ? ' ' : ''
endfunction

function! WizGit()
  return !IsTree() ? exists('*fugitive#head') || exists('*FugitiveHead') ? fugitive#head() : '' : ''
endfunction

function! WizName()
  return !IsTree() ? ('' != WizRO() ? WizRO() : WizMod()) . ('' != expand('%:t') ? expand('%:t') : '[none]') : ''
endfunction

function! WizType()
  return winwidth(0) > 70 ? (strlen(&filetype) ? ' ' . &filetype : '') : ''
endfunction

function! WizEncoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &enc : &enc) : ''
endfunction

function! WizErrors() abort
  let l:counts = exists('*ale#statusline#Count') ? ale#statusline#Count(bufnr('')) : 0
  return l:counts.total == 0 ? '' : printf('◉ %d', l:counts.total)
endfunction

function! IsTree()
  let l:name = expand('%:t')
  return l:name =~ 'NetrwTreeListing\|undotree' ? 1 : 0
endfunction

" augroup alestatus
"     au!
"     autocmd User ALELint call lightline#update()
" augroup end
" ======================================================================================

" Enable persistent undo.
if has('persistent_undo') && !isdirectory(expand('~').'/.vim/undodir')
  silent !mkdir ~/.vim/undodir > /dev/null 2>&1
elseif has('persistent_undo')
  set undodir=~/.vim/undodir undofile
endif
set noswapfile
set nobackup

" hide gitignored files from netrw <- Doesn't work for me :(
" let g:netrw_list_hide= netrw_gitignore#Hide()
" define what a hidden file is
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'
" hide hidden by default
let g:netrw_hide = 1
" directory banner is mostly useless
let g:netrw_banner = 0
" tree list view
let g:netrw_liststyle = 3
" open files in current pane
let g:netrw_browse_split = 0
" width of the directory explorer
let g:netrw_winsize = 25

" Netrw comes with lots of mappings that can lead to unintentional, accidental
" changes. We will unmap everything and map only the functions that we need.
function! NetrwMapping()
    mapclear <buffer>
    " Ctrl-R to refresh listing
    nnoremap <silent><nowait><buffer> <C-R>
                \ :call netrw#Call('NetrwRefresh', 1,
                \                  netrw#Call('NetrwBrowseChgDir', 1, './'))<CR>
    " Left to go up the directory tree
    nnoremap <silent><nowait><buffer> <Left>
                \ :call netrw#Call('NetrwBrowseUpDir', 1)<CR>
    " Right||Enter to open a directory
    nnoremap <silent><nowait><buffer> <Right>
                \ :call netrw#LocalBrowseCheck(netrw#Call('NetrwBrowseChgDir', 1,
                \                              netrw#Call('NetrwGetWord')))<CR>
    nmap <silent><nowait><buffer> <CR> <Right>
    " o to create a new file
    nnoremap <silent><nowait><buffer> o
                \ :call netrw#Call('NetrwOpenFile', 1)<CR>
    " d to make a new directory
    nnoremap <silent><nowait><buffer> d
                \ :call netrw#Call('NetrwMakeDir', "")<CR>
    " D||Delete to delete
    nnoremap <silent><nowait><buffer> D
                \ :call netrw#Call('NetrwLocalRm', b:netrw_curdir)<CR>
    nmap <silent><nowait><buffer> <DEL> D
    " P to open in previous window
    nnoremap <silent><nowait><buffer> P
                \ :call netrw#Call('NetrwPrevWinOpen', 1)<CR>
    " . to toggle showing hidden files
    nnoremap <silent><nowait><buffer> .
                \ :call netrw#Call('NetrwHidden', 1)<CR>
endfunction
augroup netrw_mappings
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup end

" Configure ALE Linters and Fixers
let g:ale_linters = {
    \'python': ['flake8'],
    \'javascript': ['eslint']
\}
" $ cat ~/.config/flake8
" [flake8]
" max-line-length=88
let g:ale_fixers = {
    \'*': ['remove_trailing_lines', 'trim_whitespace'],
    \'python': ['black', 'isort'],
    \'javascript': ['eslint'],
    \'css': ['eslint']
\}
let g:ale_python_isort_options = '--multi-line=3 --trailing-comma --use-parentheses --line-width=88'
" Only run linters when specified
let g:ale_linters_explicit = 1
let g:ale_set_loclist = 0
let g:ale_sign_error = "◉"
let g:ale_sign_warning = '•'
let g:ale_sign_info = '⌇'
let g:ale_sign_style_error = g:ale_sign_error
let g:ale_sign_style_warning = g:ale_sign_warning

" Hmmm setting up YCM for python...
let g:ycm_python_interpreter_path = ''
let g:ycm_python_sys_path = []
" Trigger semantic completion
let g:ycm_key_invoke_completion = '<C-Space>'
" Start autocompletion after 4 chars
let g:ycm_min_num_of_chars_for_completion = 4
let g:ycm_min_num_identifier_candidate_chars = 4
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_complete_in_comments = 0
" Don't show YCM's preview window
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0
" Turn off the auto-popup window
let g:ycm_auto_hover = ""
" Auto close preview window
let g:ycm_autoclose_preview_window_after_completion=1
" write YCM error into the console so we can see wtf is going on
let g:ycm_server_use_vim_stdout = 1
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_semantic_triggers = {
    \'css': [ 're!^', 're!^\s+', ': ' ],
    \'html': [ 're!<\/' ],
\}
" select the completion with enter
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" close preview on completion complete
augroup completionhide
  autocmd!
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
augroup end
" To restart YCM: call YcmRestartServer
nnoremap <silent> <leader>gt :YcmCompleter GoTo<CR>

" enable all syntax highlighting
let g:python_highlight_all = 1
" allow for local virtualenvs
let g:virtualenv_directory = $PWD
nnoremap <leader>tv :VirtualEnvActivate .virtualenv<CR>
nnoremap <leader>te :Dotenv .env<CR>
" force vim-test to use pytest
let test#python#runner = 'pytest'
let test#javascript#runner = 'jest'
" could also use "--inspect=9229" for "chrome://inspect" dedicated DevTools
let g:test#javascript#jest#executable =
      \'node inspect node_modules/.bin/jest --runInBand --config ./jest.config.json'
" running tests on different granularities
nmap <silent> <leader>tp :TestNearest --pdb<CR>
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tg :TestVisit<CR>
let test#strategy = "vimterminal"
nnoremap <silent> <leader>tr :TREPLSendLine<CR>
vnoremap <silent> <leader>tr :TREPLSendSelection<CR>

nnoremap <leader>tb :TagbarToggle<CR>
nnoremap <leader>u :UndotreeShow<CR>

if executable('rg')
    let g:rg_derive_root = 'true'
endif

" Search the project
nnoremap <leader>ps :Rg<SPACE>
" Find files
nnoremap <leader>pf :Files<CR>
" Find tracked files
nnoremap <leader>PF :GFiles<CR>
" Make switching buffers easier
nnoremap <Leader>b :Buffers<CR>
" Always enable preview window on the right with 60% width
let g:fzf_preview_window = 'right:60%'

" Ctrl-D to close current buffer (:bufdelete)
nnoremap <silent> <C-d> :Sayonara<CR>
" Ctrl-C to close current window (:close)
nnoremap <silent> <C-c> :Sayonara!<CR>

" speed optimizations
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1
let g:gitgutter_max_signs = 1500
let g:gitgutter_diff_args = '-w'
" custom symbols
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = ':'
highlight clear SignColumn
highlight GitGutterAdd ctermfg=darkgreen
highlight GitGutterChange ctermfg=magenta
highlight GitGutterDelete ctermfg=red
highlight GitGutterChangeDelete ctermfg=red

" Fugitive Mappings
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gf :Gfetch<CR>
nnoremap <leader>gh :Ghdiffsplit<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>go :diffget<SPACE>
nnoremap <leader>gp :diffput<SPACE>
nnoremap <leader>gl :GV<SPACE>

" Make a new terminal window
set shell=bash\ -l
nnoremap <leader>tt :botright terminal<CR>
tnoremap <silent> <C-x> i
tnoremap <silent> <C-x> <C-\><C-N><CR>
tnoremap <silent> <C-v> <C-W>""<CR>
tnoremap <silent> <C-k> <C-W>k<CR>
tnoremap <silent> <C-j> <C-W>j<CR>
tnoremap <silent> <C-h> <C-W>h<CR>
tnoremap <silent> <C-l> <C-W>l<CR>

" NeoTERM REPLs
nnoremap <leader>tt :Ttoggle<CR>
tnoremap <leader>tt <C-W>:Ttoggle<CR>
let g:neoterm_default_mod = 'botright'
let g:neoterm_autoinsert = 1
let g:neoterm_repl_python =
  \ ['source .virtualenv/bin/activate', 'python']
let g:neoterm_repl_command = add(g:neoterm_repl_python, '')

" Pretty-print JSON
nnoremap =j :%!python3 -m json.tool<CR>
" Pretty-print ALE
nnoremap =a :ALEFix<CR>

" (SHIFT) moves lines and selections in a more visual manner
let g:move_key_modifier='S'

