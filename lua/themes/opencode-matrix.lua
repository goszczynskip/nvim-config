-- OpenCode Matrix Theme for Neovim
-- A custom colorscheme matching OpenCode's matrix theme

local M = {}

-- OpenCode Matrix color palette
M.colors = {
  -- Backgrounds (dark to light)
  matrixInk0 = "#0a0e0a", -- Background (darkest)
  matrixInk1 = "#0e130d", -- Panel background
  matrixInk2 = "#141c12", -- Element background
  matrixInk3 = "#1e2a1b", -- Border / surface

  -- Greens
  rainGreen = "#2eff6a", -- Primary green
  rainGreenDim = "#1cc24b", -- Dimmed green
  rainGreenHi = "#62ff94", -- Bright green (text)

  -- Accent colors
  rainCyan = "#00efff", -- Cyan
  rainTeal = "#24f6d9", -- Teal
  rainPurple = "#c770ff", -- Purple
  rainOrange = "#ffa83d", -- Orange

  -- Alert colors
  alertRed = "#ff4b4b", -- Red/Error
  alertYellow = "#e6ff57", -- Yellow/Warning
  alertBlue = "#30b3ff", -- Blue/Info

  -- Grays
  rainGray = "#8ca391", -- Muted text
  rainGrayDim = "#4a5f4d", -- Subtle UI elements (line numbers, indent guides)

  -- Diff colors
  diffAddedBg = "#132616",
  diffRemovedBg = "#261212",
  diffHighlightAdded = "#77ffaf",
  diffHighlightRemoved = "#ff7171",

  -- Special
  none = "NONE",
}

function M.setup()
  local c = M.colors

  -- Reset highlighting
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "opencode-matrix"

  -- Define highlight groups
  local highlights = {
    -- Editor basics
    Normal = { fg = c.rainGreenHi, bg = c.matrixInk0 },
    NormalNC = { fg = c.rainGreenHi, bg = c.matrixInk0 },
    NormalFloat = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    FloatBorder = { fg = c.matrixInk3, bg = c.matrixInk1 },
    FloatTitle = { fg = c.rainGreen, bg = c.matrixInk1, bold = true },
    Cursor = { fg = c.matrixInk0, bg = c.rainGreen },
    CursorLine = { bg = c.matrixInk1 },
    CursorLineNr = { fg = c.rainGreen, bold = true },
    CursorColumn = { bg = c.matrixInk1 },
    ColorColumn = { bg = c.matrixInk1 },
    LineNr = { fg = c.rainGrayDim },
    SignColumn = { fg = c.rainGrayDim, bg = c.matrixInk0 },
    VertSplit = { fg = c.matrixInk3, bg = c.matrixInk0 },
    WinSeparator = { fg = c.matrixInk3, bg = c.matrixInk0 },
    Folded = { fg = c.rainGray, bg = c.matrixInk1 },
    FoldColumn = { fg = c.rainGrayDim, bg = c.matrixInk0 },
    NonText = { fg = c.rainGrayDim },
    SpecialKey = { fg = c.rainGrayDim },
    Whitespace = { fg = c.matrixInk2 },
    EndOfBuffer = { fg = c.matrixInk1 },

    -- Popup menu
    Pmenu = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    PmenuSel = { fg = c.matrixInk0, bg = c.rainGreen },
    PmenuSbar = { bg = c.matrixInk2 },
    PmenuThumb = { bg = c.rainGreen },

    -- Search
    Search = { fg = c.matrixInk0, bg = c.alertYellow },
    IncSearch = { fg = c.matrixInk0, bg = c.rainOrange },
    CurSearch = { fg = c.matrixInk0, bg = c.rainOrange },
    Substitute = { fg = c.matrixInk0, bg = c.alertRed },

    -- Visual
    Visual = { bg = c.matrixInk3 },
    VisualNOS = { bg = c.matrixInk3 },

    -- Messages
    ModeMsg = { fg = c.rainGreen, bold = true },
    MoreMsg = { fg = c.rainGreen },
    Question = { fg = c.rainCyan },
    WarningMsg = { fg = c.alertYellow },
    ErrorMsg = { fg = c.alertRed },

    -- Statusline
    StatusLine = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    StatusLineNC = { fg = c.rainGray, bg = c.matrixInk1 },
    WinBar = { fg = c.rainGreenHi, bg = c.matrixInk0 },
    WinBarNC = { fg = c.rainGray, bg = c.matrixInk0 },

    -- Tabline
    TabLine = { fg = c.rainGray, bg = c.matrixInk1 },
    TabLineFill = { bg = c.matrixInk0 },
    TabLineSel = { fg = c.rainGreen, bg = c.matrixInk0, bold = true },

    -- Spell
    SpellBad = { sp = c.alertRed, undercurl = true },
    SpellCap = { sp = c.alertYellow, undercurl = true },
    SpellLocal = { sp = c.alertBlue, undercurl = true },
    SpellRare = { sp = c.rainPurple, undercurl = true },

    -- Diff
    DiffAdd = { bg = c.diffAddedBg },
    DiffChange = { bg = c.matrixInk2 },
    DiffDelete = { fg = c.alertRed, bg = c.diffRemovedBg },
    DiffText = { bg = c.matrixInk3 },
    diffAdded = { fg = c.rainGreenDim },
    diffRemoved = { fg = c.alertRed },
    diffChanged = { fg = c.alertBlue },
    diffOldFile = { fg = c.alertRed },
    diffNewFile = { fg = c.rainGreenDim },
    diffFile = { fg = c.alertBlue },
    diffLine = { fg = c.rainGray },
    diffIndexLine = { fg = c.rainCyan },

    -- Directory
    Directory = { fg = c.alertBlue },

    -- Matching
    MatchParen = { fg = c.rainOrange, bold = true },

    -- Title
    Title = { fg = c.rainCyan, bold = true },

    -- Conceal
    Conceal = { fg = c.rainGray },

    -- ===== Syntax Highlighting =====
    Comment = { fg = c.rainGray, italic = true },
    Constant = { fg = c.rainOrange },
    String = { fg = c.rainGreenDim },
    Character = { fg = c.rainGreenDim },
    Number = { fg = c.rainOrange },
    Boolean = { fg = c.rainOrange },
    Float = { fg = c.rainOrange },

    Identifier = { fg = c.rainGreenHi },
    Function = { fg = c.alertBlue },

    Statement = { fg = c.rainPurple },
    Conditional = { fg = c.rainPurple },
    Repeat = { fg = c.rainPurple },
    Label = { fg = c.rainPurple },
    Operator = { fg = c.rainTeal },
    Keyword = { fg = c.rainPurple },
    Exception = { fg = c.rainPurple },

    PreProc = { fg = c.rainCyan },
    Include = { fg = c.rainPurple },
    Define = { fg = c.rainPurple },
    Macro = { fg = c.rainCyan },
    PreCondit = { fg = c.rainCyan },

    Type = { fg = c.alertYellow },
    StorageClass = { fg = c.alertYellow },
    Structure = { fg = c.alertYellow },
    Typedef = { fg = c.alertYellow },

    Special = { fg = c.rainTeal },
    SpecialChar = { fg = c.rainOrange },
    Tag = { fg = c.rainCyan },
    Delimiter = { fg = c.rainGreenHi },
    SpecialComment = { fg = c.rainGray },
    Debug = { fg = c.rainOrange },

    Underlined = { underline = true },
    Ignore = { fg = c.matrixInk3 },
    Error = { fg = c.alertRed },
    Todo = { fg = c.matrixInk0, bg = c.alertYellow, bold = true },

    -- ===== Treesitter =====
    ["@comment"] = { link = "Comment" },
    ["@error"] = { link = "Error" },
    ["@none"] = { fg = c.none },
    ["@preproc"] = { link = "PreProc" },
    ["@define"] = { link = "Define" },
    ["@operator"] = { link = "Operator" },

    ["@punctuation.delimiter"] = { fg = c.rainGreenHi },
    ["@punctuation.bracket"] = { fg = c.rainGreenHi },
    ["@punctuation.special"] = { fg = c.rainTeal },

    ["@string"] = { link = "String" },
    ["@string.regex"] = { fg = c.rainTeal },
    ["@string.escape"] = { fg = c.rainOrange },
    ["@string.special"] = { fg = c.rainOrange },

    ["@character"] = { link = "Character" },
    ["@character.special"] = { link = "SpecialChar" },

    ["@boolean"] = { link = "Boolean" },
    ["@number"] = { link = "Number" },
    ["@float"] = { link = "Float" },

    ["@function"] = { fg = c.alertBlue },
    ["@function.builtin"] = { fg = c.alertBlue },
    ["@function.call"] = { fg = c.alertBlue },
    ["@function.macro"] = { fg = c.rainCyan },

    ["@method"] = { fg = c.alertBlue },
    ["@method.call"] = { fg = c.alertBlue },

    ["@constructor"] = { fg = c.rainCyan },
    ["@parameter"] = { fg = c.rainGreenHi },

    ["@keyword"] = { fg = c.rainPurple },
    ["@keyword.function"] = { fg = c.rainPurple },
    ["@keyword.operator"] = { fg = c.rainPurple },
    ["@keyword.return"] = { fg = c.rainPurple },

    ["@conditional"] = { link = "Conditional" },
    ["@repeat"] = { link = "Repeat" },
    ["@debug"] = { link = "Debug" },
    ["@label"] = { link = "Label" },
    ["@include"] = { link = "Include" },
    ["@exception"] = { link = "Exception" },

    ["@type"] = { fg = c.alertYellow },
    ["@type.builtin"] = { fg = c.alertYellow },
    ["@type.definition"] = { fg = c.alertYellow },
    ["@type.qualifier"] = { fg = c.rainPurple },

    ["@storageclass"] = { link = "StorageClass" },
    ["@attribute"] = { fg = c.rainCyan },
    ["@field"] = { fg = c.rainGreenHi },
    ["@property"] = { fg = c.rainGreenHi },

    ["@variable"] = { fg = c.rainGreenHi },
    ["@variable.builtin"] = { fg = c.rainOrange },

    ["@constant"] = { fg = c.rainOrange },
    ["@constant.builtin"] = { fg = c.rainOrange },
    ["@constant.macro"] = { fg = c.rainOrange },

    ["@namespace"] = { fg = c.rainCyan },
    ["@symbol"] = { fg = c.rainTeal },

    ["@text"] = { fg = c.rainGreenHi },
    ["@text.title"] = { fg = c.rainCyan, bold = true },
    ["@text.literal"] = { fg = c.rainGreenDim },
    ["@text.uri"] = { fg = c.alertBlue, underline = true },
    ["@text.math"] = { fg = c.rainOrange },
    ["@text.environment"] = { fg = c.rainPurple },
    ["@text.environment.name"] = { fg = c.alertYellow },
    ["@text.reference"] = { fg = c.rainTeal },
    ["@text.todo"] = { link = "Todo" },
    ["@text.note"] = { fg = c.matrixInk0, bg = c.alertBlue },
    ["@text.warning"] = { fg = c.matrixInk0, bg = c.alertYellow },
    ["@text.danger"] = { fg = c.matrixInk0, bg = c.alertRed },
    ["@text.diff.add"] = { link = "diffAdded" },
    ["@text.diff.delete"] = { link = "diffRemoved" },

    ["@text.strong"] = { bold = true },
    ["@text.emphasis"] = { italic = true },
    ["@text.underline"] = { underline = true },
    ["@text.strike"] = { strikethrough = true },

    ["@tag"] = { fg = c.rainCyan },
    ["@tag.attribute"] = { fg = c.rainGreenHi },
    ["@tag.delimiter"] = { fg = c.rainGray },

    -- ===== LSP Semantic Tokens =====
    ["@lsp.type.class"] = { link = "@type" },
    ["@lsp.type.comment"] = { link = "@comment" },
    ["@lsp.type.decorator"] = { link = "@attribute" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.interface"] = { link = "@type" },
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.macro"] = { link = "@function.macro" },
    ["@lsp.type.method"] = { link = "@method" },
    ["@lsp.type.namespace"] = { link = "@namespace" },
    ["@lsp.type.parameter"] = { link = "@parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.struct"] = { link = "@type" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.typeParameter"] = { link = "@type" },
    ["@lsp.type.variable"] = { link = "@variable" },

    -- ===== Diagnostics =====
    DiagnosticError = { fg = c.alertRed },
    DiagnosticWarn = { fg = c.alertYellow },
    DiagnosticInfo = { fg = c.alertBlue },
    DiagnosticHint = { fg = c.rainTeal },
    DiagnosticOk = { fg = c.rainGreenDim },

    DiagnosticVirtualTextError = { fg = c.alertRed, bg = c.diffRemovedBg },
    DiagnosticVirtualTextWarn = { fg = c.alertYellow, bg = c.matrixInk1 },
    DiagnosticVirtualTextInfo = { fg = c.alertBlue, bg = c.matrixInk1 },
    DiagnosticVirtualTextHint = { fg = c.rainTeal, bg = c.matrixInk1 },

    DiagnosticUnderlineError = { sp = c.alertRed, undercurl = true },
    DiagnosticUnderlineWarn = { sp = c.alertYellow, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.alertBlue, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.rainTeal, undercurl = true },

    -- ===== LSP =====
    LspReferenceText = { bg = c.matrixInk2 },
    LspReferenceRead = { bg = c.matrixInk2 },
    LspReferenceWrite = { bg = c.matrixInk2 },
    LspSignatureActiveParameter = { fg = c.rainOrange, bold = true },
    LspCodeLens = { fg = c.rainGray },
    LspInlayHint = { fg = c.rainGray, bg = c.matrixInk1 },

    -- ===== Git Signs =====
    GitSignsAdd = { fg = c.rainGreenDim },
    GitSignsChange = { fg = c.alertBlue },
    GitSignsDelete = { fg = c.alertRed },

    -- ===== Telescope =====
    TelescopeNormal = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    TelescopeBorder = { fg = c.matrixInk3, bg = c.matrixInk1 },
    TelescopeTitle = { fg = c.rainGreen, bold = true },
    TelescopePromptNormal = { fg = c.rainGreenHi, bg = c.matrixInk2 },
    TelescopePromptBorder = { fg = c.matrixInk3, bg = c.matrixInk2 },
    TelescopePromptTitle = { fg = c.rainGreen, bg = c.matrixInk2, bold = true },
    TelescopePromptPrefix = { fg = c.rainGreen },
    TelescopeResultsNormal = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    TelescopeResultsBorder = { fg = c.matrixInk3, bg = c.matrixInk1 },
    TelescopePreviewNormal = { fg = c.rainGreenHi, bg = c.matrixInk0 },
    TelescopePreviewBorder = { fg = c.matrixInk3, bg = c.matrixInk0 },
    TelescopeSelection = { fg = c.rainGreen, bg = c.matrixInk3 },
    TelescopeSelectionCaret = { fg = c.rainGreen },
    TelescopeMatching = { fg = c.alertYellow, bold = true },

    -- ===== NvimTree =====
    NvimTreeNormal = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    NvimTreeNormalNC = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    NvimTreeRootFolder = { fg = c.rainGreen, bold = true },
    NvimTreeFolderName = { fg = c.alertBlue },
    NvimTreeFolderIcon = { fg = c.alertBlue },
    NvimTreeOpenedFolderName = { fg = c.alertBlue },
    NvimTreeEmptyFolderName = { fg = c.rainGray },
    NvimTreeIndentMarker = { fg = c.rainGrayDim },
    NvimTreeGitDirty = { fg = c.alertYellow },
    NvimTreeGitNew = { fg = c.rainGreenDim },
    NvimTreeGitDeleted = { fg = c.alertRed },
    NvimTreeSpecialFile = { fg = c.rainPurple },
    NvimTreeImageFile = { fg = c.rainGreenHi },
    NvimTreeSymlink = { fg = c.rainCyan },

    -- ===== Neo-tree =====
    NeoTreeNormal = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    NeoTreeNormalNC = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    NeoTreeRootName = { fg = c.rainGreen, bold = true },
    NeoTreeDirectoryName = { fg = c.alertBlue },
    NeoTreeDirectoryIcon = { fg = c.alertBlue },
    NeoTreeFileName = { fg = c.rainGreenHi },
    NeoTreeFileIcon = { fg = c.rainGreenHi },
    NeoTreeIndentMarker = { fg = c.rainGrayDim },
    NeoTreeGitAdded = { fg = c.rainGreenDim },
    NeoTreeGitModified = { fg = c.alertYellow },
    NeoTreeGitDeleted = { fg = c.alertRed },
    NeoTreeGitUntracked = { fg = c.rainOrange },

    -- ===== Indent Blankline =====
    IndentBlanklineChar = { fg = c.rainGrayDim },
    IndentBlanklineContextChar = { fg = c.rainGray },
    IblIndent = { fg = c.rainGrayDim },
    IblScope = { fg = c.rainGray },

    -- ===== Which Key =====
    WhichKey = { fg = c.rainGreen },
    WhichKeyGroup = { fg = c.alertBlue },
    WhichKeyDesc = { fg = c.rainGreenHi },
    WhichKeySeperator = { fg = c.rainGray },
    WhichKeySeparator = { fg = c.rainGray },
    WhichKeyFloat = { bg = c.matrixInk1 },
    WhichKeyValue = { fg = c.rainGray },

    -- ===== Dashboard =====
    DashboardHeader = { fg = c.rainGreen },
    DashboardCenter = { fg = c.rainGreenHi },
    DashboardFooter = { fg = c.rainGray },
    DashboardShortCut = { fg = c.rainCyan },

    -- ===== Lazy =====
    LazyH1 = { fg = c.matrixInk0, bg = c.rainGreen, bold = true },
    LazyButton = { fg = c.rainGreenHi, bg = c.matrixInk2 },
    LazyButtonActive = { fg = c.matrixInk0, bg = c.rainGreen },
    LazySpecial = { fg = c.rainCyan },
    LazyProgressDone = { fg = c.rainGreen },
    LazyProgressTodo = { fg = c.rainGrayDim },

    -- ===== Notify =====
    NotifyERRORBorder = { fg = c.alertRed },
    NotifyWARNBorder = { fg = c.alertYellow },
    NotifyINFOBorder = { fg = c.alertBlue },
    NotifyDEBUGBorder = { fg = c.rainGray },
    NotifyTRACEBorder = { fg = c.rainPurple },
    NotifyERRORIcon = { fg = c.alertRed },
    NotifyWARNIcon = { fg = c.alertYellow },
    NotifyINFOIcon = { fg = c.alertBlue },
    NotifyDEBUGIcon = { fg = c.rainGray },
    NotifyTRACEIcon = { fg = c.rainPurple },
    NotifyERRORTitle = { fg = c.alertRed },
    NotifyWARNTitle = { fg = c.alertYellow },
    NotifyINFOTitle = { fg = c.alertBlue },
    NotifyDEBUGTitle = { fg = c.rainGray },
    NotifyTRACETitle = { fg = c.rainPurple },

    -- ===== Cmp =====
    CmpItemAbbr = { fg = c.rainGreenHi },
    CmpItemAbbrDeprecated = { fg = c.rainGray, strikethrough = true },
    CmpItemAbbrMatch = { fg = c.rainGreen, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = c.rainGreen, bold = true },
    CmpItemKind = { fg = c.rainCyan },
    CmpItemMenu = { fg = c.rainGray },
    CmpItemKindClass = { fg = c.alertYellow },
    CmpItemKindColor = { fg = c.rainOrange },
    CmpItemKindConstant = { fg = c.rainOrange },
    CmpItemKindConstructor = { fg = c.rainCyan },
    CmpItemKindEnum = { fg = c.alertYellow },
    CmpItemKindEnumMember = { fg = c.rainOrange },
    CmpItemKindEvent = { fg = c.rainPurple },
    CmpItemKindField = { fg = c.rainGreenHi },
    CmpItemKindFile = { fg = c.rainGreenHi },
    CmpItemKindFolder = { fg = c.alertBlue },
    CmpItemKindFunction = { fg = c.alertBlue },
    CmpItemKindInterface = { fg = c.alertYellow },
    CmpItemKindKeyword = { fg = c.rainPurple },
    CmpItemKindMethod = { fg = c.alertBlue },
    CmpItemKindModule = { fg = c.rainCyan },
    CmpItemKindOperator = { fg = c.rainTeal },
    CmpItemKindProperty = { fg = c.rainGreenHi },
    CmpItemKindReference = { fg = c.rainTeal },
    CmpItemKindSnippet = { fg = c.rainOrange },
    CmpItemKindStruct = { fg = c.alertYellow },
    CmpItemKindText = { fg = c.rainGreenHi },
    CmpItemKindTypeParameter = { fg = c.alertYellow },
    CmpItemKindUnit = { fg = c.rainOrange },
    CmpItemKindValue = { fg = c.rainOrange },
    CmpItemKindVariable = { fg = c.rainGreenHi },

    -- ===== Snacks =====
    SnacksNormal = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    SnacksPicker = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    SnacksPickerBorder = { fg = c.rainGrayDim, bg = c.matrixInk1 },
    SnacksPickerTitle = { fg = c.rainGreen, bold = true },
    SnacksPickerMatch = { fg = c.alertYellow, bold = true },
    SnacksPickerSelected = { fg = c.rainGreen, bg = c.matrixInk3 },
    SnacksPickerDir = { fg = c.rainGray },
    SnacksPickerFile = { fg = c.rainGreenHi },
    SnacksPickerPathHidden = { fg = c.rainGray },
    SnacksPickerPathIgnored = { fg = c.rainGrayDim },
    SnacksExplorerNormal = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    SnacksExplorerDirectory = { fg = c.alertBlue },
    SnacksExplorerFile = { fg = c.rainGreenHi },
    SnacksIndent = { fg = c.rainGrayDim },
    SnacksIndentScope = { fg = c.rainGray },

    -- ===== Mini =====
    MiniStatuslineDevinfo = { fg = c.rainGreenHi, bg = c.matrixInk2 },
    MiniStatuslineFileinfo = { fg = c.rainGreenHi, bg = c.matrixInk2 },
    MiniStatuslineFilename = { fg = c.rainGray, bg = c.matrixInk1 },
    MiniStatuslineInactive = { fg = c.rainGray, bg = c.matrixInk1 },
    MiniStatuslineModeCommand = { fg = c.matrixInk0, bg = c.alertYellow, bold = true },
    MiniStatuslineModeInsert = { fg = c.matrixInk0, bg = c.rainGreen, bold = true },
    MiniStatuslineModeNormal = { fg = c.matrixInk0, bg = c.alertBlue, bold = true },
    MiniStatuslineModeOther = { fg = c.matrixInk0, bg = c.rainTeal, bold = true },
    MiniStatuslineModeReplace = { fg = c.matrixInk0, bg = c.alertRed, bold = true },
    MiniStatuslineModeVisual = { fg = c.matrixInk0, bg = c.rainPurple, bold = true },

    -- ===== Bufferline =====
    BufferLineFill = { bg = c.matrixInk0 },
    BufferLineBackground = { fg = c.rainGray, bg = c.matrixInk1 },
    BufferLineBuffer = { fg = c.rainGray, bg = c.matrixInk1 },
    BufferLineBufferSelected = { fg = c.rainGreen, bg = c.matrixInk0, bold = true },
    BufferLineBufferVisible = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    BufferLineCloseButton = { fg = c.rainGray, bg = c.matrixInk1 },
    BufferLineCloseButtonSelected = { fg = c.alertRed, bg = c.matrixInk0 },
    BufferLineCloseButtonVisible = { fg = c.rainGray, bg = c.matrixInk1 },
    BufferLineIndicatorSelected = { fg = c.rainGreen, bg = c.matrixInk0 },
    BufferLineModified = { fg = c.alertYellow, bg = c.matrixInk1 },
    BufferLineModifiedSelected = { fg = c.alertYellow, bg = c.matrixInk0 },
    BufferLineModifiedVisible = { fg = c.alertYellow, bg = c.matrixInk1 },
    BufferLineSeparator = { fg = c.matrixInk0, bg = c.matrixInk1 },
    BufferLineSeparatorSelected = { fg = c.matrixInk0, bg = c.matrixInk0 },
    BufferLineSeparatorVisible = { fg = c.matrixInk0, bg = c.matrixInk1 },
    BufferLineTab = { fg = c.rainGray, bg = c.matrixInk1 },
    BufferLineTabSelected = { fg = c.rainGreen, bg = c.matrixInk0 },
    BufferLineTabClose = { fg = c.alertRed, bg = c.matrixInk1 },

    -- ===== Lualine (handled via theme export) =====

    -- ===== Markdown =====
    markdownH1 = { fg = c.rainCyan, bold = true },
    markdownH2 = { fg = c.rainCyan, bold = true },
    markdownH3 = { fg = c.rainCyan, bold = true },
    markdownH4 = { fg = c.rainCyan, bold = true },
    markdownH5 = { fg = c.rainCyan, bold = true },
    markdownH6 = { fg = c.rainCyan, bold = true },
    markdownHeadingDelimiter = { fg = c.rainCyan },
    markdownCode = { fg = c.rainGreenDim },
    markdownCodeBlock = { fg = c.rainGreenHi },
    markdownCodeDelimiter = { fg = c.rainGray },
    markdownBlockquote = { fg = c.rainGray },
    markdownListMarker = { fg = c.alertBlue },
    markdownOrderedListMarker = { fg = c.rainTeal },
    markdownRule = { fg = c.rainGray },
    markdownLinkText = { fg = c.rainTeal },
    markdownUrl = { fg = c.alertBlue, underline = true },
    markdownLink = { fg = c.alertBlue },
    markdownBold = { bold = true },
    markdownItalic = { italic = true },

    -- ===== Flash =====
    FlashBackdrop = { fg = c.rainGray },
    FlashLabel = { fg = c.matrixInk0, bg = c.rainGreen, bold = true },
    FlashMatch = { fg = c.rainGreenHi, bg = c.matrixInk3 },
    FlashCurrent = { fg = c.matrixInk0, bg = c.alertYellow },

    -- ===== Noice =====
    NoiceCmdlinePopup = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    NoiceCmdlinePopupBorder = { fg = c.matrixInk3 },
    NoiceCmdlineIcon = { fg = c.rainGreen },
    NoicePopupmenu = { fg = c.rainGreenHi, bg = c.matrixInk1 },
    NoicePopupmenuBorder = { fg = c.matrixInk3 },
    NoicePopupmenuSelected = { fg = c.matrixInk0, bg = c.rainGreen },
  }

  -- Apply highlights
  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

-- Lualine theme
M.lualine = {
  normal = {
    a = { fg = "#0a0e0a", bg = "#30b3ff", gui = "bold" },
    b = { fg = "#62ff94", bg = "#141c12" },
    c = { fg = "#8ca391", bg = "#0e130d" },
  },
  insert = {
    a = { fg = "#0a0e0a", bg = "#2eff6a", gui = "bold" },
    b = { fg = "#62ff94", bg = "#141c12" },
    c = { fg = "#8ca391", bg = "#0e130d" },
  },
  visual = {
    a = { fg = "#0a0e0a", bg = "#c770ff", gui = "bold" },
    b = { fg = "#62ff94", bg = "#141c12" },
    c = { fg = "#8ca391", bg = "#0e130d" },
  },
  replace = {
    a = { fg = "#0a0e0a", bg = "#ff4b4b", gui = "bold" },
    b = { fg = "#62ff94", bg = "#141c12" },
    c = { fg = "#8ca391", bg = "#0e130d" },
  },
  command = {
    a = { fg = "#0a0e0a", bg = "#e6ff57", gui = "bold" },
    b = { fg = "#62ff94", bg = "#141c12" },
    c = { fg = "#8ca391", bg = "#0e130d" },
  },
  inactive = {
    a = { fg = "#8ca391", bg = "#0e130d" },
    b = { fg = "#8ca391", bg = "#0e130d" },
    c = { fg = "#8ca391", bg = "#0e130d" },
  },
}

return M
