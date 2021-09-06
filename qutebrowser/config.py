# Load config.py settings
config.load_autoconfig(False)

# Aliases for commands
c.aliases = {'qa': 'quit', 'w': 'session-save', 'wq': 'quit --save','q':"close"}

# Editor
c.editor.command = ["termite", "-e", "vim", "{}"]


# Completion menu height
c.completion.height = "20%"

# Confirm quit if downloading
c.confirm_quit = ["downloads"]

# Download locations
c.downloads.location.directory = "~/Downloads"

c.url.start_pages = "file:///home/mj/Documents/Programming/html/homepage/index.html"

c.tabs.indicator.width = 0
c.tabs.show = 'multiple'
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.zoom.default = '90%'

config.bind("D","home")
config.bind("C","hint images userscript ~/shs/clipper.sh")
config.bind(",m", "spawn mpv {url}")
config.bind(",M","hint links spawn mpv {hint-url}")
config.bind(",d","hint --rapid links spawn wget {hint-url}")
config.bind(",r","hint --rapid links spawn mpv {hint-url}")
config.bind("z","hint links userscript ~/shs/qtzo.sh")

c.url.searchengines ={
        "DEFAULT": "https://duckduckgo.com/?q={}",
        "a": "https://wiki.archlinux.org/?search={}",
        "m": "https://mangadex.org/titles?q={}",
        "c":"https://www.crunchyroll.com/search?from=&q={}",
        "y":"https://www.youtube.com/results?search_query={}",
        "tr":"https://translate.google.com/?source=osdd&sl=auto&tl=auto&text={}&op=translate",
        "u":"https://www.urbandictionary.com/define.php?term={}",
        "r":"https://www.reddit.com/r/{}"}

c.tabs.padding ={"bottom": 0, "left": 5, "right": 5, "top": 5}

c.colors.webpage.bg = "#1a1b26"
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.page = "smart"
c.colors.webpage.darkmode.policy.images = "never"
#c.colors.webpage.darkmode.contrast = 1
#c.colors.webpage.darkmode.threshold.text = 100
#c.colors.webpage.darkmode.threshold.background = 100
#c.colors.webpage.darkmode.enabled = False

c.colors.tabs.odd.bg = "#4a4a4a"
c.colors.tabs.odd.fg = "#e50036"
c.colors.tabs.even.fg = "#d84848"
c.colors.tabs.even.bg = "#303030"

c.colors.tabs.selected.odd.bg = "#151515"
c.colors.tabs.selected.odd.fg = "#b6235a"
c.colors.tabs.selected.even.fg = "#fc7264"
c.colors.tabs.selected.even.bg = "#191919"

c.colors.messages.error.bg = "#fc7264"
c.colors.messages.error.border = "#b6235a"
c.colors.messages.error.fg = "#151515"
c.colors.messages.info.bg = "#151515"
c.colors.messages.info.fg = "#e50036"

c.colors.statusbar.command.bg = "#1a1b26"
c.colors.statusbar.command.fg = "#fc7264"
c.colors.statusbar.command.private.bg = "#190e1c"

c.colors.statusbar.insert.bg = "#000023"
c.colors.statusbar.insert.fg = "#af8cd2"
c.colors.statusbar.normal.bg = "#1a1b26"
c.colors.statusbar.normal.fg = "#fc7264"
c.colors.statusbar.private.bg = "#190e1c"
c.colors.statusbar.progress.bg = "#d84848"

c.colors.statusbar.url.fg = "#f58c8c"
c.colors.statusbar.url.success.http.fg = "#fc7264"
c.colors.statusbar.url.success.https.fg = "#b6235a"

c.colors.completion.fg= ["#f58c69", "#f58c69", "#f58c69"]
c.colors.completion.item.selected.bg = "#b6235a"
c.colors.completion.item.selected.border.bottom = "#b6235a"
c.colors.completion.item.selected.border.top = "#b6235a"
c.colors.completion.item.selected.fg = "#ffffff"
c.colors.completion.item.selected.match.fg = "#1878f0"

c.colors.keyhint.suffix.fg = "#b6235a"
c.colors.keyhint.bg = "#1a1b26"
c.colors.keyhint.fg = "#ffffff"

c.colors.contextmenu.disabled.bg = ''
c.colors.contextmenu.disabled.fg = '#120309'
c.colors.contextmenu.menu.bg = '#1a1b26'
c.colors.contextmenu.menu.fg = '#fc7264'
c.colors.contextmenu.selected.bg = '#b6235a'
c.colors.contextmenu.selected.fg = '#ffffff'
