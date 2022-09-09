" Generic options {{{
scriptencoding utf-8
set encoding=utf-8
set foldmethod=marker

if strlen(exepath('rg'))
	set grepprg=rg\ --vimgrep
	set grepformat^=%f%l%c%m
endif

set guifont=FiraCode\ NF:h16
set mouse=a
set nowrap
set number
set relativenumber
set scrolloff=10
set splitbelow
set splitright
set undofile

hi NonText ctermfg=DarkGray guifg=gray
hi SpecialKey ctermfg=DarkGray
set listchars=eol:$,trail:·,tab:»\ ,nbsp:.
"set list

set tabstop=2
set shiftwidth=2
" }}}

" Mappings {{{
let mapleader=","
let maplocalleader=","
imap jj <Esc>
imap jk <Esc>
imap <C-[> <Esc>

nmap <C-h> :wincmd h<CR>
nmap <C-j> :wincmd j<CR>
nmap <C-k> :wincmd k<CR>
nmap <C-l> :wincmd l<CR>
nmap <C-t> :Files<CR>

map <Leader>coc :CocCommand<CR>
map <Leader>es :e $HOME/.vimrc<CR>
map <Leader>fb :Buffers<CR>
map <Leader><Leader> :Buffers<CR>
map <Leader>gc :Gcommit<CR>
map <Leader>gs :Gstatus<CR>
map <Leader>gy :Goyo<CR>
map <Leader>is :set expandtab<CR>
map <Leader>it :set noexpandtab<CR>
map <Leader>ir gg=G<CR>
map <Leader>mk :mksession!<CR>
map <Leader>n :nohlsearch<CR>
map <Leader>nt :new\|term<CR>
map <Leader>p :Prettier<CR>
map <Leader>rr :set relativenumber!<CR>
map <Leader>s :source $MYVIMRC<CR>
map <Leader>tn :tabnew<CR>
map <Leader>tt :CocCommand explorer --position right --width 30<CR>
map <Leader>u :UndotreeToggle<CR>
map <Leader>wa :MatchupWhereAmI??<CR>
map <Leader>wc :set cursorline!<CR>set cursorcolumn!<CR>

"make < > shifts keep selection
vnoremap < <gv
vnoremap > >gv
vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>

function! g:ZF() range
  if (visualmode() != "V")
    normal! zf
    return
  endif

  normal! '<O{{{ld$
  call NERDComment(1, 'comment')
  normal! '>o}}}
  call NERDComment(1, 'comment')
  normal! '<k^l
endfunction

vnoremap <leader>ex :'<,'>call g:ExecuteVisuallySelected()<CR>
function! g:ExecuteVisuallySelected()
  " cat %:p
  let a_orig = @a
  normal! gv"ay
  let term_cmd = ':term ' . join(map(split(@a, '\s\+'), 'expand(v:val)'))
  execute ':new'
  execute term_cmd
  let @a = a_orig
endfunction

vnoremap <leader>o :'<,'>call g:OpenVisuallySelected()<CR>
function! g:OpenVisuallySelected()
  " https://google.com/
  if strlen(exepath('open'))
    let open_cmd = 'open'
  else
    let open_cmd = 'xdg-open'
  endif

  let a_orig = @a
  normal! gv"ay
  execute ':!' . open_cmd . ' ' . @a
  let @a = a_orig
endfunction

nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
" }}}

" Neovim-specific config {{{
if has('nvim')
	autocmd TermOpen * tnoremap <Esc> <C-\><C-n>
	autocmd FileType fzf tunmap <Esc>
	tmap <C-[> <C-\><C-n>
	set inccommand=nosplit
	set wildoptions=pum
	set pumblend=15
	augroup terminal_settings
		autocmd!
		autocmd TermOpen * setlocal nonumber | set norelativenumber | startinsert
  augroup END
endif 
" }}}

" Plug plugins {{{
if has('nvim')
	let plug_dir = '~/.local/share/nvim/plugged'
	if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
		silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
endif

call plug#begin(plug_dir)

Plug 'mhinz/vim-startify'

" git
Plug 'airblade/vim-gitgutter'
Plug 'lambdalisue/gina.vim'

" syntax
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['json', 'javascript', 'markdown', 'yaml']

" color plugins
Plug 'frankier/neovim-colors-solarized-truecolor-only'

Plug 'andymass/vim-matchup'

Plug 'jiangmiao/auto-pairs'
let g:AutoPairsMultilineClose = 0

" CoC
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
let g:coc_global_extensions =[
  \ 'coc-emoji',
  \ 'coc-explorer',
  \ 'coc-json',
  \ 'coc-marketplace',
  \ 'coc-prettier',
  \ 'coc-rust-analyzer',
  \ 'coc-snippets',
  \ 'coc-tsserver',
  \ 'coc-vimlsp',
  \ 'coc-yaml'
  \ ]

" NERDCommenter
Plug 'preservim/nerdcommenter'
let g:NERDSpaceDelims = 1            " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1        " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'      " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDCommentEmptyLines = 1      " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1 " Enable trimming of trailing whitespace when uncommenting
let g:NERDToggleCheckAllLines = 1    " Enable NERDCommenterToggle to check all selected lines is commented or not

Plug 'scrooloose/nerdtree'
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden = 1

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'
let g:airline_solarized_bg = 'dark'

Plug 'vimwiki/vimwiki'
let g:vimwiki_folding = 'expr'
let g:vimwiki_list = [{'path': '~/Sync/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

Plug 'christoomey/vim-tmux-navigator'
Plug 'diepm/vim-rest-console'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
let g:fzf_preview_window = ''
Plug 'junegunn/goyo.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'mbbill/undotree'
Plug 'matze/vim-move' " Alt+hjkl to move lines/selections around
Plug 'prettier/vim-prettier', {
      \ 'do': 'yarn install',
      \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue'] }
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-sleuth' " heuristically set buffer options
Plug 'tpope/vim-surround'

call plug#end()
" }}}

" Auto-Commands {{{
augroup filetypedetect
  autocmd BufNewFile,BufRead Dockerfile.* set filetype=Dockerfile
  autocmd BufRead,BufNewFile *.jsx set filetype=javascript.jsx
  autocmd BufRead,BufNewFile *.tsx set filetype=typescript.tsx
  autocmd BufRead,BufNewFile *.md,*.txt map <buffer> <LocalLeader>p :%!fold -w 80 -s<CR>
  autocmd FileType rust map <buffer> <LocalLeader>p :RustFmt<CR>
  autocmd FileType rust :compiler cargo
  autocmd FileType xml map <buffer> <LocalLeader>p :FormatXML<CR>
augroup END

" auto-refresh buffers if contents change on disk
augroup auto_checktime
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold * silent! checktime
augroup end
" }}}

" Commands {{{
command! FormatXML :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
command! Check execute 'silent make check --bins --tests | cwindow'
command! -nargs=+ Grep execute 'silent grep! <args>' | cwindow
command! -nargs=+ CargoAdd execute '-1r!cargo search <args> | head -n1'
command! Messages execute '7new|0pu=execute(''messages'')|g/^$/normal! dd'
command! -nargs=+ Tn execute ':tabnew <args>'
" }}}

" CoC Config {{{
function InitCocConfig()
  " if hidden is not set, TextEdit might fail.
  set hidden

  " Some servers have issues with backup files, see #649
  set nobackup
  set nowritebackup

  " You will have bad experience for diagnostic messages when it's default 4000.
  set updatetime=300

  " don't give |ins-completion-menu| messages.
  set shortmess+=c

  " always show signcolumns
  set signcolumn=yes

  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " Use `[c` and `]c` to navigate diagnostics
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)

  " Remap for format selected region
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap for do codeAction of current line
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
  nmap <silent> <TAB> <Plug>(coc-range-select)
  xmap <silent> <TAB> <Plug>(coc-range-select)
  xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

  " Use `:Format` to format current buffer
  command! -nargs=0 Format :call CocAction('format')

  " Use `:Fold` to fold current buffer
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " use `:OR` for organize import of current buffer
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Coc: use prettier to format files:
  command! -nargs=0 Prettier :CocCommand prettier.formatFile
  vmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)
  " Add status line support, for integration with other plugin, checkout `:h coc-status`
  " set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Using CocList
  " Show all diagnostics
  nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
  " Show commands
  nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document
  nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols
  " nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list
  " nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
endfunction
call InitCocConfig()
" }}}

" Theming/colors {{{
if (has("termguicolors"))
  set termguicolors
endif

syntax enable
filetype plugin on
set background=dark
colorscheme solarized
" }}}
