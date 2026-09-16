" .vimrc
" Author: Jack Brand <74jdvb@gmail.com> <https://github.com/jack-brand>
" License: MIT
" Credit: <https://github.com/tonybanters/vim> <https://shapeshed.com/vim-statuslines/>


" Options

set number
set relativenumber
set ignorecase
set smartcase
set clipboard=unnamedplus
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smartindent
set backspace=indent,eol,start
set mouse=a
set shortmess+=I
set ttimeout
set laststatus=2
set noshowmode
set showcmd
set showmatch
set incsearch
set nohlsearch
set endofline
set fixendofline
set list
set listchars=space:·,tab:▸\ ,trail:·,nbsp:␣

filetype plugin indent on
syntax on

" Normal, visual, command line: block
" Insert, command line insert: vertical
" Replace, command line replace: horizontal
set guicursor=n-v-c:block-blinkwait500-blinkon500-blinkoff500,i:ver25-blinkwait500-blinkon500-blinkoff500,r:hor20-blinkwait500-blinkon500-blinkoff500
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

let g:tex_conceal = ''

set clipboard=unnamed,unnamedplus

" Plugins

let s:plugin_dir = expand('~/.config/vim/plugins')

function! s:clone(repo)
    let name = split(a:repo, '/')[-1]
    let path = s:plugin_dir . '/' . name

    if !isdirectory(path)
        if !isdirectory(s:plugin_dir)
            call mkdir(s:plugin_dir, 'p')
        endif
        execute '!git clone --depth=1 https://github.com/' . a:repo . ' ' . shellescape(path)
    endif

    execute 'set runtimepath+=' . fnameescape(path)
endfunction

call s:clone('junegunn/fzf.vim')
call s:clone('yegappan/lsp')
call s:clone('SilentGlasses/colorhighlighter')
call s:clone('ThunderBoltCODMYT/gruber-darker.vim')


" Colours

set termguicolors
colorscheme gruber-darker


" Lsp

" Languages
" cf. https://langserver.org/
" cf. https://microsoft.github.io/language-server-protocol/implementors/servers/
let s:lspServers = [
    \ #{
        \ name: 'rust-analyzer',
        \ filetype: ['rust'],
        \ path: 'rust-analyzer',
        \ args: []
    \ },
    \ #{
        \ name: 'clangd',
        \ filetype: ['c', 'cpp'],
        \ path: 'clangd',
        \ args: ['--background-index']
    \ },
    \ #{
        \ name: 'fortls',
        \ filetype: ['fortran'],
        \ path: 'fortls',
        \ args: []
    \ },
    \ #{
        \ name: 'marksman',
        \ filetype: ['markdown'],
        \ path: 'marksman',
        \ args: ['server'],
        \ syncInit: v:true
    \ },
    \ #{
        \ name: 'superhtml',
        \ filetype: ['html'],
        \ path: 'superhtml',
        \ args: ['lsp']
    \ },
    \ #{
        \ name: 'texlab',
        \ filetype: ['tex'],
        \ path: 'texlab',
        \ args: []
    \ },
    \ #{
        \ name: 'taplo',
        \ filetype: ['toml'],
        \ path: 'taplo',
        \ args: []
    \ },
    \ #{
        \ name: 'ltex-ls-plus',
        \ filetype: ['tex', 'bib', 'quarto', 'rst', 'org', 'typst', 'asciidoc'],
        \ path: 'ltex-ls-plus',
        \ args: []
    \ },
    \ #{
        \ name: 'quick-lint-js',
        \ filetype: ['javascript'],
        \ path: 'quick-lint-js',
        \ args: ['--lsp-server']
    \ },
    \ #{
        \ name: 'citation-langserver',
        \ filetype: ['tex', 'bib'],
        \ path: 'citation-langserver',
        \ args: []
    \ },
    \ #{
        \ name: 'wolfram',
        \ filetype: ['mma'],
        \ path: 'WolframKernel',
        \ args: [
            \ '-noinit',
            \ '-noprompt',
            \ '-nopaclet',
            \ '-nostartuppaclets',
            \ '-noicon',
            \ '-run',
            \ 'Needs["LSPServer`"];LSPServer`StartServer[]'
        \ ]
    \ }
\ ]
autocmd User LspSetup call LspAddServer(s:lspServers)

" Completion
autocmd FileType php setlocal omnifunc=lsp#complete

" Diagnostics
let s:lspOpts = #{
    \ autoHighlightDiags: v:true,
    \ diagSignErrorText: '✘',
    \ diagSignWarningText: '▲',
    \ diagSignInfoText: '»',
    \ diagSignHintText: '⚑',
\ }
autocmd User LspSetup call LspOptionsSet(s:lspOpts)


" Keybinds

let mapleader = " "

" Copy entire buffer
nnoremap ya :%y

" Search current directory in a fzf menu
nnoremap <leader>p :Files<CR>

" Ripgrep search current directory in a fzf menu
nnoremap <leader>rg :Rg<Space>

" Lsp
nnoremap gd :LspGotoDefinition<CR>
nnoremap gr :LspShowReferences<CR>
nnoremap K  :LspHover<CR>
nnoremap gl :LspDiag current<CR>
nnoremap <leader>nd :LspDiag next \| LspDiag current<CR>
nnoremap <leader>pd :LspDiag prev \| LspDiag current<CR>
inoremap <silent> <C-Space> <C-x><C-o>


" Git info

let b:git_branch = ''

function! UpdateGitBranch() abort
    silent let b:git_branch = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\\n'")
endfunction

augroup git_branch
    autocmd!
    autocmd BufEnter,BufWritePost,FocusGained * call UpdateGitBranch()
augroup END


" Status line

function! CurrentMode() abort
    let l:mode = mode(1)

    return get({
        \ 'n':  'N',
        \ 'no': 'N',
        \ 'ni': 'N',
        \ 'v':  'V',
        \ 'V':  'V',
        \ "\<C-V>": 'V',
        \ 's':  'S',
        \ 'S':  'S',
        \ "\<C-S>": 'S',
        \ 'i':  'I',
        \ 'ic': 'I',
        \ 'ix': 'I',
        \ 'R':  'R',
        \ 'Rc': 'R',
        \ 'Rx': 'R',
        \ 'Rv': 'R',
        \ 'c':  'C',
        \ 'cv': 'C',
        \ 'ce': 'C',
        \ 'r':  'P',
        \ 'rm': 'P',
        \ 'r?': 'P',
        \ 't':  'T',
        \ }, l:mode, '?')
endfunction

highlight! link StatusLineMode Tooltip

let s:statusline_mode_bg = synIDattr(synIDtrans(hlID('StatusLineMode')), 'bg#')
let s:statusline_bg = synIDattr(synIDtrans(hlID('StatusLine')), 'bg#')
execute 'highlight StatusLineModeArrow guifg=' . s:statusline_mode_bg . ' guibg=' . s:statusline_bg

set statusline=
set statusline+=%#StatusLineMode#
set statusline+=\ %{CurrentMode()}
set statusline+=\ %#StatusLineModeArrow#
set statusline+=%{nr2char(0xe0b0)}
set statusline+=%#StatusLineNC#
set statusline+=\ %{b:git_branch}
set statusline+=%{b:git_branch!=''?'\ ':''}
set statusline+=%#StatusLine#
set statusline+=%f
set statusline+=%m
set statusline+=%=
set statusline+=%#StatusLineNC#
set statusline+=%{&filetype}
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ %l:%c
