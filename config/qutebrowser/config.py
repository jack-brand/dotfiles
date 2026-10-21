# Credit:
#    bread <https://github.com/BreadOnPenguins/dots>
#    Tanner Babcock <https://gitlab.com/Babkock/Dotfiles>

# Colours
# Format: '#aarrggbb' | '#rrggbb' | '<ansi_color_name>'

black = '#181818'
red = '#f43841'
green = '#73c936'
yellow = '#ffdd33'
blue= '#96a6c8'
magenta = '#9e95c7'
cyan = '#95a99f'
white= '#e4e4ef'
brightblack = '#453d41'
brightred = '#ff4f58'
brightgreen = '#73c936'
brightyellow = '#ffdd33'
brightblue = '#96a6c8'
brightmagenta = '#9e95c7'
brightcyan = '#95a99f'
brightwhite = '#f5f5f5'

brown = '#cc8c3c'
darkyellow = '#423d21'

# BUG: webpage.bg must be fully opaque or fully transparent
c.colors.webpage.bg = '#00181818'

c.colors.statusbar.normal.bg = '#00000000'
c.colors.statusbar.normal.fg = cyan
c.colors.statusbar.command.bg = '#00000000'
c.colors.statusbar.command.fg = white
c.colors.statusbar.passthrough.bg = '#00000000'
c.colors.statusbar.passthrough.fg = cyan
c.colors.statusbar.private.bg = '#00000000'
c.colors.statusbar.private.fg = cyan
c.colors.statusbar.caret.fg = yellow
c.colors.statusbar.caret.selection.bg = darkyellow
c.colors.statusbar.progress.bg = '#00000000'
c.colors.statusbar.url.fg = brightmagenta
c.colors.statusbar.url.hover.fg = brightblue
c.colors.statusbar.url.success.http.fg = brightmagenta
c.colors.statusbar.url.success.https.fg = brightmagenta
c.colors.statusbar.url.warn.fg = brown
c.colors.statusbar.url.error.fg = red

c.colors.tabs.bar.bg = '#00000000'
c.colors.tabs.even.bg = '#00000000'
c.colors.tabs.odd.bg = '#00000000'
c.colors.tabs.even.fg = black
c.colors.tabs.odd.fg = black
c.colors.tabs.selected.even.bg = black
c.colors.tabs.selected.odd.bg = black
c.colors.tabs.selected.even.fg = white
c.colors.tabs.selected.odd.fg = white
c.colors.tabs.indicator.start = brightgreen
c.colors.tabs.indicator.stop = brightblack
c.colors.tabs.indicator.error = red
c.colors.tabs.pinned.even.bg = black
c.colors.tabs.pinned.even.fg = white
c.colors.tabs.pinned.odd.bg = black
c.colors.tabs.pinned.odd.fg = white
c.colors.tabs.pinned.selected.even.bg = black
c.colors.tabs.pinned.selected.even.fg = white
c.colors.tabs.pinned.selected.odd.bg = black
c.colors.tabs.pinned.selected.odd.fg = black

c.colors.hints.bg = black
c.colors.hints.fg = white
c.hints.border = white
c.colors.hints.match.fg = brightwhite
c.colors.keyhint.bg = black
c.colors.keyhint.fg = white
c.colors.keyhint.suffix.fg = cyan

c.colors.completion.odd.bg = black
c.colors.completion.even.bg = black
c.colors.completion.fg = cyan
c.colors.completion.match.fg = brightwhite
c.colors.completion.item.selected.match.fg = brightwhite
c.colors.completion.category.bg = black
c.colors.completion.category.fg = white
c.colors.completion.category.border.top = '#00000000'
c.colors.completion.category.border.bottom = '#00000000'
c.colors.completion.item.selected.bg = black
c.colors.completion.item.selected.fg = white
c.colors.completion.item.selected.border.top = '#00000000'
c.colors.completion.item.selected.border.bottom = '#00000000'
c.colors.completion.scrollbar.bg = black
c.colors.completion.scrollbar.fg = brightblack

c.colors.messages.info.bg = black
c.colors.messages.info.fg = white
c.colors.messages.info.border = '#00000000'
c.colors.messages.warning.bg = black
c.colors.messages.warning.fg = white
c.colors.messages.warning.border = '#00000000'
c.colors.messages.error.bg = black
c.colors.messages.error.fg = white
c.colors.messages.error.border = '#00000000'

c.colors.downloads.bar.bg = black
c.colors.downloads.start.bg = brightgreen
c.colors.downloads.start.fg = white
c.colors.downloads.stop.bg = brightblack
c.colors.downloads.stop.fg = white
c.colors.downloads.error.bg = black
c.colors.downloads.error.fg = white
c.colors.downloads.system.bg = 'none'
c.colors.downloads.system.fg = 'none'

c.colors.tooltip.bg = black
c.colors.tooltip.fg = white

c.colors.prompts.bg = black
c.colors.prompts.fg = white
c.colors.prompts.border = brightblack
c.colors.prompts.selected.bg = black
c.colors.prompts.selected.fg = white

c.colors.contextmenu.disabled.bg = '#00000000'
c.colors.contextmenu.disabled.fg = brightblack
c.colors.contextmenu.menu.bg = black
c.colors.contextmenu.menu.fg = white
c.colors.contextmenu.selected.bg = white
c.colors.contextmenu.selected.fg = black


# Appearance

c.fonts.web.size.default = 16
c.fonts.default_family = []
c.fonts.default_size = '16pt'
c.fonts.web.family.fixed = 'monospace'
c.fonts.web.family.sans_serif = 'monospace'
c.fonts.web.family.serif = 'monospace'
c.fonts.web.family.standard = 'monospace'

c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.policy.images = 'never'
config.set('colors.webpage.darkmode.enabled', False, 'file://*')

c.tabs.title.format = '{audio}{current_title}'
c.tabs.title.format_pinned = '{audio}{index}'
c.tabs.show = 'multiple'
c.tabs.padding = {
    'top': 5, #3
    'bottom': 5, #4
    'left': 9, #5
    'right': 9 #3
}
c.tabs.indicator.width = 0  # no tab indicators
c.tabs.width = '7%'
c.tabs.last_close = 'close'
c.tabs.mode_on_change = 'restore'
c.tabs.favicons.scale = 1.3
c.tabs.show_switching_delay = 700
c.tabs.pinned.frozen = False

c.hints.padding = {
    'left': 4,
    'right': 4,
    'top': 3,
    'bottom': 4
}

c.content.user_stylesheets = ['~/.config/qutebrowser/styles/youtube-tweaks.css']
c.window.title_format = '{perc}{current_title}'
c.content.prefers_reduced_motion = True
c.window.transparent = True


# Search behaviour

c.url.open_base_url = True

# If you use duckduckgo, you can make use of its built in bangs, of which there are many! <https://duckduckgo.com/bangs>
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    '!aw': 'https://wiki.archlinux.org/?search={}',
    '!ddg': 'https://duckduckgo.com/?ia=web&q={}',
    '!gh': 'https://github.com/search?o=desc&s=stars&q={}',
    '!l': 'https://letterboxd.com/search/{}',
    '!m': 'https://google.com/maps?q={}',
    #'!o': 'https://orpheus.network/torrents.php?searchstr={}',
    '!v': 'https://voidlinux.org/packages/?arch=x86_64&q={}',
    '!w': 'https://en.wikipedia.org/w/index.php?title=Special%3ASearch&search={}',
    '!yt': 'https://youtube.com/results?search_query={}',
    '!im': 'https://duckduckgo.com/?ia=images&iax=images&q={}'
}


# Other behaviour

config.load_autoconfig()

c.content.default_encoding = 'utf-8'

c.statusbar.widgets = ['keypress', 'search_match', 'url', 'progress', 'clock']

c.auto_save.session = True
c.auto_save.interval = 40000

c.completion.height = '30%'
c.completion.web_history.max_items = 30
c.completion.timestamp_format = '%b %a %d %H:%M:%S'
c.completion.scrollbar.width = 18
c.completion.shrink = True
c.completion.open_categories = [
    'searchengines',
    'quickmarks',
    'bookmarks',
    'history',
    'filesystem'
]

c.downloads.location.directory = '~/downloads'
c.downloads.location.prompt = True
c.downloads.prevent_mixed_content = True
c.downloads.position = 'bottom'

c.prompt.filebrowser = True
c.prompt.radius = 40

c.input.insert_mode.auto_load = True
c.input.insert_mode.auto_leave = True
c.input.insert_mode.plugins = True

c.hints.radius = 30
c.hints.uppercase = True

c.scrolling.bar = 'always'
c.scrolling.smooth = False

c.qt.args = [
    'enable-gpu-rasterization',
    'use-gl=egl',
    'ignore-gpu-blocklist',
    'enable-accelerated-video-decode'
]

c.qt.chromium.experimental_web_platform_features = 'always'

#c.fileselect.handler = 'external'
#c.fileselect.single_file.command = ['footclient', '-e', 'nnn', '-d', '-l', '2', '-U', '-D', '-R', '-i', '-x', '-GQ', '-p', '{}']
#c.fileselect.multiple_files.command = ['footclient', '-e', 'nnn', '-d', '-l', '2', '-U', '-D', '-R', '-i', '-x', '-GQ', '-p', '{}']
#c.fileselect.folder.command = ['footclient', '-e', 'nnn', '--choosedir={}']


# Privacy

c.content.canvas_reading = False
c.content.webrtc_ip_handling_policy = 'default-public-interface-only'
c.content.cookies.accept = 'all'
c.content.cookies.store = True
c.content.media.video_capture = True
c.content.media.audio_capture = True
c.content.media.audio_video_capture = True
c.content.notifications.enabled = True
c.content.notifications.presenter = 'libnotify'
c.content.javascript.enabled = True
c.content.javascript.clipboard = 'access'
c.content.webgl = True
c.content.pdfjs = True
c.content.xss_auditing = False
c.content.local_content_can_access_remote_urls = True
c.content.plugins = True
c.content.tls.certificate_errors = 'ask-block-thirdparty'
c.content.geolocation = False


# Adblocking

# Place the greasemonkey script `yt-ads.js` in `~/.config/qutebrowser/greasemonkey`.
# The script skips through the entire ad, so all you have to do is click the skip button.
# Yeah it's not ublock origin, but if you want a minimal browser, this is a solution for the tradeoff.
# You can also watch yt vids directly in mpv; see qutebrowser FAQ for how to do that.
# If you want additional blocklists, you can get the python-adblock package, or you can uncomment the ublock lists here.

c.content.blocking.enabled = True

# python-adblock
#c.content.blocking.method = 'adblock'

#c.content.blocking.adblock.lists = [
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt',
#    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt'
#]


# Keybindings

config.bind('=', 'cmd-set-text -s :open')
config.bind('h', 'history')
config.bind('cs', 'cmd-set-text -s :config-source')
config.bind('th', 'config-cycle tabs.show multiple never')
config.bind('sh', 'config-cycle statusbar.show always never')
config.bind('t', 'hint links tab')
config.bind('pP', 'open -- {primary}')
config.bind('pp', 'open -- {clipboard}')
config.bind('pt', 'open -t -- {clipboard}')
config.bind('mr', 'macro-record')
config.bind('tt', 'config-cycle tabs.position top left')
config.bind('gj', 'tab-move +')
config.bind('gk', 'tab-move -')
config.bind('gm', 'tab-move')
config.bind('<ctrl-h>', 'navigate prev')
config.bind('<ctrl-l>', 'navigate next')
config.bind('<ctrl-j>', 'navigate increment')
config.bind('<ctrl-k>', 'navigate decrement')
config.bind('mpv', 'hint links spawn mpv'
    +' --vo=gpu'
    +' --hwdec=vaapi'
    +' --ytdl-format=\'bestvideo[height<=720]+bestaudio\''
    +' --audio-device=\'pulse/alsa_output.pci-0000_00_1f.3.analog-stereo\''
    +' --script-opts=ytdl_hook-ytdl_path=yt-dlp'
    +' \'{hint-url}\'')
config.bind('.', 'download-cancel')
