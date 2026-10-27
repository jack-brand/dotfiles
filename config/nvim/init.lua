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
Plug('windwp/nvim-autopairs')  -- autopairs
Plug('lewis6991/gitsigns.nvim')  -- git
Plug('numToStr/Comment.nvim')  -- easier comments
Plug('norcalli/nvim-colorizer.lua')  -- color highlight
Plug('ibhagwan/fzf-lua')  -- fuzzy finder and grep
Plug('ron-rs/ron.vim')  -- ron syntax highlighting
Plug('MeanderingProgrammer/render-markdown.nvim')  -- render md inline
Plug('emmanueltouzery/decisive.nvim')  -- view csv files

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

local function map(m, k, v)
	vim.keymap.set(m, k, v, { noremap = true, silent = true })
end

-- Leader
map('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Buffers
map('n', '<S-l>', ':bnext<CR>')
map('n', '<S-h>', ':bprevious<CR>')
map('n', '<leader>q', ':BufferClose<CR>')
map('n', '<leader>Q', ':BufferClose!<CR>')
map('n', '<AS-h>', '<Cmd>BufferMovePrevious<CR>')
map('n', '<AS-l>', '<Cmd>BufferMoveNext<CR>')
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>')
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>')
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>')
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>')
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>')
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>')
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>')
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>')
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>')
map('n', '<A-0>', '<Cmd>BufferLast<CR>')
map('n', '<A-p>', '<Cmd>BufferPin<CR>')

-- Windows
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
map('n', '<F5>', ':resize +2<CR>')
map('n', '<F6>', ':resize -2<CR>')
map('n', '<F7>', ':vertical resize +2<CR>')
map('n', '<F8>', ':vertical resize -2<CR>')

-- Fzf
map('n', '<leader>f', ':lua require("fzf-lua").files()<CR>')  -- search cwd
map('n', '<leader>Fh', ':lua require("fzf-lua").files({ cwd = "~/" })<CR>')  -- search ~
map('n', '<leader>Fc', ':lua require("fzf-lua").files({ cwd = "~/.config" })<CR>')  -- search ~/.config
map('n', '<leader>Fl', ':lua require("fzf-lua").files({ cwd = "~/.local/src" })<CR>')  -- search ~/.local/src
map('n', '<leader>Ff', ':lua require("fzf-lua").files({ cwd = ".." })<CR>')  -- search parent dir
map('n', '<leader>Fr', ':lua require("fzf-lua").resume()<CR>')  -- resume last search
map('n', '<leader>g', ':lua require("fzf-lua").grep()<CR>')  -- grep
map('n', '<leader>G', ':lua require("fzf-lua").grep_cword()<CR>')  -- grep word under cursor

-- Plugins
map('n', '<leader>p', switch_theme)
map('n', '<leader>t', ':NvimTreeToggle<CR>')
map('n', '<leader>gs', ':Gitsigns toggle_signs<CR>')

-- Decisive csv
map('n', '<leader>csa', ':lua require("decisive").align_csv({})<CR>')
map('n', '<leader>csA', ':lua require("decisive").align_csv_clear({})<CR>')
map('n', '[c', ':lua require("decisive").align_csv_prev_col()<CR>')
map('n', ']c', ':lua require("decisive").align_csv_next_col()<CR>')

-- Misc
map('n', 'U', '<C-r>')  -- undo
map('n', '<leader>w', ':w<CR>')  -- write
map('n', '<leader>s', ':%s//g<Left><Left>')  -- replace all
map('n', '<leader>x', '<cmd>!chmod +x %<CR>')  -- make file executable
map('n', '<leader>mv', ':!mv % ')  -- move file
map('n', '<leader>u', ':silent !xdg-open "<cWORD>" &<CR>')  -- open url
map('v', '<leader>i', '=gv')  -- autoindent
map('n', '<leader>W', ':set wrap!<CR>')  -- toggle wrap

-- Run make
map('n', '<leader>mk', function()
	local bufdir = vim.fn.expand('%:p:h')
	vim.cmd('lcd ' .. bufdir)
	vim.cmd('!sudo make uninstall && sudo make clean install %')
end)

-- Toggle relative vs absolute line numbers
map('n', '<leader>n', function()
	if vim.wo.relativenumber then
		vim.wo.relativenumber = false
		vim.wo.number = true
	else
		vim.wo.relativenumber = true
	end
end)


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
vim.opt.shiftwidth = 4
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

-- Close nvim-tree if it's the last buffer open
vim.api.nvim_create_autocmd('BufEnter', {
	pattern = '*',
	callback = function()
		if #vim.api.nvim_list_bufs() == 1 and vim.bo.filetype == 'NvimTree' then
	vim.cmd('quit')
	end
	end,
})

-- Lint when file is written to
vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function()
	-- try_lint without arguments runs the linters defined in `linters_by_ft`
	-- for the current filetype, on write
	require('lint').try_lint()
  end,
})

-- Markdown spellcheck
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'markdown',
	command = 'setlocal spell wrap',
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
		local line = vim.fn.line('"\"')
		if line > 1 and line <= vim.fn.line('$') then
			vim.cmd('normal! g"\"')
		end
	end,
})

vim.api.nvim_create_autocmd('VimEnter', {
	callback = function()
		local startuptime = vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))
		vim.g.startup_time_ms = string.format('%.2f ms', startuptime * 1000)
	end,
})

-- Turn off relative line numbering when in the command line
vim.api.nvim_create_autocmd('CmdlineEnter', {
	group = augroup,
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
   group = augroup,
   callback = function()
	  if vim.o.nu then
		 vim.wo.relativenumber = true
	  end
   end,
})


-- PLUGINS

-- Autopairs

require('nvim-autopairs').setup({
	disable_in_macro = true,  -- disable when recording or executing a macro
	disable_in_visualblock = false,  -- disable when insert after visual block mode
	disable_in_replace_mode = true,
	ignored_next_char = [=[[%w%%%'%[%'%.%`%$]]=],
	enable_moveright = true,
	enable_afterquote = true,  -- add bracket pairs after quote
	enable_check_bracket_line = true,  -- check bracket in same line
	enable_bracket_in_quote = true,
	enable_abbr = false,  -- trigger abbreviation
	break_undo = true,  -- switch for basic rule break undo sequence
	check_ts = false,
	map_cr = true,
	map_bs = true,  -- map the <BS> key
	map_c_h = false,  -- map <C-h> to delete a pair
	map_c_w = false,  -- map <C-w> to delete a pair if possible
})


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
			added = { enabled = false, icon = ' ' },
			changed = { enabled = false, icon = ' ' },
			deleted = { enabled = false, icon = ' ' },
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


-- Colorschemes

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
	-- Function to call before (un)comment
	pre_hook = nil,
	-- Function to call after (un)comment
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
			['<M-Esc>']	 = 'hide',  -- `:FzfLua resume` to continue
			['<F1>']		= 'toggle-help',
			['<F2>']		= 'toggle-fullscreen',
			-- Only valid with the 'builtin' previewer
			['<F3>']		= 'toggle-preview-wrap',
			['<F4>']		= 'toggle-preview',
			-- Rotate preview clockwise/counter-clockwise
			['<F5>']		= 'toggle-preview-ccw',
			['<F6>']		= 'toggle-preview-cw',
			-- `ts-ctx` binds require `nvim-treesitter-context`
			['<F7>']		= 'toggle-preview-ts-ctx',
			['<F8>']		= 'preview-ts-ctx-dec',
			['<F9>']		= 'preview-ts-ctx-inc',
			['<S-Left>']	= 'preview-reset',
			['<S-down>']	= 'preview-page-down',
			['<S-up>']	  = 'preview-page-up',
			['<M-S-down>']  = 'preview-down',
			['<M-S-up>']	= 'preview-up',
		},
		fzf = {
			-- fzf '--bind=' options
			['ctrl-z']	  = 'abort',
			['ctrl-u']	  = 'unix-line-discard',
			['ctrl-f']	  = 'half-page-down',
			['ctrl-b']	  = 'half-page-up',
			['ctrl-a']	  = 'beginning-of-line',
			['ctrl-e']	  = 'end-of-line',
			['alt-a']	   = 'toggle-all',
			['alt-g']	   = 'first',
			['alt-G']	   = 'last',
			-- Only valid with fzf previewers (bat/cat/git/etc)
			['f3']		  = 'toggle-preview-wrap',
			['f4']		  = 'toggle-preview',
			['shift-down']  = 'preview-page-down',
			['shift-up']	= 'preview-page-up',
		},
	},
})


-- Git signs

require('gitsigns').setup({
	signs = {
		add		  = { text = '┃' },
		change	   = { text = '┃' },
		delete	   = { text = '_' },
		topdelete	= { text = '‾' },
		changedelete = { text = '~' },
		untracked	= { text = '┆' },
	},
	signs_staged = {
		add		  = { text = '┃' },
		change	   = { text = '┃' },
		delete	   = { text = '_' },
		topdelete	= { text = '‾' },
		changedelete = { text = '~' },
		untracked	= { text = '┆' },
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

local branch = {
	'branch',
	icon = '',
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

-- Some linters must be installed with vim-plug
require('lint').linters_by_ft = {
	lua = { 'luac' },
	python = { 'ruff' },
	sh = { 'bash' },
	c = { 'cppcheck' },
	rust = { 'clippy' },
	css = { 'stylelint' },
	html = { 'htmlhint' },
}

-- Some linters require a file to be saved to disk, while others support stdin input.
-- For such linters you could also define a more aggressive autocmd,
-- for example on the InsertLeave or TextChanged events.
-- To get the filetype of a buffer you can run := vim.bo.filetype.


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


-- Markdown rendering

require('render-markdown').setup({
	link = {
		enabled = true,
		-- Additional modes to render links
		render_modes = false,
		-- FYI: Footnote links start with '^'
		footnote = {
			enabled = true,
			superscript = true,
			prefix = '',
			suffix = '',
		},
		-- Inlined with 'image' elements
		image = '󰥶 ',
		-- Inlined with 'email_autolink' elements
		email = '󰀓 ',
		-- Fallback icon for 'inline_link' and 'uri_autolink' elements
		hyperlink = '󰌹 ',
		-- Applies to the inlined icon as a fallback
		highlight = 'RenderMarkdownLink',
		-- Applies to WikiLink elements
		wiki = {
			icon = '󱗖 ',
			body = function()
				return nil
			end,
			highlight = 'RenderMarkdownWikiLink',
		},
		-- Define custom destination patterns so icons can quickly inform you of what a link
		-- contains. Applies to 'inline_link', 'uri_autolink', and wikilink nodes. When multiple
		-- patterns match a link the one with the longer pattern is used.
		-- The key is for healthcheck and to allow users to change its values, value type below.
		-- | pattern   | matched against the destination text							|
		-- | icon	  | gets inlined before the link text							   |
		-- | kind	  | optional determines how pattern is checked					  |
		-- |		   | pattern | @see :h lua-patterns, is the default if not set	   |
		-- |		   | suffix  | @see :h vim.endswith()								|
		-- | priority  | optional used when multiple match, uses pattern length if empty |
		-- | highlight | optional highlight for 'icon', uses fallback highlight if empty |
		custom = {
			web = { pattern = '^http', icon = '󰖟 ' },
			github = { pattern = 'github%.com', icon = '󰊤 ' },
			gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
			stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
			wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
			youtube = { pattern = 'youtube%.com', icon = '󰗃 ' },
		},
	},
	callout = {
		-- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'.
		-- The key is for healthcheck and to allow users to change its values, value type below.
		-- | raw		| matched against the raw text of a 'shortcut_link', case insensitive |
		-- | rendered   | replaces the 'raw' value when rendering							 |
		-- | highlight  | highlight for the 'rendered' text and quote markers				 |
		-- | quote_icon | optional override for quote.icon value for individual callout	   |
		-- | category   | optional metadata useful for filtering							  |
		note	  = { raw = '[!NOTE]',	  rendered = '󰋽 Note',	  highlight = 'RenderMarkdownInfo'},
		tip	   = { raw = '[!TIP]',	   rendered = '󰌶 Tip',	   highlight = 'RenderMarkdownSuccess'},
		important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint'},
		warning   = { raw = '[!WARNING]',   rendered = '󰀪 Warning',   highlight = 'RenderMarkdownWarn'},
		caution   = { raw = '[!CAUTION]',   rendered = '󰳦 Caution',   highlight = 'RenderMarkdownError'},
		abstract  = { raw = '[!ABSTRACT]',  rendered = '󰨸 Abstract',  highlight = 'RenderMarkdownInfo'},
		summary   = { raw = '[!SUMMARY]',   rendered = '󰨸 Summary',   highlight = 'RenderMarkdownInfo'},
		tldr	  = { raw = '[!TLDR]',	  rendered = '󰨸 Tldr',	  highlight = 'RenderMarkdownInfo'},
		info	  = { raw = '[!INFO]',	  rendered = '󰋽 Info',	  highlight = 'RenderMarkdownInfo'},
		todo	  = { raw = '[!TODO]',	  rendered = '󰗡 Todo',	  highlight = 'RenderMarkdownInfo'},
		hint	  = { raw = '[!HINT]',	  rendered = '󰌶 Hint',	  highlight = 'RenderMarkdownSuccess'},
		success   = { raw = '[!SUCCESS]',   rendered = '󰄬 Success',   highlight = 'RenderMarkdownSuccess'},
		check	 = { raw = '[!CHECK]',	 rendered = '󰄬 Check',	 highlight = 'RenderMarkdownSuccess'},
		done	  = { raw = '[!DONE]',	  rendered = '󰄬 Done',	  highlight = 'RenderMarkdownSuccess'},
		question  = { raw = '[!QUESTION]',  rendered = '󰘥 Question',  highlight = 'RenderMarkdownWarn'},
		help	  = { raw = '[!HELP]',	  rendered = '󰘥 Help',	  highlight = 'RenderMarkdownWarn'},
		faq	   = { raw = '[!FAQ]',	   rendered = '󰘥 Faq',	   highlight = 'RenderMarkdownWarn'},
		attention = { raw = '[!ATTENTION]', rendered = '󰀪 Attention', highlight = 'RenderMarkdownWarn'},
		failure   = { raw = '[!FAILURE]',   rendered = '󰅖 Failure',   highlight = 'RenderMarkdownError'},
		fail	  = { raw = '[!FAIL]',	  rendered = '󰅖 Fail',	  highlight = 'RenderMarkdownError'},
		missing   = { raw = '[!MISSING]',   rendered = '󰅖 Missing',   highlight = 'RenderMarkdownError'},
		danger	= { raw = '[!DANGER]',	rendered = '󱐌 Danger',	highlight = 'RenderMarkdownError'},
		error	 = { raw = '[!ERROR]',	 rendered = '󱐌 Error',	 highlight = 'RenderMarkdownError'},
		bug	   = { raw = '[!BUG]',	   rendered = '󰨰 Bug',	   highlight = 'RenderMarkdownError'},
		example   = { raw = '[!EXAMPLE]',   rendered = '󰉹 Example',   highlight = 'RenderMarkdownHint' },
		quote	 = { raw = '[!QUOTE]',	 rendered = '󱆨 Quote',	 highlight = 'RenderMarkdownQuote'},
		cite	  = { raw = '[!CITE]',	  rendered = '󱆨 Cite',	  highlight = 'RenderMarkdownQuote'},
	},
	checkbox = {
		enabled = true,
		render_modes = false,
		bullet = false,
		right_pad = 1,
		unchecked = {
			icon = '󰄱 ',
			highlight = 'RenderMarkdownUnchecked',
			scope_highlight = nil,
		},
		checked = {
			icon = '󰱒 ',
			highlight = 'RenderMarkdownChecked',
			scope_highlight = nil,
		},
		custom = {
			todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
		},
	},
	bullet = {
		enabled = true,
		render_modes = false,
		icons = { '●', '○', '◆', '◇' },
		ordered_icons = function(ctx)
			local value = vim.trim(ctx.value)
			local index = tonumber(value:sub(1, #value - 1))
			return ('%d.'):format(index > 1 and index or ctx.index)
		end,
		left_pad = 0,
		right_pad = 0,
		highlight = 'RenderMarkdownBullet',
		scope_highlight = {},
	},
	quote = { icon = '▋' },
	anti_conceal = {
		enabled = true,
		-- Which elements to always show, ignoring anti conceal behavior. Values can either be
		-- booleans to fix the behavior or string lists representing modes where anti conceal
		-- behavior will be ignored. The possible elements are:
		--   head_icon, head_background, head_border, code_language, code_background, code_border,
		--   dash, bullet, check_icon, check_scope, quote, table_border, callout, link, sign
		ignore = {
			code_background = true,
			sign = true,
		},
		above = 0,
		below = 0,
	},
})


-- Treesitter

local treesitter = require('nvim-treesitter')

local languages = { 'bash', 'c', 'css', 'cpp', 'go', 'html', 'java', 'javascript', 'json', 'lua', 'markdown', 'markdown_inline', 'python', 'rust', 'tsx', 'typescript' }

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

local whichkey = require('which-key')
whichkey.add({
	{ '<leader>p', desc = 'toggle theme' },
	{ '<leader>u', desc = 'open url' },
	{ '<leader>f', desc = 'fzf' },
	{ '<leader>g', desc = 'grep' },
	{ '<leader>G', desc = 'grep under cursor' },
	{ '<leader>x', desc = 'chmod +x' },
	{ '<leader>t', desc = 'view files' },
	{ '<leader>w', desc = 'write' },
	{ '<leader>W', desc = 'toggle wrap' },
	{ '<leader>q', desc = 'close buf' },
	{ '<leader>Q', desc = 'close buf!' },
	{ '<leader>n', desc = 'toggle relative nums' },
	{ '<leader>F', desc = 'fzf opts' },
	{ '<leader>mv', desc = 'move file' },
	{ '<leader>mk', desc = 'make' },
	{ '<leader>gs', desc = 'toggle git signs' }
})

load_theme()
