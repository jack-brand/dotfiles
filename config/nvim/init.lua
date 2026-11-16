-- Author: Jack Brand <74jdvb@gmail.com> <https://github.com/jack-brand>
-- Credit: bread <https://github.com/BreadOnPenguins/nvim>

-- Local var access is more efficient than global var access
local vim = vim

vim.g.start_time = vim.fn.reltime()
vim.loader.enable()


-- PLUGINS

local plugmgr_path = vim.fn.stdpath('data') .. '/site/autoload/plug.vim'

if vim.fn.empty(vim.fn.glob(plugmgr_path)) == 1 then
    vim.fn.system({
        'curl', '-fLo', plugmgr_path, '--create-dirs',
        'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    })

    -- Force update Lua module runtime paths
    vim.o.runtimepath = vim.o.runtimepath

    vim.cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
end

local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('blazkowolf/gruber-darker.nvim')  -- colorscheme
Plug('uZer/pywal16.nvim', { ['as'] = 'pywal16' })  -- pywal colorscheme
Plug('nvim-lualine/lualine.nvim')  -- statusline
Plug('nvim-tree/nvim-web-devicons')  -- pretty icons
Plug('folke/which-key.nvim')  -- mappings popup
Plug('romgrk/barbar.nvim')  -- bufferline
Plug('nvim-treesitter/nvim-treesitter')  -- improved syntax
Plug('mfussenegger/nvim-lint')  -- async linter
Plug('nvim-tree/nvim-tree.lua')  -- file explorer
Plug('lewis6991/gitsigns.nvim')  -- git
Plug('numToStr/Comment.nvim')  -- easier comments
Plug('norcalli/nvim-colorizer.lua')  -- color highlight
Plug('ibhagwan/fzf-lua')  -- fuzzy finder and grep
Plug('ron-rs/ron.vim')  -- ron syntax highlighting
Plug('emmanueltouzery/decisive.nvim')  -- view csv files
Plug('nvim-mini/mini.align') -- align text

vim.call('plug#end')


-- THEME

-- Current theme is saved for persistence on restart.
-- Lualine theme is stored separately due to possible naming difference.

local lualine_config

local theme_file = vim.fn.stdpath('config') .. '/current_theme'

_G.load_theme = function()
    local file = io.open(theme_file, 'r')
    if file then
        local colorscheme = file:read('*l')
        local lualine_theme = file:read('*l')
        file:close()
        vim.cmd('colorscheme ' .. colorscheme)
        local config = vim.deepcopy(lualine_config)
        config.options.theme = lualine_theme
        require('lualine').setup(config)
    end
end

local themes = {
    { 'gruber-darker', 'auto' },
    { 'pywal16', 'pywal16-nvim' },
}

local current_theme_index = 1

_G.switch_theme = function()
    current_theme_index = current_theme_index % #themes + 1
    local colorscheme, lualine_theme = unpack(themes[current_theme_index])
    vim.cmd('colorscheme ' .. colorscheme)
    local config = vim.deepcopy(lualine_config)
    config.options.theme = lualine_theme
    require('lualine').setup(config)
    local file = io.open(theme_file, 'w')
    if file then
        file:write(colorscheme .. '\n' .. lualine_theme)
        file:close()
    end
end


-- MAPPINGS / KEYBINDS
-- 'n' => Normal
-- 'i' => Insert
-- 'v' => Visual | Select
-- 'x' => Visual
-- 's' => Select
-- 'o' => Operator-pending
-- 't' => Terminal
-- 'c' => Command-line
-- ''  => Normal | Visual | Select | Operator-pending | Terminal
-- '!' => Insert | Command-line

local function map(mode, key, val, desc)
    vim.keymap.set(mode, key, val, {
        desc = desc,
        noremap = true,
        silent = true
    })
end

local function trim_whitespace()
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
end

vim.api.nvim_create_user_command("TrimWhitespace", trim_whitespace, {})

-- Leader
map('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Buffers
map('n', '<leader>q', '<Cmd>BufferClose<CR>', 'Close buffer')
map('n', '<leader>Q', '<Cmd>BufferClose!<CR>', 'Force close buffer')
map('n', '<S-l>', '<Cmd>bnext<CR>')
map('n', '<S-h>', '<Cmd>bprevious<CR>')

map('', '<AS-h>', '<Cmd>BufferMovePrevious<CR>')
map('', '<AS-l>', '<Cmd>BufferMoveNext<CR>')
map('', '<A-1>', '<Cmd>BufferGoto 1<CR>')
map('', '<A-2>', '<Cmd>BufferGoto 2<CR>')
map('', '<A-3>', '<Cmd>BufferGoto 3<CR>')
map('', '<A-4>', '<Cmd>BufferGoto 4<CR>')
map('', '<A-5>', '<Cmd>BufferGoto 5<CR>')
map('', '<A-6>', '<Cmd>BufferGoto 6<CR>')
map('', '<A-7>', '<Cmd>BufferGoto 7<CR>')
map('', '<A-8>', '<Cmd>BufferGoto 8<CR>')
map('', '<A-9>', '<Cmd>BufferGoto 9<CR>')
map('', '<A-0>', '<Cmd>BufferLast<CR>')
map('', '<A-p>', '<Cmd>BufferPin<CR>')

-- Windows
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

map({ 'i', 't' }, '<C-h>', '<C-\\><C-n><C-w>h')
map({ 'i', 't' }, '<C-j>', '<C-\\><C-n><C-w>j')
map({ 'i', 't' }, '<C-k>', '<C-\\><C-n><C-w>k')
map({ 'i', 't' }, '<C-l>', '<C-\\><C-n><C-w>l')

map('', '<F5>', '<Cmd>resize +2<CR>')
map('', '<F6>', '<Cmd>resize -2<CR>')
map('', '<F7>', '<Cmd>vertical resize +2<CR>')
map('', '<F8>', '<Cmd>vertical resize -2<CR>')

-- Fzf
map('n', '<leader>f', '<Cmd>lua require("fzf-lua").files()<CR>', 'Fuzzy find')
map('n', '<leader>Fh', '<Cmd>lua require("fzf-lua").files({ cwd = "~/" })<CR>', 'Fuzzy find home')
map('n', '<leader>Fc', '<Cmd>lua require("fzf-lua").files({ cwd = "~/.config" })<CR>', 'Fuzzy find config')
map('n', '<leader>Fp', '<Cmd>lua require("fzf-lua").files({ cwd = ".." })<CR>', 'Fuzzy find parent')
map('n', '<leader>Fr', '<Cmd>lua require("fzf-lua").resume()<CR>', 'Fuzzy find last search')
map('n', '<leader>g', '<Cmd>lua require("fzf-lua").grep()<CR>', 'Grep')
map('n', '<leader>G', '<Cmd>lua require("fzf-lua").grep_cword()<CR>', 'Grep under cursor')

-- Csv
map('n', '<leader>ca', function()
    local sep = vim.fn.input('separator=')
    if sep ~= '' then
        require("decisive").align_csv({ csv_separator = sep})
    end
end, 'Align csv')
map('n', '<leader>cA', '<Cmd>lua require("decisive").align_csv_clear({})<CR>', 'Unalign csv')
map('', '[c', '<Cmd>lua require("decisive").align_csv_prev_col()<CR>', 'Csv previous column')
map('', ']c', '<Cmd>lua require("decisive").align_csv_next_col()<CR>', 'Csv next column')

-- Other plugins
map('n', '<leader>t', '<Cmd>NvimTreeToggle<CR>', 'Toggle file tree')
map('n', '<leader>o', '<Cmd>Gitsigns toggle_signs<CR>', 'Toggle git signs')

-- Misc
map('n', '<leader>p', switch_theme, 'Switch theme')
map('n', 'U', '<C-r>', 'Redo')
map('n', '<leader>w', '<Cmd>w<CR>', 'Write')
map('n', '<leader>s', ':%s//g<Left><Left>', 'Replace all')
map('n', '<leader>r', ':%s//gc<Left><Left><Left>', 'Replace all interactive')
map('n', '<leader>x', '<Cmd>!chmod +x %<CR>', 'Make file exectuable')
map('n', '<leader>m', ':!mv % ', 'Move file')
map('n', '<leader>u', 'gx', 'Open link')
map('v', '<leader>i', '=gv', 'Auto-indent')
map('n', '<leader>W', '<Cmd>set wrap!<CR>', 'Toggle line wrap')
map('n', '<leader>y', '<Cmd>%y<CR>', 'Yank buffer')
map('n', '<leader>z', '<Cmd>terminal<CR>', 'Open terminal')
map('t', '<Esc>', '<C-\\><C-n>', 'Exit terminal mode')

-- Diagnostics
map('n', '<leader>d', vim.diagnostic.open_float, 'Diagnostic')
map('n', '[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
map('n', ']d', vim.diagnostic.goto_next, 'Next diagnostic')
map('n', '<leader>l', vim.diagnostic.setloclist, 'Diagnostic list')

-- Run make
map('n', '<leader>k', function()
    local bufdir = vim.fn.expand('%:p:h')
    vim.cmd('lcd ' .. bufdir)
    vim.cmd('!make %')
end, 'Compile file')

-- Toggle relative vs absolute line numbers
map('n', '<leader>n', function()
    if vim.wo.relativenumber then
        vim.wo.relativenumber = false
        vim.wo.number = true
    else
        vim.wo.relativenumber = true
    end
end, 'Toggle relative line nums')


-- OPTIONS

vim.opt.laststatus = 3
vim.opt.ruler = false  -- disable extra numbering
vim.opt.showmode = false  -- not needed due to lualine
vim.opt.showcmd = false
vim.opt.wrap = true
vim.opt.mouse = 'a'  -- enable mouse
vim.opt.clipboard = 'unnamedplus'  -- system clipboard
vim.opt.history = 100
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.cursorline = true  -- highlight current line
vim.opt.ttyfast = true  -- fast scrolling
vim.opt.smoothscroll = true
vim.opt.title = true -- window titlebar
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.smarttab = true
vim.opt.cindent = true
vim.opt.autoindent = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
--vim.opt.foldmethod = 'expr'
--vim.opt.foldlevel = 99  -- disable folding, lower numbers enable
--vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.conceallevel = 0
vim.opt.concealcursor = 'nc'
vim.opt.splitkeep = 'screen'  -- stabilise window open/close
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.list = true
vim.opt.listchars = {
    space = "·",
    tab = "▸ ",
    trail = "·",
    nbsp = "␣",
    extends = "›",
    precedes = "‹",
}
vim.opt.shortmess:append('I')

vim.diagnostic.config({
    signs = false,
})


-- AUTOCMD

-- Close nvim when the last buffer is closed
vim.api.nvim_create_autocmd('BufDelete', {
    callback = function()
        vim.schedule(function()
            local buffers = vim.tbl_filter(function(buf)
                return vim.api.nvim_buf_is_valid(buf)
                    and vim.bo[buf].buflisted
                    and vim.bo[buf].buftype == ''
                    and vim.api.nvim_buf_get_name(buf) ~= ''
            end, vim.api.nvim_list_bufs())

            if #buffers == 0 then
                vim.cmd('quit')
            end
        end)
    end,
})

-- Lint when file is written to
-- `try_lint` without arguments runs the linters defined in `linters_by_ft` for the current filetype on write
vim.api.nvim_create_autocmd('BufWritePost', {
    callback = function()
        require('lint').try_lint()
    end,
})

-- Disable automatic comment on newline
vim.api.nvim_create_autocmd('FileType', {
    callback = function()
        vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
    end,
})

-- Highlight text on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
    vim.highlight.on_yank({ timeout = 300 })
    end,
})

-- Restore cursor position on file open
vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function()
        local line = vim.fn.line('""')
        if line > 1 and line <= vim.fn.line('$') then
            vim.cmd('normal! g""')
        end
    end,
})

-- Startup time
vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        local startuptime = vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))
        vim.g.startup_time_ms = string.format('%.2f ms', startuptime * 1000)
    end,
})

-- Turn off relative line numbers when in the command line
vim.api.nvim_create_autocmd('CmdlineEnter', {
    callback = function()
        if vim.o.nu then
            vim.wo.relativenumber = false
            -- Conditional from https://github.com/rockyzhang24/dotfiles/commit/03dd14b5d43f812661b88c4660c03d714132abcf
            -- Workaround for https://github.com/neovim/neovim/issues/32068
            if not vim.tbl_contains({ '@', '-' }, vim.v.event.cmdtype) then
                vim.cmd 'redraw'
            end
        end
    end,
})
vim.api.nvim_create_autocmd('CmdlineLeave', {
    callback = function()
        if vim.o.nu then
            vim.wo.relativenumber = true
        end
    end,
})

-- Turn off cursor line background highlighting
vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        vim.api.nvim_set_hl(0, 'CursorLine', { bg = 'NONE' })
    end,
})

-- Configure whitespace for specific file types
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'javascript', 'typescript', 'css' },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'go' },
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

-- Configure terminal emulator
vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()
        vim.opt_local.list = false
    end,
})


-- PLUGINS

-- Buffer tabs

vim.g.barbar_auto_setup = false

require('barbar').setup({
    animation = false,

    -- Current/total tabpages indicator (top right corner)
    tabpages = true,

    -- Valid options are 'left' (default), 'previous', and 'right'
    focus_on_close = 'left',

    -- Hide inactive buffers and file extensions.
    -- Other options are `alternate`, `current`, and `visible`.
    hide = { extensions = false, inactive = false },

    icons = {
        buffer_index = false,
        buffer_number = false,
        button = '',
        diagnostics = {
            [vim.diagnostic.severity.ERROR] = { enabled = false, icon = ' ' },
        },
        filetype = { enabled = false },
        gitsigns = {
            added = { enabled = false, icon = '+ ' },
            changed = { enabled = false, icon = '~ ' },
            deleted = { enabled = false, icon = '- ' },
        },
        separator = { left = '▎', right = '' },
        separator_at_end = true,

        -- Configure the icons on the bufferline when modified or pinned.
        -- Supports all base icon options
        modified = { button = '' },
        pinned = { button = '', filename = true },

        -- Configure the icons on the bufferline based on buffer visibility.
        -- Supports all base icon options, plus `modified` and `pinned`.
        alternate = {},
        current = {},
        inactive = {},
        visible = {},
    },

    -- Set the filetypes which barbar will offset itself for
    sidebar_filetypes = {
        -- Use the default values { event = 'BufWinLeave', text = '', align = 'left' }
        NvimTree = true,
        -- Or, specify the text used for the offset
        undotree = {
            text = 'undotree',
            align = 'left',  -- optionally specify an alignment ('left' | 'center' | 'right')
        },
        -- Or, specify the event which the sidebar executes when leaving
        ['neo-tree'] = { event = 'BufWipeout' },
        -- Or, specify all three
        Outline = { event = 'BufWinLeave', text = 'symbols-outline', align = 'right' },
    },
    maximum_length = 20,  -- max buffer name length
})


-- Colorizer

require('colorizer').setup({ '*' }, {
    RGB = true,  -- #RGB hex codes
    RRGGBB = true,  -- #RRGGBB hex codes
    names = false,  -- 'Name' codes like Blue
    RRGGBBAA = true,  -- #RRGGBBAA hex codes
    rgb_fn = true,  -- CSS rgb() and rgba() functions
    hsl_fn = true,  -- CSS hsl() and hsla() functions
    css = true,  -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true,  -- Enable all CSS functions: rgb_fn, hsl_fn
})


-- Colorscheme

require('gruber-darker').setup({
    bold = true,
    invert = {
        signs = false,
        tabline = false,
        visual = false,
    },
    italic = {
        strings = false,
        comments = true,
        operators = false,
        folds = true,
    },
    undercurl = true,
    underline = true,
})


-- Comment

require('Comment').setup({
    -- Add a space b/w comment and the line
    padding = true,
    -- Whether the cursor should stay at its position
    sticky = true,
    -- Lines to be ignored while (un)comment
    ignore = nil,
    -- LHS of toggle mappings in NORMAL mode
    toggler = {
        --Line-comment toggle keymap
        line = 'gcc',
        --Block-comment toggle keymap
        block = 'gb',
    },
    -- LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        -- Line-comment keymap
        line = 'gcc',
        -- Block-comment keymap
        block = 'gb',
    },
    -- LHS of extra mappings
    extra = {
        -- Add comment on the line above
        above = 'gcO',
        -- Add comment on the line below
        below = 'gco',
        -- Add comment at the end of line
        eol = 'gcA',
    },
    -- Keybindings (can be `false`)
    mappings = {
        -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        -- Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
    },
    -- Function to call before comment toggle
    pre_hook = nil,
    -- Function to call after comment toggle
    post_hook = nil,
})


-- Fzf

require('fzf-lua').setup({
    file_icon_padding = ' ',
    -- fzf_bin = ...,
    -- winopts = { ... },  -- UI Options
    -- keymap = { ... },  -- Neovim keymaps / fzf binds
    -- actions = { ... },  -- Fzf 'accept' binds
    -- fzf_opts = { ... },  -- Fzf CLI flags
    -- fzf_colors = { ... },  -- Fzf `--color` specification
    -- hls = { ... },  -- Highlights
    -- previewers = { ... },  -- Previewers options
    -- files = { ... },
    keymap = {
        builtin = {
            -- neovim `:tmap` mappings for the fzf window
            ['<M-Esc>']     = 'hide',  -- `:FzfLua resume` to continue
            ['<F1>']        = 'toggle-help',
            ['<F2>']        = 'toggle-fullscreen',
            -- Only valid with the 'builtin' previewer
            ['<F3>']        = 'toggle-preview-wrap',
            ['<F4>']        = 'toggle-preview',
            -- Rotate preview clockwise/counter-clockwise
            ['<F5>']        = 'toggle-preview-ccw',
            ['<F6>']        = 'toggle-preview-cw',
            -- `ts-ctx` binds require `nvim-treesitter-context`
            ['<F7>']        = 'toggle-preview-ts-ctx',
            ['<F8>']        = 'preview-ts-ctx-dec',
            ['<F9>']        = 'preview-ts-ctx-inc',
            ['<S-Left>']    = 'preview-reset',
            ['<S-down>']    = 'preview-page-down',
            ['<S-up>']      = 'preview-page-up',
            ['<M-S-down>']  = 'preview-down',
            ['<M-S-up>']    = 'preview-up',
        },
        fzf = {
            -- fzf '--bind=' options
            ['ctrl-z']      = 'abort',
            ['ctrl-u']      = 'unix-line-discard',
            ['ctrl-f']      = 'half-page-down',
            ['ctrl-b']      = 'half-page-up',
            ['ctrl-a']      = 'beginning-of-line',
            ['ctrl-e']      = 'end-of-line',
            ['alt-a']       = 'toggle-all',
            ['alt-g']       = 'first',
            ['alt-G']       = 'last',
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ['f3']          = 'toggle-preview-wrap',
            ['f4']          = 'toggle-preview',
            ['shift-down']  = 'preview-page-down',
            ['shift-up']    = 'preview-page-up',
        },
    },
})


-- Git signs

require('gitsigns').setup({
    signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signs_staged = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signs_staged_enable = true,
    signcolumn = false,   -- Toggle with `:Gitsigns toggle_signs`
    numhl = false,  -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false,  -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false,  -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        follow_files = true
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = false,  -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',  -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,  -- `nil` => default
    max_file_length = 40000,
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
})


-- Status line

local diagnostics = {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    sections = { 'error', 'warn' },
    symbols = { error = ' ', warn = ' ' },
    colored = true,
    update_in_insert = false,
    always_visible = false,
    cond = function()
        return vim.bo.filetype ~= 'markdown'
    end,
}

lualine_config = {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { 'alpha', 'dashboard' },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { 'filename' },
        lualine_x = { diagnostics, 'encoding', 'fileformat' },
        lualine_y = { 'filetype' },
        lualine_z = { function() return '%l:%v' end },
    },
    extensions = { 'nvim-tree' },
}

-- Transparency override for old pywal; not needed with pywal16
--vim.api.nvim_set_hl(0, 'lualine_c_normal', { bg = 'none' })
--vim.api.nvim_set_hl(0, 'lualine_c_inactive', { bg = 'none' })
--vim.api.nvim_set_hl(0, 'lualine_x_normal', { bg = 'none' })
--vim.api.nvim_set_hl(0, 'lualine_x_inactive', { bg = 'none' })



-- Linting

local lint = require('lint')

lint.linters_by_ft = {
    lua = { 'selene' },
    python = { 'ruff', 'ty' },
    sh = { 'bash' },
    c = { 'cppcheck' },
    html = { 'htmlhint' },
    javascript = { 'quick-lint-js' },
    typescript = { 'quick-lint-js' },
}

lint.linters.ty = {
    cmd = 'ty',
    stdin = false,
    args = { 'check', '--output-format', 'concise', '--no-progress' },
    stream = 'stdout',
    ignore_exitcode = true,
    parser = require('lint.parser').from_errorformat(
        '%f:%l:%c: %m',
        { source = 'ty', severity = vim.diagnostic.severity.ERROR }
    ),
}

for ft, names in pairs(lint.linters_by_ft) do
    for _, name in ipairs(names) do
        if not lint.linters[name] then
            vim.notify(('Linter "%s" for %s is not registered'):format(name, ft), vim.log.levels.WARN)
        end
    end
end

-- Some linters must be installed with vim-plug.
-- Some linters require a file to be saved to disk, while
-- others support stdin input. For stdin linters, you can
-- define a more aggressive autocmd, e.g. on InsertLeave or
-- TextChanged.
-- To get the filetype of a buffer, run := vim.bo.filetype.


-- Directory tree

-- Use `g?` for bindings help while in tree

require('nvim-tree').setup({
    renderer = {
    -- In some terminal emulators, some patched fonts cut off glyphs if not given extra space.
    -- To fix this, add extra space, disable icons, or change font.
        icons = {
            show = {
                file = false,
                folder = false,
                folder_arrow = true,
                git = true,
            },
        },
    },
    view = {
        width = 25,
        side = 'left',
    },
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_cwd = true,
    update_focused_file = {
        enable = true,
        update_cwd = true,
        update_root = true,
    },
})

vim.g.nvim_tree_respect_buf_cwd = 1


-- Treesitter

local treesitter = require('nvim-treesitter')

local languages = { 'bash', 'c', 'css', 'cpp', 'fortran', 'go', 'html', 'java', 'javascript', 'json', 'lua', 'markdown', 'markdown_inline', 'python', 'rust', 'tsx', 'typescript' }

treesitter.setup()

treesitter.install(languages)

vim.api.nvim_create_autocmd('FileType', {
    pattern = languages,

    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
    end,
})


-- Keymap popup

require('which-key').add({
    { '<leader>F', group = 'Fuzzy find' },
    { '<leader>c', group = 'Csv' },
})


-- Align text

require('mini.align').setup()


load_theme()
