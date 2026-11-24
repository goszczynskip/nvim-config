local M = {}

-- Neutral editor chrome; syntax accents from OpenCode's OC-2 Dark palette.
local c = {
  panel = "#1C1C1C",
  raised = "#242424",
  selection = "#363636",
  border = "#454545",
  muted = "#AEAEAE",
  text = "#FAFAFA",
  keyword = "#F799C6",
  string = "#96E3A6",
  property = "#FFC1A4",
  type = "#9E99F7",
  constant = "#93E9F6",
  error = "#F29B96",
}

function M.setup()
  vim.cmd("highlight clear")
  vim.o.termguicolors = true
  vim.g.colors_name = "opencode-dark"

  local groups = {
    Normal = { fg = c.text },
    NormalNC = { link = "Normal" },
    NormalFloat = { fg = c.text, bg = c.panel },
    FloatBorder = { fg = c.border, bg = c.panel },
    FloatTitle = { fg = c.text, bg = c.panel, bold = true },
    WinSeparator = { fg = c.border },
    LineNr = { fg = c.muted },
    CursorLineNr = { fg = c.text, bold = true },
    CursorLine = { bg = c.raised },
    Visual = { bg = c.selection },
    Pmenu = { link = "NormalFloat" },
    PmenuSel = { fg = c.text, bg = c.selection },
    StatusLine = { fg = c.text, bg = c.raised },
    StatusLineNC = { fg = c.muted, bg = c.panel },
    EndOfBuffer = { fg = c.border },
    Search = { fg = c.panel, bg = c.property },
    CurSearch = { fg = c.panel, bg = c.constant },

    Comment = { fg = c.muted },
    Statement = { fg = c.keyword },
    String = { fg = c.string },
    Number = { fg = c.keyword },
    Constant = { fg = c.constant },
    Function = { fg = c.property },
    Type = { fg = c.type },
    Identifier = { fg = c.text },
    PreProc = { link = "Statement" },
    Special = { link = "Constant" },
    ["@variable"] = { link = "Identifier" },
    ["@variable.member"] = { fg = c.property },
    ["@property"] = { link = "@variable.member" },
    ["@punctuation"] = { link = "Normal" },

    DiagnosticError = { fg = c.error },
    DiagnosticWarn = { fg = c.property },
    DiagnosticInfo = { fg = c.constant },
    DiagnosticHint = { fg = c.muted },
    Added = { fg = c.string },
    Changed = { fg = c.property },
    Removed = { fg = c.error },
    DiffAdd = { bg = "#193324" },
    DiffChange = { bg = "#30291F" },
    DiffDelete = { bg = "#391F20" },
    DiffText = { bg = "#494033" },

    SnacksPicker = { link = "Normal" },
    SnacksPickerList = { link = "SnacksPicker" },
    SnacksPickerInput = { link = "SnacksPicker" },
    SnacksPickerBox = { link = "SnacksPicker" },
    SnacksPickerBorder = { fg = c.border },
    SnacksPickerInputBorder = { link = "SnacksPickerBorder" },
    SnacksPickerTitle = { fg = c.text, bold = true },
    SnacksPickerInputTitle = { link = "SnacksPickerTitle" },
    SnacksPickerBoxTitle = { link = "SnacksPickerTitle" },
    SnacksPickerDirectory = { link = "Normal" },
    SnacksPickerDir = { fg = c.muted },
    SnacksPickerFile = { link = "Normal" },
    SnacksPickerTree = { fg = c.border },
    SnacksPickerPrompt = { fg = c.muted },
    SnacksPickerListCursorLine = { link = "Visual" },
  }

  for name, highlight in pairs(groups) do
    vim.api.nvim_set_hl(0, name, highlight)
  end
end

function M.statusline()
  local function sections(accent)
    return {
      a = { fg = accent, bg = c.selection, gui = "bold" },
      b = { fg = c.text, bg = c.raised },
      c = { fg = c.muted, bg = c.panel },
    }
  end

  return {
    normal = sections(c.text),
    insert = sections(c.string),
    visual = sections(c.type),
    replace = sections(c.error),
    command = sections(c.property),
    inactive = sections(c.muted),
  }
end

return M
