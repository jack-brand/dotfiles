-- Author: dacctal
-- Source: <https://git.symlinx.net/daccfiles/tree/.config/vis/themes/caelus.lua>

local lexers = vis.lexers

local lightyellow = '#efbf71'
local lightgray = '#9a9c8b'
local darkgray = '#1e1f1e'

lexers.STYLE_DEFAULT = 'back:black,fore:white'
lexers.STYLE_NOTHING = 'back:black'
lexers.STYLE_CLASS = 'fore:cyan,bold'
lexers.STYLE_COMMENT = 'fore:'..lightgray
lexers.STYLE_CONSTANT = 'fore:cyan'
lexers.STYLE_DEFINITION = 'fore:white'
lexers.STYLE_ERROR = 'fore:red'
lexers.STYLE_FUNCTION = 'fore:'..lightyellow
lexers.STYLE_KEYWORD = 'fore:red'
lexers.STYLE_LABEL = 'fore:white'
lexers.STYLE_NUMBER = 'fore:magenta'
lexers.STYLE_OPERATOR = 'fore:white'
lexers.STYLE_REGEX = 'fore:white'
lexers.STYLE_STRING = 'fore:green'
lexers.STYLE_PREPROCESSOR = 'fore:white'
lexers.STYLE_TAG = 'fore:white'
lexers.STYLE_TYPE = 'fore:cyan,bold'
lexers.STYLE_VARIABLE = 'fore:white'
lexers.STYLE_WHITESPACE = ''
lexers.STYLE_EMBEDDED = 'fore:white'
lexers.STYLE_IDENTIFIER = 'fore:blue'
lexers.STYLE_LINENUMBER = 'fore:#6c756f'
lexers.STYLE_LINENUMBER_CURSOR = 'fore:'..lightyellow
lexers.STYLE_CURSOR = 'fore:black,back:white'
lexers.STYLE_CURSOR_PRIMARY = lexers.STYLE_CURSOR
lexers.STYLE_CURSOR_LINE = 'underlined'
lexers.STYLE_COLOR_COLUMN = 'back:black'
lexers.STYLE_SELECTION = 'fore:black,back:yellow'
lexers.STYLE_STATUS = 'back:'..darkgray..',fore:'..lightgray
lexers.STYLE_STATUS_FOCUSED = 'back:'..lightgray..',fore:'..darkgray..',bold'
lexers.STYLE_SEPARATOR = lexers.STYLE_DEFAULT
lexers.STYLE_INFO = 'fore:default,back:default,bold'
lexers.STYLE_EOF = ''
