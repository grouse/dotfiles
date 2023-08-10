local M = {}

local util = require("autumn.util")

function M.setup(opts, c)
    local highlights = {
        Foo    = { bg = c.magenta, fg = c.base00 },
        Ignore = {},

        ---- core editor highlights
        ColorColumn = {}, 
        Conceal = { fg = c.blue }, 
        CurSearch = { bg = util.lighten(c.base10, 0.5) }, 
        Cursor = { bg = c.base00, fg = c.base10 }, 
        lCursor = { link = 'Cursor' }, 
        CursorIM = { link = 'Cursor' }, 
        CursorColumn = { link = 'ColorColumn' }, 
        CursorLine = { bg = util.lighten(c.base10, 0.1) }, 
        Directory = { fg = c.blue }, 
        DiffAdd = { fg = c.add, reverse = true }, 
        DiffChange = { fg = c.change, reverse = true }, 
        DiffDelete = { fg = c.delete, reverse = true }, 
        DiffText = { fg = c.blue, reverse = true }, 
        EndOfBuffer = { }, 
        TermCursor = { link = 'Cursor' }, -- Cursor in a focused terminal
        TermCursorNC = { link = "Cursor" }, -- Cursor in an unfocused terminal
        ErrorMsg = { fg = c.error, reverse = true }, -- Error messages on the command line
        WinSeparator = { }, -- Separators between window splits
        Folded = { }, -- Line used for closed folds
        FoldColumn = { }, -- 'foldcolumn'
        SignColumn = { }, -- Column were signs are displayed
        IncSearch = { fg = c.orange, standout = true }, -- 'incsearch' highlighting, also for the text replaced
        Substitute = { link = 'IncSearch' }, -- :substitute replacement text highlight
        LineNr = { }, -- Line number for ":number" and ":#" commands
        LineNrAbove = { link = 'LineNr' }, -- Line number, above the cursor line
        LineNrBelow = { link = 'LineNr' }, -- Line number, below the cursor
        CursorLineNr = { },
        CursorLineFold = { link = 'FoldColumn' }, -- Like FoldColumn when 'cursorline' is set
        CursorLineSign = { link = 'SignColumn' }, -- Like SignColumn when 'cursorline' is set
        MatchParen = { fg = util.lighten(c.base00, 0.9), bold = true }, -- Character under the cursor or just before it
        ModeMsg = { fg = c.blue }, -- 'showmode' message (e.g., "-- INSERT --")
        MsgArea = { link = 'Normal' }, -- 'Area for messages and cmdline'
        MsgSeparator = { link = 'Normal' }, -- Separator for scrolled messages msgsep.
        MoreMsg = { fg = c.blue }, -- more-prompt
        NonText = { }, -- '@' at the end of the window
        Normal = { fg = c.base00, bg = c.base10 }, -- Normal text
        NormalFloat = { fg = c.base00, bg = c.base10 }, -- Normal text in floating windows
        FloatBorder = { link = 'WinSeparator', bold = true }, -- Border of floating windows.
        FloatTitle = { fg = c.orange }, -- Title of float windows.
        NormalNC = { link = 'Normal' }, -- Normal text in non-current windows.
        Pmenu = { fg = c.base00, bg = c.base10 }, -- Popup menu: Normal item
        PmenuSel = { }, -- Popup menu: Selected item
        PmenuKind = { link = 'Pmenu' }, -- Popup menu: Normal item kind
        PmenuKindSel = { link = 'PmenuSel' }, -- Popup menu: Selected item kind
        PmenuExtra = { link = 'Pmenu' }, -- Popup menu: Normal item extra text
        PmenuExtraSel = { link = 'PmenuSel' }, -- Popup menu: Selected item extra text
        PmenuSbar = { }, -- Popup menu: Scrollbar
        PmenuThumb = { }, -- Popup menu: Thumb of the scrollbar
        Question = { fg = c.cyan, bold = true }, -- hit-enter prompt and yes/no questions.
        QuickFixLine = { }, -- Current quickfix item in the quickfix window
        Search = { fg = c.yellow, reverse = true }, -- Last search pattern highlighting
        SpecialKey = { fg = c.red, reverse = true }, -- Unprintable characters: Text displayed differently from what it really is.
        SpellBad = { sp = c.red, undercurl = true }, -- Word that is not recognized by the spellchecker.
        SpellCap = { sp = c.violet, undercurl = true }, -- Word that should start with a capital
        SpellLocal = { sp = c.yellow, undercurl = true }, -- Word that is recognized by the spellchecker as one that is used in another region
        SpellRare = { sp = c.cyan, undercurl = true }, -- Word that is recognized by the spellchecker as one that is hardly ever used.
        StatusLine = { }, -- Status line of current window.
        StatusLineNC = { }, -- Status lines of not-current windows.
        TabLine = { }, -- Tab pages line, not active tab page label.
        TabLineFill = { }, -- Tab pages line, where there are no labels.
        TabLineSel = { fg = c.base2, bg = c.base01, sp = c.base0, underline = true }, -- Tab pages line, active tab page label.
        Title = { }, -- Titles for output from ":set all", ":autocmd" etc.
        Visual = { }, -- Visual mode selection.
        VisualNOS = { link = 'Visual' }, -- Visual mode selection when vim is "Not Owning the Selection".
        WarningMsg = { fg = c.warning, bold = true }, -- Warning messages.
        Whitespace = { }, -- "nbsp", "space", "tab", "multispace", "lead" and "trail" in 'listchars'.
        WildMenu = { }, -- Current match in 'wildmenu' completion.
        WinBar = { link = 'Pmenu' }, -- Window bar of current window.
        WinBarNC = { link = 'WinBar' }, -- Window bar of not-current windows.

        --- syntax highlights
        Comment        = { fg   = c.base02, italic = true },  -- any comment
        Constant       = { fg   = util.lighten(c.base00, 0.8) },  -- any constant
        String         = { fg   = util.darken(c.base02, 0.3) }, -- a string constant: "this is a string"
        Character      = { link = 'String' }, -- a character constant: 'c', '\n'
        Number         = { link = "Constant" },  -- a number constant: 234, 0xff
        Boolean        = { link = 'Constant' }, -- a boolean constant: TRUE, false
        Float          = { link = 'Constant' }, -- a floating point constant: 2.3e10
        Identifier     = { fg   = c.base00 },  -- any variable name
        Function       = { fg   = util.blend(c.base00, c.base01, 0.2) },  -- function name (also: methods for classes)
        Keyword        = { fg   = c.base01 }, -- any other keyword
        Statement      = { link = "Keyword" }, -- any statement
        Conditional    = { link = "Keyword" }, -- if, then, else, endif, switch, etc.
        Repeat         = { link = 'Keyword' }, -- for, do, while, etc.
        Label          = { link = 'Keyword' }, -- case, default, etc.
        Exception      = { link = 'Keyword' }, -- try, catch, throw
        StorageClass   = { link = "Keyword" }, -- static, register, volatile, etc.
        Structure      = { link = "Keyword" }, -- struct, union, enum, etc.
        Typedef        = { link = "Keyword" }, -- A typedef
        Operator       = { fg   = util.lighten(c.base00, 0.2) }, -- "sizeof", "+", "*", etc.
        Define         = { link = 'Keyword' }, -- preprocessor #define
        PreProc        = { link = "Define" }, -- generic Preprocessor
        Include        = { link = 'Define' }, -- preprocessor #include
        PreCondit      = { link = 'Define' }, -- preprocessor #if, #else, #endif, etc.
        Macro          = { fg   = c.base03 }, -- same as Define
        Type           = { fg   = c.base00 }, -- int, long, char, etc.
        Special        = { fg   = c.red }, -- special symbol
        SpecialChar    = { link = 'Special' }, -- special character in a constant
        Tag            = { link = 'Special' }, -- you can use CTRL-] on this
        SpecialComment = { link = 'Special' }, -- special things inside a comment
        Debug          = { link = 'Special' }, -- debugging statements
        Delimiter      = { fg   = util.lighten(c.base00, 0.9) }, -- character that needs attention
        Underlined     = { fg   = c.violet }, --text that stands out, HTML links
        Error          = { fg   = c.error, bold = true }, --any erroneous construct
        Todo           = { fg   = c.magenta, bold = true }, --anything that needs extra attention; mostly the keywords TODO FIXME and XXX

        --- treesitter highlights
        ['@comment']               = { link = 'Comment' }, -- line and block comments
        ['@comment.documentation'] = { link = 'Comment' }, -- comments documenting code
        ['@error']                 = { link = 'Error' }, -- syntax/parser errors
        ['@none']                  = { link = 'Ignore' }, -- completely disable the highlight
        ['@preproc']               = { link = 'PreProc' }, -- various preprocessor directives & shebangs
        ['@define']                = { link = 'Define' }, -- preprocessor definition directives
        ['@operator']              = { link = 'Operator' }, -- symbolic operators (e.g. `+` / `*`)

        ['@punctuation.delimiter'] = { link = 'Delimiter' }, -- delimiters (e.g. `;` / `.` / `,`)
        ['@punctuation.bracket']   = { link = 'Delimiter' }, -- brackets (e.g. `()` / `{}` / `[]`)
        ['@punctuation.special']   = { link = 'Delimiter' }, -- special symbols (e.g. `{}` in string interpolation)

        ['@string']               = { link = 'String' }, -- string literals
        ['@string.documentation'] = { link = 'Comment' }, -- string documenting code (e.g. Python docstrings)
        ['@string.regex']         = { fg   = c.violet }, -- regular expressions
        ['@string.escape']        = { link = 'Keyword' }, -- escape sequences
        ['@string.special']       = { link = 'SpecialChar' }, -- other special strings (e.g. dates)

        ['@character']         = { link = 'String' }, -- character literals
        ['@character.special'] = { link = '@string.special' }, -- special characters (e.g. wildcards)

        ['@boolean'] = { link = 'Boolean' }, -- boolean literals
        ['@number']  = { link = 'Number' }, -- numeric literals
        ['@float']   = { link = 'Float' }, -- floating-point number literals

        ['@function']         = { link = 'Function' }, -- function definitions
        ['@function.builtin'] = { link = 'Function' }, -- built-in functions
        ['@function.call']    = { link = 'Function' }, -- function calls
        ['@function.macro']   = { link = 'Function' }, -- preprocessor macros

        ['@method']      = { link = 'Function' }, -- method definitions
        ['@method.call'] = { link = 'Function' }, -- method calls

        ['@constructor'] = { link = 'Function' }, -- constructor calls and definitions
        ['@parameter']   = { fg   = c.base0, italic = true }, -- parameters of a function

        ['@keyword']           = { link = 'Keyword' }, -- various keywords
        ['@keyword.coroutine'] = { link = 'Statement' }, -- keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
        ['@keyword.function']  = { link = 'Keyword' }, -- keywords that define a function (e.g. `func` in Go, `def` in Python)
        ['@keyword.operator']  = { link = 'Operator' }, -- operators that are English words (e.g. `and` / `or`)
        ['@keyword.return']    = { link = 'Statement' }, -- keywords like `return` and `yield`

        ['@conditional']         = { link = 'Conditional' }, -- keywords related to conditionals (e.g. `if` / `else`)
        ['@conditional.ternary'] = { link = 'Conditional' }, -- ternary operator (e.g. `?` / `:`)

        ['@repeat']    = { link = 'Repeat' }, -- keywords related to loops (e.g. `for` / `while`)
        ['@debug']     = { link = 'Debug' }, -- keywords related to debugging
        ['@label']     = { link = 'Label' }, -- GOTO and other labels (e.g. `label:` in C)
        ['@include']   = { link = 'Include' }, -- keywords for including modules (e.g. `import` / `from` in Python)
        ['@exception'] = { link = 'Exception' }, -- keywords related to exceptions (e.g. `throw` / `catch`)

        ['@type']            = { link = 'Type' }, -- type or class definitions and annotations
        ['@type.builtin']    = { link = 'Type' }, -- built-in types
        ['@type.definition'] = { link = 'Type' }, -- type definitions (e.g. `typedef` in C)
        ['@type.qualifier']  = { link = 'Keyword' }, -- type qualifiers (e.g. `const`)

        ['@storageclass'] = { link = 'StorageClass' }, -- modifiers that affect storage in memory or life-time
        ['@attribute']    = { link = 'Function' }, -- attribute annotations (e.g. Python decorators)
        ['@field']        = { fg   = c.base00 }, -- object and struct fields
        ['@property']     = { link = '@field' }, -- similar to `@field`

        ['@variable']         = { link = 'Identifier' }, -- various variable names
        ['@variable.builtin'] = { link = 'Identifier' }, -- built-in variable names (e.g. `this`)

        ['@constant']         = { link = 'Constant' }, -- constant identifiers
        ['@constant.builtin'] = { link = 'Constant' }, -- built-in constant values
        ['@constant.macro']   = { link = 'Constant' }, -- constants defined by the preprocessor

        ['@namespace'] = { fg = c.base00 }, -- modules or namespaces
        ['@symbol']    = { fg = c.violet }, -- symbols or atoms

        ['@text'] = { fg = c.base00 }, -- non-structured text
        ['@text.strong'] = { fg = c.yellow }, -- bold text
        ['@text.emphasis'] = { link = '@text.strong' }, -- text with emphasis
        ['@text.underline'] = { link = 'Underlined' }, -- underlined text
        ['@text.strike'] = { strikethrough = true }, -- strikethrough text
        ['@text.title'] = { link = 'Title' }, -- text that is part of a title
        ['@text.quote'] = { fg = c.cyan }, -- text quotations
        ['@text.uri'] = { link = 'Underlined' }, -- URIs (e.g. hyperlinks)
        ['@text.math'] = { link = 'Number' }, -- math environments (e.g. `$ ... $` in LaTeX)
        ['@text.environment'] = { }, -- text environments of markup languages
        ['@text.environment.name'] = { link = 'Keyword' }, -- text indicating the type of an environment
        ['@text.reference'] = { link = 'Underlined' }, -- text references, footnotes, citations, etc.

        ['@text.literal']       = { link = '@text' }, -- literal or verbatim text (e.g., inline code)
        ['@text.literal.block'] = { link = '@text' }, -- literal or verbatim text as a stand-alone block

        ['@text.todo']    = { link = 'Todo' }, -- todo notes
        ['@text.note']    = { fg   = c.info }, -- info notes
        ['@text.warning'] = { fg   = c.warning }, -- warning notes
        ['@text.danger']  = { fg   = c.error }, -- danger/error notes

        ['@text.diff.add']    = { fg = c.add }, -- added text (for diff files)
        ['@text.diff.delete'] = { fg = c.delete }, -- deleted text (for diff files)

        ['@tag']           = { fg = c.blue, bold = true }, -- XML tag names
        ['@tag.attribute'] = { fg = c.violet }, -- XML tag attributes
        ['@tag.delimiter'] = { }, -- XML tag delimiters

        --- semantic highlights
        ["@lsp.type.class"]         = { link = 'Type' }, -- Type
        ["@lsp.type.decorator"]     = { link = 'Function' }, -- Function
        ["@lsp.type.enum"]          = { link = 'Type' }, -- Type
        ["@lsp.type.enumMember"]    = { link = 'Constant' }, -- Constant
        ["@lsp.type.function"]      = { link = 'Function' }, -- Function
        ["@lsp.type.interface"]     = { link = 'Type' }, -- Type
        ["@lsp.type.macro"]         = { link = 'Macro' }, -- Keyword
        ["@lsp.type.method"]        = { link = 'Function' }, -- Function
        ["@lsp.type.namespace"]     = { link = '@namespace' }, -- Namespace
        ["@lsp.type.parameter"]     = { fg   = c.base00, italic = true },
        ["@lsp.type.property"]      = { link = '@field' }, -- Property
        ["@lsp.type.struct"]        = { link = 'Structure' }, -- Structure
        ["@lsp.type.type"]          = { link = 'Type' }, -- Type
        ["@lsp.type.typeParameter"] = { link = 'Type' }, -- Type
        ["@lsp.type.variable"]      = { link = 'Identifier' }, -- Identifier

        -- Extra highlight
        ["@lsp.typemod.variable.readonly"]     = { link = 'Constant' }, -- Constant variables ex: const hello = 'Hello World'
        ["@lsp.typemod.variable.global"]       = { link = 'Constant' }, -- Global variables ex: HELLO         = 'Hello World'
        ["@lsp.typemod.keyword.documentation"] = { link = 'Keyword' }, -- documentation comments
        ["@lsp.typemod.class.documentation"]   = { link = 'Type' }, -- documentation comments
        ["@lsp.typemod.property.readonly"]     = { link = 'Constant' }, -- Ex: System."out".println()
    }

    return highlights
end

return M
