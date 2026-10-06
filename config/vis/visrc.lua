-- Author: Jack Brand <74jdvb@gmail.com> <https://github.com/jack-brand>
-- Credit: dacctal <dacctal@symlinx.net> <https://git.symlinx.net>

require('vis')


-- Config --

    local leader = " "

-- Global
vis.events.subscribe(vis.events.INIT, function()
    vis:command("set theme gruber_darker")
end)

-- Per-window
vis.events.subscribe(vis.events.WIN_OPEN, function(win)
    vis:command("set tabwidth 4")
    vis:command("set numbers true")
    vis:command("set relativenumbers true")
    vis:command("set autoindent true")
    vis:command("set showspaces true")
    vis:command("set showtabs true")
    vis:command("set expandtab true")
    vis:command("set shell /usr/bin/env sh")
    vis:map(vis.modes.NORMAL, leader .. "y", '"+y')
    vis:map(vis.modes.VISUAL, leader .. "y", '"+y')
    vis:map(vis.modes.NORMAL, leader .. "p", '"+p')
    vis:map(vis.modes.VISUAL, leader .. "p", '"+p')
    vis:map(vis.modes.VISUAL, leader .. "d", '"+d')
end)


-- External plugins

-- cf. <https://github.com/martanne/vis/wiki/Plugins>
-- cf. <https://erf.github.io/vis-plugins>

local vis_dir = (os.getenv('XDG_CONFIG_HOME') or (os.getenv('HOME') .. '/.config')) .. '/vis'

function clone_and_require(repo)
    local plugin_name = 'plugins/' .. repo:match('([^/]+)$')
    local path = vis_dir .. '/' .. plugin_name
    if not os.execute('[ -d ' .. shellescape(path .. '/.git') .. ' ]') then
        os.execute(
            'git clone --depth=1 https://' .. repo .. ' ' .. shellescape(path)
        )
    end
    return require(plugin_name)
end

function plugin_update()
    local plugin_list = io.popen(
        'find ' .. shellescape(vis_dir .. '/plugins') .. ' -mindepth 1 -maxdepth 1 -type d -print'
    )
    if not plugin_list then
        print('ERROR: PluginUpdate: Could not enumerate plugins')
        return
    end
    for path in plugin_list:lines() do
        if os.execute('[ -d ' .. shellescape(path .. '/.git') .. ' ]') then
            local plugin_name = path:match('([^/]+)$')

            print('INFO: PluginUpdate: Updating ' .. plugin_name .. '...')

            local ok = os.execute(
                'git -C ' .. shellescape(path) .. ' pull --ff-only'
            )

            if not ok then
                print('ERROR: PluginUpdate: Failed to update ' .. plugin_name)
            end
        end
    end
    plugin_list:close()
end

vis:command_register('PluginUpdate', plugin_update)

local modal_colors = clone_and_require('git.symlinx.net/vis-modal')

-- local autoclose = clone_and_require('codeberg.org/luxanna/vis-autoclose')

local follow_link = clone_and_require('git.sr.ht/~mcepl/vis-jump')

local goto_file = clone_and_require('repo.or.cz/vis-goto-file.git')

local fzf_open = clone_and_require('git.sr.ht/~mcepl/vis-fzf-open')
fzf_open.fzf_path = "FZF_DEFAULT_COMMAND='rg --files --hidden --glob \"!.git/*\"' fzf"
fzf_open.fzf_args = "--multi --wrap --height=50% --preview='bat --style-numbers --color=always {}'"
vis.events.subscribe(vis.events.INIT, function()
    vis:command('map! normal <D-p> :fzf<Enter>')  -- super+p
end)

local commentary = clone_and_require('github.com/Nomarian/vis-commentary')

local colorizer = clone_and_require('github.com/thimc/vis-colorizer')
colorizer.three = false
colorizer.six = true

local lsp = clone_and_require('gitlab.com/muhq/vis-lspc')

lsp.logging = true

lsp.highlight_diagnostics = true

lsp.ls_map.c = {
    name = 'clangd',
    cmd = 'clandg --background-index',
}

lsp.ls_map.cpp = {
    name = 'clangd',
    cmd = 'clandg --background-index',
}

lsp.ls_map.rust = {
    name = 'rust_analyzer',
    cmd = 'rust-analyzer',
    roots = {'Cargo.toml'},
}

lsp.ls_map.fortran = {
    name = 'fortls',
    cmd = 'fortls',
}

lsp.ls_map.markdown = {
    name = 'marksman',
    cmd = 'marksman server',
    syncInit = true,
}

lsp.ls_map.html = {
    name = 'superhtml',
    cmd = 'superhtml lsp',
}

lsp.ls_map.tex = {
    name = 'texlab',
    cmd = 'texlab',
}

lsp.ls_map.toml = {
    name = 'taplo',
    cmd = 'taplo',
}

lsp.ls_map.bib = {
    name = 'citation-langserver',
    cmd = 'citation-langserver',
}

lsp.ls_map.quarto = {
    name = 'ltex-ls-plus',
    cmd = 'ltex-ls-plus',
}

lsp.ls_map.rst = {
    name = 'ltex-ls-plus',
    cmd = 'ltex-ls-plus',
}

lsp.ls_map.org = {
    name = 'ltex-ls-plus',
    cmd = 'ltex-ls-plus',
}

lsp.ls_map.typst = {
    name = 'ltex-ls-plus',
    cmd = 'ltex-ls-plus',
}

lsp.ls_map.asciidoc = {
    name = 'ltex-ls-plus',
    cmd = 'ltex-ls-plus',
}

lsp.ls_map.javascript = {
    name = 'quick-lint-js',
    cmd = 'quick-lint-js --lsp-server',
}

lsp.ls_map.mma = {
    name = 'wolfram',
    cmd = 'WolframKernel -noinit -noprompt -nopaclet -nostartuppaclets -noicon '
    .. '-run \'Needs["LSPServer`"];LSPServer`StartServer[]\'',
}


-- Local plugins

local complete_filename = require('plugins/complete-filename')
