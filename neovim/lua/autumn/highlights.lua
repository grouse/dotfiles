local M = {}

local util = require("autumn.util")

function M.setup(opts, c)
    local highlights = {
        Ignore = {},

        NormalFg = { fg = c.base0 },

        --- core editor highlights
        HighlightYank = { fg = util.lighten(c.cyan, 0.2) },
        CurSearch = { bg = c.selection, underline = true },
        IncSearch = { bg = c.selection, standout = true }, -- 'incsearch' highlighting, also for the text replaced
        Substitute = { link = 'IncSearch' }, -- :substitute replacement text highlight
        Search = { bg = c.selection }, -- Last search pattern highlighting

        ColorColumn = { bg = c.base2 },
        Conceal = { fg = c.blue },
        Cursor = { bg = c.base0 , fg = c.base3 },
        lCursor = { link = 'Cursor' },
        CursorIM = { link = 'Cursor' },
        CursorColumn = { link = 'ColorColumn' },
        CursorLine = { bg = c.base2 },
        CursorLineSB = { bg = util.darken(c.base2, 0.2) },
        Directory = { fg = c.blue },
        DiffAdd = { fg = c.add, reverse = true },
        DiffChange = { fg = c.change, reverse = true },
        DiffDelete = { fg = c.delete, reverse = true },
        DiffText = { fg = c.blue, reverse = true },
        EndOfBuffer = { fg = c.base2 },
        TermCursor = { link = 'Cursor' }, -- Cursor in a focused terminal
        TermCursorNC = { link = "Cursor" }, -- Cursor in an unfocused terminal
        ErrorMsg = { fg = c.error, reverse = true }, -- Error messages on the command line
        WinSeparator = { fg = c.base2, bg = c.base2 }, -- Separators between window splits
        Folded = { fg = c.base1, bg = c.base2, underline = true, bold = true }, -- Line used for closed folds
        FoldColumn = { fg = c.base0, bg = c.base2 }, -- 'foldcolumn'
        SignColumn = { fg = c.base0, bg = c.base2 },
        LineNr = { fg = c.base0 }, -- Line number for ":number" and ":#" commands
        LineNrAbove = { link = 'LineNr' }, -- Line number, above the cursor line
        LineNrBelow = { link = 'LineNr' }, -- Line number, below the cursor
        CursorLineNr = { fg = c.base1 },
        CursorLineFold = { link = 'FoldColumn' }, -- Like FoldColumn when 'cursorline' is set
        CursorLineSign = { link = 'CursorLine' }, -- Like SignColumn when 'cursorline' is set
        MatchParen = { underline = true, bold = true }, -- Character under the cursor or just before it
        ModeMsg = { fg = c.blue }, -- 'showmode' message (e.g., "-- INSERT --")
        MsgArea = { link = "NormalFg" }, -- 'Area for messages and cmdline'
        MsgSeparator = { link = "NormalFg" }, -- Separator for scrolled messages msgsep.
        MoreMsg = { fg = c.blue }, -- more-prompt
        Normal = { fg = c.base0, bg = c.base3 }, -- Normal text
        NormalSB = { fg = c.base0, bg = c.base3 }, -- Normal text
        NormalFloat = { fg = c.base0, bg = c.base2 }, -- Normal text in floating windows
        FloatBorder = { fg = c.base2, bg = c.base2 }, -- Border of floating windows.
        FloatTitle = { fg = c.orange }, -- Title of float windows.
        NormalNC = { fg = c.base0, bg = util.blend(c.base3, "#000000", 0.95) },
        Pmenu = { fg = c.base0, bg = c.base2 }, -- Popup menu: Normal item
        PmenuSel = { fg = c.base0, bg = c.selection, bold=true}, -- Popup menu: Selected item
        PmenuKind = { link = 'Pmenu' }, -- Popup menu: Normal item kind
        PmenuKindSel = { link = 'PmenuSel' }, -- Popup menu: Selected item kind
        PmenuExtra = { link = 'Pmenu' }, -- Popup menu: Normal item extra text
        PmenuExtraSel = { link = 'PmenuSel' }, -- Popup menu: Selected item extra text
        PmenuSbar = { fg = c.base0, bg = c.base2 }, -- Popup menu: Scrollbar
        PmenuThumb = { fg = c.base3, bg = c.orange }, -- Popup menu: Thumb of the scrollbar
        Question = { fg = c.cyan, bold = true }, -- hit-enter prompt and yes/no questions.
        QuickFixLine = { bg = c.orange }, -- Current quickfix item in the quickfix window
        SpecialKey = { fg = c.red, reverse = true }, -- Unprintable characters: Text displayed differently from what it really is.
        SpellBad = { sp = c.red, undercurl = true }, -- Word that is not recognized by the spellchecker.
        SpellCap = { sp = c.violet, undercurl = true }, -- Word that should start with a capital
        SpellLocal = { sp = c.yellow, undercurl = true }, -- Word that is recognized by the spellchecker as one that is used in another region
        SpellRare = { sp = c.cyan, undercurl = true }, -- Word that is recognized by the spellchecker as one that is hardly ever used.
        StatusLine = { fg = c.base0, bg = c.base2 }, -- Status line of current window.
        StatusLineNC = { bg = c.base2 }, -- Status lines of not-current windows.
        TabLine = { fg = c.orange, bg = c.cyan }, -- Tab pages line, not active tab page label.
        TabLineFill = { bg = c.base2 }, -- Tab pages line, where there are no labels.
        TabLineSel = { fg = c.green, bg = c.orange, sp = c.base0, underline = true }, -- Tab pages line, active tab page label.
        Title = { fg = c.orange, bold = true }, -- Titles for output from ":set all", ":autocmd" etc.
        Visual = { bg = c.selection }, -- Visual mode selection.
        VisualNOS = { link = 'Visual' }, -- Visual mode selection when vim is "Not Owning the Selection".
        WarningMsg = { fg = c.warning, bold = true }, -- Warning messages.
        WildMenu = { fg = c.base0, bg = c.base2 }, -- Current match in 'wildmenu' completion.
        WinBar = { link = 'Pmenu' }, -- Window bar of current window.
        WinBarNC = { link = 'WinBar' }, -- Window bar of not-current windows.

        NonText    = { fg = util.blend(c.cyan, c.base3, 0.2) }, -- "eol", "extends" and "precedes" in 'listchars'
        Whitespace = { fg = util.blend(c.cyan, c.base3, 0.6) }, -- "nbsp", "space", "tab", "multispace", "lead" and "trail" in 'listchars'.

        --- syntax highlights
        Identifier = { fg = c.base0 },
        Function   = { fg = util.blend(c.yellow, c.base0, 0.4) },
        Operator   = { fg = c.base01 },
        Type       = { fg = c.yellow },
        Delimiter  = { fg = c.base00 },
        Define     = { fg = util.darken(c.orange, 0.1) },
        Keyword    = { fg = c.orange },
        Comment    = { fg = util.darken(c.cyan , 0.2) },
        String     = { fg = c.strings },
        Constant   = { fg = c.cyan },
        Macro      = { fg = c.green },
        Special    = { fg = c.green },
        Underlined = { underline = true },
        Error      = {},
        Todo       = { fg = c.red, bold = true },
        Character      = { link = 'String' }, -- a character constant: 'c', '\n'
        Number         = { link = "Constant" },  -- a number constant: 234, 0xff
        Boolean        = { link = 'Constant' }, -- a boolean constant: TRUE, false
        Float          = { link = 'Constant' }, -- a floating point constant: 2.3e10
        Statement      = { link = "Keyword" }, -- any statement
        Conditional    = { link = "Keyword" }, -- if, then, else, endif, switch, etc.
        Repeat         = { link = 'Keyword' }, -- for, do, while, etc.
        Label          = { link = 'Keyword' }, -- case, default, etc.
        Exception      = { link = 'Keyword' }, -- try, catch, throw
        StorageClass   = { link = "Keyword" }, -- static, register, volatile, etc.
        Structure      = { link = "Keyword" }, -- struct, union, enum, etc.
        Typedef        = { link = "Keyword" }, -- A typedef
        PreProc        = { link = "Define" }, -- generic Preprocessor
        Include        = { link = 'Define' }, -- preprocessor #include
        PreCondit      = { link = 'Define' }, -- preprocessor #if, #else, #endif, etc.
        SpecialChar    = { link = 'Special' }, -- special character in a constant
        Tag            = { link = 'Special' }, -- you can use CTRL-] on this
        SpecialComment = { link = 'Special' }, -- special things inside a comment
        Debug          = { link = 'Special' }, -- debugging statements

        --- diagnostics
        DiagnosticSignError = { fg = c.red,    bg = c.base2 },
        DiagnosticSignWarn  = { fg = c.yellow, bg = c.base2 },
        DiagnosticSignHint  = { fg = c.cyan,   bg = c.base2 },
        DiagnosticSignInfo  = { fg = c.cyan,   bg = c.base2 },

        DiagnosticError = { fg = c.red },
        DiagnosticWarn  = { fg = c.yellow },
        DiagnosticHint  = { fg = c.cyan },
        DiagnosticInfo  = { fg = c.cyan },

        DiagnosticVirtualTextError = { link = "DiagnosticError" },
        DiagnosticVirtualTextWarn  = { link = "DiagnosticWarn" },
        DiagnosticVirtualTextHint  = { link = "DiagnosticHint" },
        DiagnosticVirtualTextInfo  = { link = "DiagnosticInfo" },


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
        ['@parameter']   = { link = "NormalFg" }, -- parameters of a function

        ['@keyword']           = { link = 'Keyword' }, -- various keywords
        ['@keyword.coroutine'] = { link = 'Statement' }, -- keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
        ['@keyword.function']  = { link = 'Keyword' }, -- keywords that define a function (e.g. `func` in Go, `def` in Python)
        ['@keyword.operator']  = { link = 'Keyword' }, -- operators that are English words (e.g. `and` / `or`)
        ['@keyword.return']    = { link = 'Statement' }, -- keywords like `return` and `yield`

        ['@conditional']         = { link = 'Conditional' }, -- keywords related to conditionals (e.g. `if` / `else`)
        ['@conditional.ternary'] = { link = 'Operator' }, -- ternary operator (e.g. `?` / `:`)

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
        ['@attribute']    = { fg = c.cyan }, -- attribute annotations (e.g. Python decorators)
        ['@field']        = { link = "NormalFg" }, -- object and struct fields
        ['@property']     = { link = '@field' }, -- similar to `@field`

        ['@variable']         = { link = 'Identifier' }, -- various variable names
        ['@variable.builtin'] = { link = 'Identifier' }, -- built-in variable names (e.g. `this`)

        ['@constant']         = { link = 'Constant' }, -- constant identifiers
        ['@constant.builtin'] = { link = 'Constant' }, -- built-in constant values
        ['@constant.macro']   = { link = 'Constant' }, -- constants defined by the preprocessor

        ['@namespace'] = { link = "NormalFg" }, -- modules or namespaces
        ['@symbol']    = { fg = c.violet }, -- symbols or atoms

        ['@text'] = { link = "NormalFg" }, -- non-structured text
        ['@text.strong'] = { bold = true  }, -- bold text
        ['@text.emphasis'] = { italic = true }, -- text with emphasis
        ['@text.underline'] = { link = 'Underlined' }, -- underlined text
        ['@text.strike'] = { strikethrough = true }, -- strikethrough text
        ['@text.title'] = { link = 'Title' }, -- text that is part of a title
        ['@text.quote'] = { fg = c.cyan }, -- text quotations
        ['@text.uri'] = { fg = c.blue, underline = true }, -- URIs (e.g. hyperlinks)
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
        ["@lsp.type.class"]         = { link = 'Type' },
        ["@lsp.type.decorator"]     = { link = 'Function' },
        ["@lsp.type.enum"]          = { link = 'Type' },
        ["@lsp.type.enumMember"]    = { link = 'Constant' },
        ["@lsp.type.function"]      = { link = 'Function' },
        ["@lsp.type.interface"]     = { link = 'Type' },
        ["@lsp.type.macro"]         = { link = 'Macro' },
        ["@lsp.type.method"]        = { link = 'Function' },
        ["@lsp.type.namespace"]     = { link = '@namespace' },
        ["@lsp.type.parameter"]     = { link = "NormalFg" },
        ["@lsp.type.property"]      = { link = '@field' },
        ["@lsp.type.struct"]        = { link = 'Structure' },
        ["@lsp.type.type"]          = { link = 'Type' },
        ["@lsp.type.typeParameter"] = { link = 'Type' },
        ["@lsp.type.variable"]      = { link = 'Identifier' },

        -- Extra highlight
        ["@lsp.typemod.variable.readonly"]     = { link = '@variable' },
        ["@lsp.typemod.variable.global"]       = { link = '@variable' },
        ["@lsp.typemod.keyword.documentation"] = { fg = c.cyan },
        ["@lsp.typemod.class.documentation"]   = { link = 'Type' },
        ["@lsp.typemod.property.readonly"]     = { link = '@variable' },

        --- notify
        NotifyBackground  = { bg   = c.base2 },
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
        NotifyERRORBody   = { link = "NormalFg" },
        NotifyWARNBody    = { link = "NormalFg" },
        NotifyINFOBody    = { link = "NormalFg" },
        NotifyDEBUGBody   = { link = "NormalFg" },
        NotifyTRACEBody   = { link = "NormalFg" },


        --- cmp
        CmpItemAbbrDeprecated    = { fg   = c.orange, strikethrough = true }, -- Highlight group for unmatched characters of each deprecated completion field
        CmpItemAbbrMatch         = { fg   = c.yellow }, -- Highlight group for matched characters of each completion field,
        CmpItemAbbrMatchFuzzy    = { fg   = c.yellow }, -- Highlight group for fuzzy-matched characters of each completion field,
        CmpItemKindReference     = { link = 'Underlined' },
        CmpItemKindUnit          = { link = 'Number' },
        CmpItemKindEnum          = { link = 'Type' },
        CmpItemKindField         = { link = '@field' },
        CmpItemKindClass         = { link = 'Type' },
        CmpItemKindFile          = { fg   = c.base0 },
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
        CmpItemKindEvent         = { fg   = c.base0 },
        CmpItemKindConstructor   = { link = '@constructor' },
        CmpItemKindConstant      = { link = 'Constant' },
        CmpItemKindModule        = { link = '@namespace' },
        CmpItemKindValue         = { fg   = c.base0 },
        CmpItemKindColor         = { fg   = c.magenta },
        CmpItemKindFunction      = { link = 'Function' },
        CmpItemKindText          = { link = 'String' },

        CmpDocNormal = { bg = util.darken(c.base2, 0.2) },
        CmpDocBorder = { link = "CppDocNormal" },
        CmpDocSel = { link = "PmenuSel" },


        --- navic
        NavicIconsFile          = { fg   = c.cyan },
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
        NavicIconsEvent         = { fg   = c.base1 },
        NavicIconsOperator      = { link = 'Operator' },
        NavicIconsTypeParameter = { link = '@parameter' },
        NavicText               = { fg   = c.orange },
        NavicSeparator          = { link = 'Keyword' },

        --- nvim-tree
        NvimTreeSymlink                   = { link = 'Underlined' },
        NvimTreeSymlinkIcon               = { link = 'Directory' },
        NvimTreeFolderName                = { fg   = c.base0 },
        NvimTreeRootFolder                = { link = 'Title' },
        NvimTreeFolderIcon                = { link = 'Directory' },
        NvimTreeEmptyFolderName           = { fg   = c.base0 },
        NvimTreeExecFile                  = { link = 'Function' },
        NvimTreeOpenedFile                = { fg   = c.blue, bold = true },
        NvimTreeModifiedFile              = { fg   = c.change },
        NvimTreeSpecialFile               = { link = 'Special' },
        NvimTreeIndentMarker              = { fg   = c.green },
        NvimTreeLspDiagnosticsInformation = {},
        NvimTreeLspDiagnosticsHint        = {},
        NvimTreeGitDirty                  = { fg   = c.change },
        NvimTreeGitStaged                 = { fg   = c.add },
        NvimTreeGitMerge                  = { fg   = c.change },
        NvimTreeGitRenamed                = { fg   = c.add },
        NvimTreeGitNew                    = { fg   = c.add },
        NvimTreeGitDeleted                = { fg   = c.delete },
        NvimTreeNormal                    = { link = "NormalSB" },
        NvimTreeNormalFloat               = { link = 'NvimTreeNormal' },
        NvimTreeEndOfBuffer               = { link = "EndOfBuffer" },
        NvimTreeWinSeparator              = { link = "WinSeparator" },
        NvimTreeCursorLine = { link = "PmenuSel" },

        NeoTreeCursorLine = { link = "PmenuSel" },
        NeoTreeDirectoryName = { link = "NormalSB" },
        NeoTreeFloatBorder = { link = "FloatBorder" },
        NeoTreeFloatNormal = { link = "NormalFloat" },
        NeoTreeFloatTitle = { link = "FloatTitle" },
        NeoTreeWinSeparator = { link = "WinSeparator" },
        NeoTreeNormal = { link = "NormalSB" },
        NeoTreeNormalNC = { link = "NeoTreeNormal" },
        NeoTreeFileIcon = { fg = c.green },
        NeoTreeDirectoryIcon = { fg = c.green },


        --- Trouble
        TroubleNormal = { link = "NormalSB" },

        --- telescope
        TelescopeSelection      = { link = "PmenuSel" },
        TelescopeSelectionCaret = { link = 'TelescopeSelection' },
        TelescopeMultiSelection = { link = 'Type' },
        TelescopeMultiIcon      = { fg   = c.cyan },
        TelescopeNormal         = { link = "NormalSB" },
        TelescopePreviewNormal  = { bg = c.base3 },
        TelescopePromptNormal   = { bg = c.base3 },
        TelescopeResultsNormal  = { link = 'TelescopeNormal' },
        TelescopeBorder         = { link = "WinSeparator" },
        TelescopePromptBorder   = { link = 'TelescopeBorder' },
        TelescopeResultsBorder  = { link = 'TelescopeBorder' },
        TelescopePreviewBorder  = { fg = c.base3, bg = c.base3 },
        TelescopeTitle          = { fg   = c.green },
        TelescopePromptTitle    = { link = 'TelescopeTitle' },
        TelescopeResultsTitle   = { link = 'TelescopeTitle' },
        TelescopePreviewTitle   = { link = 'TelescopeTitle' },
        TelescopePromptCounter  = { link = 'NonText' },
        TelescopeMatching       = { fg = c.orange, bold=true },
        TelescopePromptPrefix   = { fg   = c.base0 },

        --- nvim-treesitter-context
        TreesitterContext = { bg = c.base2 },
        TreesitterContextBottom = { bg = c.base2, underline=true, sp = c.orange },

        --- which-key
        WhichKey          = { link = "Function" }, -- 	the key
        WhichKeyGroup     = { link = "Keyword" }, -- 	a group
        WhichKeySeparator = { fg = c.orange }, -- 	the separator between the key and its label
        WhichKeyDesc      = { link = "Comment" }, -- 	the label of the key
        WhichKeyFloat     = { link = "NormalFloat" }, -- 	Normal in the popup window
        WhichKeyBorder    = { link = "FloatBorder" }, -- 	Normal in the popup window
        WhichKeyValue     = { link = "Comment" }, -- 	used by plugins that provide values

        --- nvim-cmp
        GhostText = { fg = c.green },
    }

    return highlights
end

return M
