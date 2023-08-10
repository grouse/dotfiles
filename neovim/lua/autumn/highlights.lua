local M = {}

local util = require("autumn.util")

function M.setup(opts, c)
    local highlights = {
        Foo    = { bg = c.magenta, fg = c.base00 },
        Ignore = {},

        --- core editor highlights
        ColorColumn = { bg = c.base12 }, 
        Conceal = { fg = c.blue }, 
        CurSearch = { bg = util.lighten(c.base10, 0.5) }, 
        Cursor = { bg = c.base00, fg = c.base10 }, 
        lCursor = { link = 'Cursor' }, 
        CursorIM = { link = 'Cursor' }, 
        CursorColumn = { link = 'ColorColumn' }, 
        CursorLine = { bg = c.base12 },
        Directory = { fg = c.blue }, 
        DiffAdd = { fg = c.add, reverse = true }, 
        DiffChange = { fg = c.change, reverse = true }, 
        DiffDelete = { fg = c.delete, reverse = true }, 
        DiffText = { fg = c.blue, reverse = true }, 
        EndOfBuffer = { fg = c.base12 }, 
        TermCursor = { link = 'Cursor' }, -- Cursor in a focused terminal
        TermCursorNC = { link = "Cursor" }, -- Cursor in an unfocused terminal
        ErrorMsg = { fg = c.error, reverse = true }, -- Error messages on the command line
        WinSeparator = { fg = c.base12, bg = c.base12 }, -- Separators between window splits
        Folded = { fg = c.base00, bg = c.base12, underline = true, bold = true }, -- Line used for closed folds
        FoldColumn = { fg = c.base00, bg = c.base12, bold = true }, -- 'foldcolumn'
        SignColumn = { fg = c.base00, bg = c.base12, }, -- Column were signs are displayed
        IncSearch = { fg = c.orange, standout = true }, -- 'incsearch' highlighting, also for the text replaced
        Substitute = { link = 'IncSearch' }, -- :substitute replacement text highlight
        LineNr = { fg = c.base00 }, -- Line number for ":number" and ":#" commands
        LineNrAbove = { link = 'LineNr' }, -- Line number, above the cursor line
        LineNrBelow = { link = 'LineNr' }, -- Line number, below the cursor
        CursorLineNr = { fg = util.lighten(c.base00, 0.1) },
        CursorLineFold = { link = 'FoldColumn' }, -- Like FoldColumn when 'cursorline' is set
        CursorLineSign = { link = 'SignColumn' }, -- Like SignColumn when 'cursorline' is set
        MatchParen = { fg = util.lighten(c.base00, 0.9), bold = true }, -- Character under the cursor or just before it
        ModeMsg = { fg = c.blue }, -- 'showmode' message (e.g., "-- INSERT --")
        MsgArea = { link = 'Normal' }, -- 'Area for messages and cmdline'
        MsgSeparator = { link = 'Normal' }, -- Separator for scrolled messages msgsep.
        MoreMsg = { fg = c.blue }, -- more-prompt
        NonText = { fg = c.base01, bold = true }, -- '@' at the end of the window
        Normal = { fg = c.base00, bg = c.base10 }, -- Normal text
        NormalFloat = { fg = c.base00, bg = c.base10 }, -- Normal text in floating windows
        FloatBorder = { }, -- Border of floating windows.
        FloatTitle = { fg = c.orange }, -- Title of float windows.
        NormalNC = { link = 'Normal' }, -- Normal text in non-current windows.
        Pmenu = { fg = c.base00, bg = c.base12 }, -- Popup menu: Normal item
        PmenuSel = { fg = c.base00, bg = c.base13 }, -- Popup menu: Selected item
        PmenuKind = { link = 'Pmenu' }, -- Popup menu: Normal item kind
        PmenuKindSel = { link = 'PmenuSel' }, -- Popup menu: Selected item kind
        PmenuExtra = { link = 'Pmenu' }, -- Popup menu: Normal item extra text
        PmenuExtraSel = { link = 'PmenuSel' }, -- Popup menu: Selected item extra text
        PmenuSbar = { fg = c.base00, bg = util.lighten(c.base10, 0.3) }, -- Popup menu: Scrollbar
        PmenuThumb = { fg = c.base10, bg = c.base01 }, -- Popup menu: Thumb of the scrollbar
        Question = { fg = c.cyan, bold = true }, -- hit-enter prompt and yes/no questions.
        QuickFixLine = { bg = c.base13 }, -- Current quickfix item in the quickfix window
        Search = { fg = c.yellow, reverse = true }, -- Last search pattern highlighting
        SpecialKey = { fg = c.red, reverse = true }, -- Unprintable characters: Text displayed differently from what it really is.
        SpellBad = { sp = c.red, undercurl = true }, -- Word that is not recognized by the spellchecker.
        SpellCap = { sp = c.violet, undercurl = true }, -- Word that should start with a capital
        SpellLocal = { sp = c.yellow, undercurl = true }, -- Word that is recognized by the spellchecker as one that is used in another region
        SpellRare = { sp = c.cyan, undercurl = true }, -- Word that is recognized by the spellchecker as one that is hardly ever used.
        StatusLine = { fg = c.base00, bg = c.base12 }, -- Status line of current window.
        StatusLineNC = { bg = c.base12 }, -- Status lines of not-current windows.
        TabLine = { fg = c.base01, bg = c.base11 }, -- Tab pages line, not active tab page label.
        TabLineFill = { bg = util.darken(c.base10, 0.3) }, -- Tab pages line, where there are no labels.
        TabLineSel = { fg = c.base02, bg = c.base01, sp = c.base00, underline = true }, -- Tab pages line, active tab page label.
        Title = { fg = c.orange, bold = true }, -- Titles for output from ":set all", ":autocmd" etc.
        Visual = { bg = c.base11, standout = true }, -- Visual mode selection.
        VisualNOS = { link = 'Visual' }, -- Visual mode selection when vim is "Not Owning the Selection".
        WarningMsg = { fg = c.warning, bold = true }, -- Warning messages.
        Whitespace = { fg = c.base03 }, -- "nbsp", "space", "tab", "multispace", "lead" and "trail" in 'listchars'.
        WildMenu = { fg = util.lighten(c.base00, 0.3), bg = c.base12 }, -- Current match in 'wildmenu' completion.
        WinBar = { link = 'Pmenu' }, -- Window bar of current window.
        WinBarNC = { link = 'WinBar' }, -- Window bar of not-current windows.

        --- syntax highlights
        Comment        = { fg   = c.base02, italic = true },  -- any comment
        Constant       = { fg   = util.lighten(c.base00, 0.7) },  -- any constant
        String         = { fg   = util.darken(c.base02, 0.2) }, -- a string constant: "this is a string"
        Character      = { link = 'String' }, -- a character constant: 'c', '\n'
        Number         = { link = "Constant" },  -- a number constant: 234, 0xff
        Boolean        = { link = 'Constant' }, -- a boolean constant: TRUE, false
        Float          = { link = 'Constant' }, -- a floating point constant: 2.3e10
        Identifier     = { fg   = c.base00 },  -- any variable name
        Function       = { fg   = util.blend(c.base00, c.base01, 0.1) },  -- function name (also: methods for classes)
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
        Define         = { fg = util.lighten(c.base01, 0.2) }, -- preprocessor #define
        PreProc        = { link = "Define" }, -- generic Preprocessor
        Include        = { link = 'Define' }, -- preprocessor #include
        PreCondit      = { link = 'Define' }, -- preprocessor #if, #else, #endif, etc.
        Macro          = { fg   = c.base03 }, 
        Type           = { fg   = util.blend(c.base00, c.base01, 0.4) }, -- int, long, char, etc.
        Special        = { fg   = c.cyan }, -- special symbol
        SpecialChar    = { link = 'Special' }, -- special character in a constant
        Tag            = { link = 'Special' }, -- you can use CTRL-] on this
        SpecialComment = { link = 'Special' }, -- special things inside a comment
        Debug          = { link = 'Special' }, -- debugging statements
        Delimiter      = { fg   = util.lighten(c.base00, 0.5) }, -- character that needs attention
        Underlined     = { fg   = c.violet }, --text that stands out, HTML links
        Error          = {},
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
        ['@parameter']   = { fg   = c.base0 }, -- parameters of a function

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
        ["@lsp.type.parameter"]     = { fg   = c.base00 },
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

        --- notify
        NotifyBackground  = { bg   = c.base12 },
        NotifyERRORBorder = { fg   = c.error },
        NotifyWARNBorder  = { fg   = c.warn },
        NotifyINFOBorder  = { fg   = c.info },
        NotifyDEBUGBorder = { fg   = c.magenta },
        NotifyTRACEBorder = { fg   = c.violet },
        NotifyERRORIcon   = { link = 'NotifyERRORBorder' },
        NotifyWARNIcon    = { link = 'NotifyWARNBorder' },
        NotifyINFOIcon    = { link = 'NotifyINFOBorder' },
        NotifyDEBUGIcon   = { link = 'NotifyDEBUGBorder' },
        NotifyTRACEIcon   = { link = 'NotifyTRACEBorder' },
        NotifyERRORTitle  = { link = 'NotifyERRORBorder' },
        NotifyWARNTitle   = { link = 'NotifyWARNBorder' },
        NotifyINFOTitle   = { link = 'NotifyINFOBorder' },
        NotifyDEBUGTitle  = { link = 'NotifyDEBUGTitle' },
        NotifyTRACETitle  = { link = 'NotifyTRACEBorder' },
        NotifyERRORBody   = { link = 'Normal' },
        NotifyWARNBody    = { link = 'Normal' },
        NotifyINFOBody    = { link = 'Normal' },
        NotifyDEBUGBody   = { link = 'Normal' },
        NotifyTRACEBody   = { link = 'Normal' },


        --- cmp
        CmpItemAbbrDeprecated    = { fg   = c.base01, strikethrough = true }, -- Highlight group for unmatched characters of each deprecated completion field
        CmpItemAbbrMatch         = { fg   = c.yellow }, -- Highlight group for matched characters of each completion field,
        CmpItemAbbrMatchFuzzy    = { fg   = c.yellow }, -- Highlight group for fuzzy-matched characters of each completion field,
        CmpItemKindReference     = { link = 'Underlined' },
        CmpItemKindUnit          = { link = 'Number' },
        CmpItemKindEnum          = { link = 'Type' },
        CmpItemKindField         = { link = '@field' },
        CmpItemKindClass         = { link = 'Type' },
        CmpItemKindFile          = { fg   = c.base00 },
        CmpItemKindProperty      = { link = '@field' },
        CmpItemKindMethod        = { link = 'Function' },
        CmpItemKindKeyword       = { link = 'Keyword' },
        CmpItemKindFolder        = { link = 'Directory' },
        CmpItemKindSnippet       = { link = 'Keyword' },
        CmpItemKindVariable      = { link = 'Identifier' },
        CmpItemKindStruct        = { link = 'Structure' },
        CmpItemKindInterface     = { link = 'Type' },
        CmpItemKindTypeParameter = { link = 'Type' },
        CmpItemKindEnumMember    = { link = 'Constant' },
        CmpItemKindEvent         = { fg   = util.lighten(c.base00, 0.3) },
        CmpItemKindConstructor   = { link = '@constructor' },
        CmpItemKindConstant      = { link = 'Constant' },
        CmpItemKindModule        = { link = '@namespace' },
        CmpItemKindValue         = { fg   = util.lighten(c.base00, 0.3) },
        CmpItemKindColor         = { fg   = c.magenta },
        CmpItemKindFunction      = { link = 'Function' },
        CmpItemKindText          = { link = 'String' },

        --- navic
        NavicIconsFile          = { fg   = c.base11 },
        NavicIconsModule        = { link = '@namespace' },
        NavicIconsNamespace     = { link = '@namespace' },
        NavicIconsPackage       = { link = 'Directory' },
        NavicIconsClass         = { link = 'Type' },
        NavicIconsMethod        = { link = 'Type' },
        NavicIconsProperty      = { link = '@field' },
        NavicIconsField         = { link = '@field' },
        NavicIconsConstructor   = { link = '@constructor' },
        NavicIconsEnum          = { link = 'Type' },
        NavicIconsInterface     = { link = 'Type' },
        NavicIconsFunction      = { link = 'Function' },
        NavicIconsVariable      = { link = 'Identifier' },
        NavicIconsConstant      = { link = 'Constant' },
        NavicIconsString        = { link = 'String' },
        NavicIconsNumber        = { link = 'Number' },
        NavicIconsBoolean       = { link = 'Boolean' },
        NavicIconsArray         = { link = 'Delimiter' },
        NavicIconsObject        = { link = '@field' },
        NavicIconsKey           = { link = '@field' },
        NavicIconsNull          = { link = 'Constant' },
        NavicIconsEnumMember    = { link = 'Constant' },
        NavicIconsStruct        = { link = 'Structure' },
        NavicIconsEvent         = { fg   = util.lighten(c.base00, 0.3) },
        NavicIconsOperator      = { link = 'Operator' },
        NavicIconsTypeParameter = { link = '@parameter' },
        NavicText               = { fg   = c.base01 },
        NavicSeparator          = { link = 'Keyword' },

        --- nvim-tree
        NvimTreeSymlink                   = { link = 'Underlined' },
        NvimTreeSymlinkIcon               = { link = 'Directory' },
        NvimTreeFolderName                = { fg   = c.base00 },
        NvimTreeRootFolder                = { link = 'Title' },
        NvimTreeFolderIcon                = { link = 'Directory' },
        NvimTreeEmptyFolderName           = { fg   = c.base00 },
        NvimTreeExecFile                  = { link = 'Function' },
        NvimTreeOpenedFile                = { fg   = c.blue, bold = true },
        NvimTreeModifiedFile              = { fg   = c.change },
        NvimTreeSpecialFile               = { link = 'Special' },
        NvimTreeIndentMarker              = { fg   = c.base02 },
        NvimTreeLspDiagnosticsInformation = {},
        NvimTreeLspDiagnosticsHint        = {},
        NvimTreeGitDirty                  = { fg   = c.change },
        NvimTreeGitStaged                 = { fg   = c.add },
        NvimTreeGitMerge                  = { fg   = c.change },
        NvimTreeGitRenamed                = { fg   = c.add },
        NvimTreeGitNew                    = { fg   = c.add },
        NvimTreeGitDeleted                = { fg   = c.delete },
        NvimTreeNormal                    = { fg = c.base00, bg = c.base12 },
        NvimTreeNormalFloat               = { link = 'NvimTreeNormal' },
        NvimTreeEndOfBuffer               = { link = "EndOfBuffer" },
        NvimTreeWinSeparator              = { link = "WinSeparator" },
        NvimTreeCursorLine = { fg = c.base00, bg = c.base13 },

        --- telescope
        TelescopeSelection      = { fg   = c.base10, bg = c.base13 },
        TelescopeSelectionCaret = { link = 'TelescopeSelection' },
        TelescopeMultiSelection = { link = 'Type' },
        TelescopeMultiIcon      = { fg   = c.cyan },
        TelescopeNormal         = { fg   = c.base00, bg = c.base12 },
        TelescopePreviewNormal  = { link = 'TelescopeNormal' },
        TelescopePromptNormal   = { link = 'TelescopeNormal' },
        TelescopeResultsNormal  = { link = 'TelescopeNormal' },
        TelescopeBorder         = { link = 'WinSeparator' },
        TelescopePromptBorder   = { link = 'TelescopeBorder' },
        TelescopeResultsBorder  = { link = 'TelescopeBorder' },
        TelescopePreviewBorder  = { link = 'TelescopeBorder' },
        TelescopeTitle          = { fg   = c.blue, reverse = true },
        TelescopePromptTitle    = { link = 'TelescopeTitle' },
        TelescopeResultsTitle   = { link = 'TelescopeTitle' },
        TelescopePreviewTitle   = { link = 'TelescopeTitle' },
        TelescopePromptCounter  = { link = 'NonText' },
        TelescopeMatching       = { fg   = c.yellow },
        TelescopePromptPrefix   = { fg   = c.magenta },

    }

    return highlights
end

return M
