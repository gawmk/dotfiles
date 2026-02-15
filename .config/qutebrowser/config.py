# qutebrowser config.py (curated)

# ----------------------------
# Autoconfig
# ----------------------------
# If you want changes made in qute://settings / :set to persist, set True.
config.load_autoconfig(False)

# ----------------------------
# Per-domain overrides / quirks
# ----------------------------
# Devtools should not store cookies.
config.set('content.cookies.accept', 'never', 'chrome-devtools://*')
config.set('content.cookies.accept', 'never', 'devtools://*')

#config.set('content.https_only', False, 'http://*.miki')
# Custom Accept-Language for a specific site.
config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/*')

# Custom UA for Google accounts.
config.set(
    'content.headers.user_agent',
    'Mozilla/5.0 ({os_info}; rv:136.0) Gecko/20100101 Firefox/136.0',
    'https://accounts.google.com/*'
)

# Allow JS/images on internal pages & devtools.
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')

# Userscripts access
config.set(
    'content.local_content_can_access_remote_urls',
    True,
    'file:///home/mikimasta/.local/share/qutebrowser/userscripts/*'
)
config.set(
    'content.local_content_can_access_file_urls',
    False,
    'file:///home/mikimasta/.local/share/qutebrowser/userscripts/*'
)

# Clipboard permissions (from your autoconfig)
config.set('content.javascript.clipboard', 'access-paste', 'https://chatgpt.com')
config.set('content.javascript.clipboard', 'access-paste', 'https://github.com')

# Notifications (from your autoconfig)
config.set('content.notifications.enabled', True, 'https://calendar.google.com')
config.set('content.notifications.enabled', False, 'https://www.youtube.com')

# Protocol handlers (from your autoconfig)
config.set('content.register_protocol_handler', True, 'https://calendar.google.com?cid=%25s')
config.set('content.register_protocol_handler', True, 'https://outlook.office365.com?mailtouri=%25s')

config.set('content.blocking.method', 'both')

# ----------------------------
# Dark mode (web pages)
# ----------------------------
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.policy.images = 'never'
config.bind('zm', 'config-cycle colors.webpage.darkmode.enabled')


#c.content.user_stylesheets = './gruvbox-all-sites.css'


# ----------------------------
# Keybindings / aliases
# ----------------------------
config.bind('<Escape>', 'mode-leave ;; jseval -q document.activeElement.blur()', mode='insert')

config.bind('<Ctrl+j>', 'completion-item-focus --history next', mode='command')
config.bind('<Ctrl+k>', 'completion-item-focus --history prev', mode='command')
config.bind('<Ctrl+j>', 'nop', mode='normal')


config.bind('j', 'scroll-px 0 150', mode='normal')
config.bind('k', 'scroll-px 0 -150', mode='normal')

c.aliases['q'] = 'close'
c.aliases['qa'] = 'quit'
c.aliases['w'] = 'session-save'
c.aliases['wq'] = 'quit --save'
c.aliases['wqa'] = 'quit --save'
c.aliases['darkmode'] = 'config-cycle colors.webpage.darkmode.enabled'
c.aliases['sd'] = 'session-load -c default'
c.aliases['sw'] = 'session-load -c work'
c.aliases['su'] = 'session-load -c uni'
c.aliases['sf'] = 'session-load -c finance'
c.aliases['ss'] = 'session-load -c selfhost'



# ----------------------------
# Search engines
# ----------------------------
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?ia=web&q={}',
    '!aw': 'https://wiki.archlinux.org/index.php?title=Special%3ASearch&search={}',
    '!g': 'https://google.com/search?hl=en&q={}',
    '!m': 'https://google.com/maps?q={}',
    '!w': 'https://en.wikipedia.org/w/index.php?title=Special%3ASearch&search={}',
    '!gh': 'https://github.com/search?q={}',
    '!yt': 'https://youtube.com/results?search_query={}',
    '!r': 'https://www.reddit.com/r/{}',
}


# ----------------------------
# General preferences
# ----------------------------
# UI

# font
c.fonts.default_family = 'Iosevka Comfy Fixed'
c.fonts.default_size = '12pt'

c.completion.height = '30%'
c.completion.web_history.max_items = 300
c.completion.scrollbar.width = 20
c.keyhint.delay = 800

c.prompt.filebrowser = False
c.prompt.radius = 20

c.hints.radius = 20
c.hints.uppercase = False

c.statusbar.show = 'always'
c.tabs.position = 'top'
c.tabs.width = '10%'

c.tabs.favicons.scale = 1.2
c.tabs.padding = {"bottom": 4, "left": 0, "right": 4, "top": 4}
c.fonts.tabs.selected = 'bold 14pt'


c.tabs.show = 'always'
c.tabs.show_switching_delay = 500
c.tabs.last_close = 'startpage'

c.window.transparent = True

# Start page
c.url.default_page = 'startpage.mikolajgawrys.com'
c.url.start_pages = ['startpage.mikolajgawrys.com']

# Sessions
c.auto_save.session = False
c.session.default_name = 'default'

# Downloads
c.downloads.location.directory = '/home/gawmk/Downloads'
c.downloads.location.prompt = True
c.downloads.prevent_mixed_content = True
c.downloads.position = 'bottom'

# Input behavior
c.input.insert_mode.auto_load = True
c.input.insert_mode.auto_leave = True

# Scrolling
c.scrolling.smooth = False

# Content / security-ish (your current choices)
c.content.default_encoding = 'utf-8'
c.content.blocking.method = 'auto'

c.content.cookies.accept = 'no-3rdparty'
c.content.cookies.store = True

c.content.notifications.enabled = True
c.content.notifications.presenter = 'libnotify'

c.content.media.video_capture = True
c.content.media.audio_capture = True
c.content.media.audio_video_capture = True

c.content.webgl = True
c.content.pdfjs = True

c.content.xss_auditing = False
c.content.local_content_can_access_remote_urls = True
c.content.plugins = True

c.content.tls.certificate_errors = 'load-insecurely'
c.content.geolocation = True
c.content.javascript.clipboard = 'access'

c.content.prefers_reduced_motion = True

# Qt / backend knobs
c.qt.chromium.experimental_web_platform_features = 'always'
c.qt.workarounds.disable_hangouts_extension = True


# ----------------------------
# Theme: Gruvbox (dark hard)
# ----------------------------
bg0_hard = '#1d2021'
bg0_soft = '#32302f'
bg0_normal = '#282828'

bg0 = bg0_normal
bg1 = '#3c3836'
bg2 = '#504945'
bg3 = '#665c54'
bg4 = '#7c6f64'

fg0 = '#fbf1c7'
fg1 = '#ebdbb2'
fg2 = '#d5c4a1'
fg3 = '#bdae93'
fg4 = '#a89984'

bright_red = '#fb4934'
bright_green = '#b8bb26'
bright_yellow = '#fabd2f'
bright_blue = '#83a598'
bright_purple = '#d3869b'
bright_aqua = '#8ec07c'
bright_gray = '#928374'
bright_orange = '#fe8019'

dark_red = '#cc241d'
dark_green = '#79740e'
dark_yellow = '#b57614'
dark_blue = '#458588'
dark_purple = '#b16286'
dark_aqua = '#689d6a'
dark_gray = '#a89984'
dark_orange = '#d65d0e'

# Completion
c.colors.completion.fg = [fg1, bright_aqua, bright_yellow]
c.colors.completion.odd.bg = bg0
c.colors.completion.even.bg = c.colors.completion.odd.bg
c.colors.completion.category.fg = bright_blue
c.colors.completion.category.bg = bg1
c.colors.completion.category.border.top = c.colors.completion.category.bg
c.colors.completion.category.border.bottom = c.colors.completion.category.bg
c.colors.completion.item.selected.fg = fg0
c.colors.completion.item.selected.bg = bg4
c.colors.completion.item.selected.border.top = bg2
c.colors.completion.item.selected.border.bottom = c.colors.completion.item.selected.border.top
c.colors.completion.item.selected.match.fg = bright_orange
c.colors.completion.match.fg = c.colors.completion.item.selected.match.fg
c.colors.completion.scrollbar.fg = c.colors.completion.item.selected.fg
c.colors.completion.scrollbar.bg = c.colors.completion.category.bg

# Context menu
c.colors.contextmenu.disabled.bg = bg3
c.colors.contextmenu.disabled.fg = fg3
c.colors.contextmenu.menu.bg = bg0
c.colors.contextmenu.menu.fg = fg2
c.colors.contextmenu.selected.bg = bg2
c.colors.contextmenu.selected.fg = c.colors.contextmenu.menu.fg

# Downloads
c.colors.downloads.bar.bg = bg0
c.colors.downloads.start.fg = bg0
c.colors.downloads.start.bg = bright_blue
c.colors.downloads.stop.fg = c.colors.downloads.start.fg
c.colors.downloads.stop.bg = bright_aqua
c.colors.downloads.error.fg = bright_red

# Hints
c.colors.hints.fg = bg0
c.colors.hints.bg = 'rgba(250, 191, 47, 200)'
c.colors.hints.match.fg = bg4

# Keyhint
c.colors.keyhint.fg = fg4
c.colors.keyhint.suffix.fg = fg0
c.colors.keyhint.bg = bg0

# Messages
c.colors.messages.error.fg = bg0
c.colors.messages.error.bg = bright_red
c.colors.messages.error.border = c.colors.messages.error.bg

c.colors.messages.warning.fg = bg0
c.colors.messages.warning.bg = bright_purple
c.colors.messages.warning.border = c.colors.messages.warning.bg

c.colors.messages.info.fg = fg2
c.colors.messages.info.bg = bg0
c.colors.messages.info.border = c.colors.messages.info.bg

# Prompts
c.colors.prompts.fg = fg2
c.colors.prompts.border = f'1px solid {bg1}'
c.colors.prompts.bg = bg3
c.colors.prompts.selected.bg = bg2

# Statusbar
c.colors.statusbar.normal.fg = fg2
c.colors.statusbar.normal.bg = bg0

c.colors.statusbar.insert.fg = bg0
c.colors.statusbar.insert.bg = bg3

c.colors.statusbar.passthrough.fg = bg0
c.colors.statusbar.passthrough.bg = dark_blue

c.colors.statusbar.private.fg = bright_purple
c.colors.statusbar.private.bg = bg0

c.colors.statusbar.command.fg = fg3
c.colors.statusbar.command.bg = bg1
c.colors.statusbar.command.private.fg = c.colors.statusbar.private.fg
c.colors.statusbar.command.private.bg = c.colors.statusbar.command.bg

c.colors.statusbar.caret.fg = bg0
c.colors.statusbar.caret.bg = dark_purple
c.colors.statusbar.caret.selection.fg = c.colors.statusbar.caret.fg
c.colors.statusbar.caret.selection.bg = bright_purple

c.colors.statusbar.progress.bg = bright_blue

c.colors.statusbar.url.fg = fg4
c.colors.statusbar.url.error.fg = dark_red
c.colors.statusbar.url.hover.fg = bright_orange
c.colors.statusbar.url.success.http.fg = bright_red
c.colors.statusbar.url.success.https.fg = fg0
c.colors.statusbar.url.warn.fg = bright_purple

# Tabs
c.colors.tabs.bar.bg = bg0
c.colors.tabs.indicator.start = bright_blue
c.colors.tabs.indicator.stop = bright_aqua
c.colors.tabs.indicator.error = bright_red

c.colors.tabs.odd.fg = fg2
c.colors.tabs.odd.bg = bg1
c.colors.tabs.even.fg = c.colors.tabs.odd.fg
c.colors.tabs.even.bg = bg1

c.colors.tabs.selected.odd.fg = fg1
c.colors.tabs.selected.odd.bg = bg0
c.colors.tabs.selected.even.fg = c.colors.tabs.selected.odd.fg
c.colors.tabs.selected.even.bg = bg0

c.colors.tabs.pinned.even.bg = dark_green
c.colors.tabs.pinned.even.fg = bg2
c.colors.tabs.pinned.odd.bg = dark_green
c.colors.tabs.pinned.odd.fg = c.colors.tabs.pinned.even.fg

c.colors.tabs.pinned.selected.even.bg = bg0
c.colors.tabs.pinned.selected.even.fg = c.colors.tabs.selected.odd.fg
c.colors.tabs.pinned.selected.odd.bg = c.colors.tabs.pinned.selected.even.bg
c.colors.tabs.pinned.selected.odd.fg = c.colors.tabs.selected.odd.fg

