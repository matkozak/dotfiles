vim.cmd("hi clear")
vim.g.colors_name = "plaster"

if vim.o.termguicolors then
	vim.notify("ansibaster: disabling termguicolors (16-color theme)", vim.log.levels.INFO)
	vim.opt.termguicolors = false
end

local function hi(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- semantic aliases
-- ANSI 16-color palette plus terminal bg/fg
-- TODO: consider switching fg value
-- based on dark / light mode (16 for light).
local syntax = {
	fg = 231,
	string = "green",
	constant = "yellow",
	comment = "red",
	definition = "blue",
	punct = "gray",
	special = "cyan",
}

local diag = {
	error = "darkred",
	warning = "darkyellow",
	info = "darkcyan",
	hint = "gray",
}

local git = {
	added = "darkgreen",
	changed = "darkcyan",
	deleted = "darkred",
}

local ui = {
	-- bg levels: NONE (default) < black (0) < bright black (8)
	bg0 = "NONE",
	bg1 = "black",
	bg2 = "darkgray",
	-- fg levels: NONE (default) > bright white (15) > white (7)
	fg0 = "NONE",
	fg1 = "white",
	fg2 = "gray",
	accent = "magenta",
	search = "darkcyan",
	search_active = "darkblue",
	-- statusline mode colors
	sl_insert = "darkgreen",
	sl_visual = "darkmagenta",
	sl_replace = "darkred",
	sl_command = "darkyellow",
}

-- ============
-- Neovim UI ==
-- ============

-- Rounded borders instead of background for floating windows
vim.o.winborder = "rounded"

hi("Normal", { ctermfg = syntax.fg })
hi("NormalFloat", {})
hi("FloatBorder", { ctermfg = ui.fg2 })
hi("FloatTitle", { ctermfg = syntax.definition, bold = true })
hi("Visual", { ctermbg = ui.bg2 })
hi("Search", { ctermbg = ui.search })
hi("IncSearch", { ctermbg = ui.search_active })
hi("CurSearch", { ctermbg = ui.search_active })
hi("Substitute", { ctermbg = ui.search_active })
hi("CursorLine", { ctermbg = ui.bg1 })
hi("CursorColumn", { ctermbg = ui.bg1 })
hi("CursorLineNr", { ctermfg = ui.fg1 })
hi("LineNr", { ctermfg = ui.bg2 })
hi("SignColumn", {})
hi("ColorColumn", { ctermbg = ui.bg1 })
hi("VertSplit", { ctermfg = ui.bg2 })
hi("WinSeparator", { ctermfg = ui.bg2 })
hi("Folded", { ctermfg = ui.fg2, ctermbg = ui.bg1 })
hi("FoldColumn", { ctermfg = ui.fg2 })
hi("NonText", { ctermfg = ui.bg2 })
hi("SpecialKey", { ctermfg = ui.bg2 })
hi("Whitespace", { ctermfg = ui.bg2 })
hi("EndOfBuffer", { ctermfg = ui.bg2 })
hi("MatchParen", { underline = true, bold = true })
hi("Conceal", { ctermfg = ui.fg2 })
hi("Directory", { ctermfg = syntax.definition })
hi("Cursor", { reverse = true })
hi("TermCursor", { reverse = true })
hi("lCursor", { reverse = true })

-- statusline
hi("StatusLine", { ctermfg = ui.fg1, ctermbg = ui.bg2 })
hi("StatusLineNC", { ctermfg = ui.fg2, ctermbg = ui.bg1 })
hi("StatusLineInsert", { ctermfg = ui.bg1, ctermbg = ui.sl_insert })
hi("StatusLineVisual", { ctermfg = ui.bg1, ctermbg = ui.sl_visual })
hi("StatusLineReplace", { ctermfg = ui.bg1, ctermbg = ui.sl_replace })
hi("StatusLineCommand", { ctermfg = ui.bg1, ctermbg = ui.sl_command })
hi("WinBar", { ctermfg = ui.fg2, bold = true })
hi("WinBarNC", { ctermfg = ui.bg2 })
hi("WildMenu", { ctermfg = ui.bg1, ctermbg = syntax.definition })

-- tabline
hi("TabLine", { ctermfg = ui.fg2, ctermbg = ui.bg1 })
hi("TabLineFill", { ctermbg = ui.bg1 })
hi("TabLineSel", { ctermfg = ui.fg1, bold = true })

-- completion menu
hi("Pmenu", { ctermbg = ui.bg1 })
hi("PmenuSel", { ctermbg = ui.bg2, bold = true })
hi("PmenuKind", { ctermfg = syntax.definition, ctermbg = ui.bg1 })
hi("PmenuKindSel", { ctermfg = syntax.definition, ctermbg = ui.bg2, bold = true })
hi("PmenuSbar", { ctermbg = ui.bg2 })
hi("PmenuThumb", { ctermbg = ui.fg2 })

-- messages
hi("ErrorMsg", { ctermfg = diag.error })
hi("WarningMsg", { ctermfg = diag.warning })
hi("ModeMsg", { bold = true })
hi("MoreMsg", { ctermfg = syntax.definition })
hi("Question", { ctermfg = syntax.definition })
hi("Title", { ctermfg = syntax.definition, bold = true })

-- spelling
hi("SpellBad", { undercurl = true, ctermfg = diag.error })
hi("SpellCap", { undercurl = true, ctermfg = diag.warning })
hi("SpellRare", { undercurl = true, ctermfg = diag.info })
hi("SpellLocal", { undercurl = true, ctermfg = diag.hint })

-- diff
hi("DiffAdd", { ctermfg = git.added })
hi("DiffChange", { ctermfg = git.changed })
hi("DiffDelete", { ctermfg = git.deleted })
hi("DiffText", { ctermfg = git.changed, bold = true })

-- highlighted
hi("Comment", { ctermfg = syntax.comment })
hi("Constant", { ctermfg = syntax.constant })
hi("String", { ctermfg = syntax.string })
hi("Character", { ctermfg = syntax.string })
hi("Function", { ctermfg = syntax.definition })
hi("Todo", { ctermfg = ui.bg1, ctermbg = syntax.constant })
hi("Underlined", { underline = true, ctermfg = syntax.definition })

-- diagnostics: signs (gutter)
hi("DiagnosticSignError", { ctermfg = diag.error })
hi("DiagnosticSignWarn", { ctermfg = diag.warning })
hi("DiagnosticSignInfo", { ctermfg = diag.info })
hi("DiagnosticSignHint", { ctermfg = diag.hint })
-- diagnostics: bold line numbers (numhl)
hi("DiagnosticNumError", { ctermfg = diag.error, bold = true })
hi("DiagnosticNumWarn", { ctermfg = diag.warning, bold = true })
hi("DiagnosticNumInfo", { ctermfg = diag.info, bold = true })
hi("DiagnosticNumHint", { ctermfg = diag.hint, bold = true })
-- diagnostics: virtual text / floating
hi("DiagnosticError", { ctermfg = diag.error })
hi("DiagnosticWarn", { ctermfg = diag.warning })
hi("DiagnosticInfo", { ctermfg = diag.info })
hi("DiagnosticHint", { ctermfg = diag.hint })
-- diagnostics: underlines
hi("DiagnosticUnderlineError", { undercurl = true, ctermfg = diag.error })
hi("DiagnosticUnderlineWarn", { undercurl = true, ctermfg = diag.warning })
hi("DiagnosticUnderlineInfo", { undercurl = true, ctermfg = diag.info })
hi("DiagnosticUnderlineHint", { undercurl = true, ctermfg = diag.hint })
hi("DiagnosticUnnecessary", { ctermfg = ui.fg2, undercurl = true })

-- uniform
hi("Identifier", { ctermfg = syntax.fg }) -- any identifier
hi("Statement", { ctermfg = syntax.fg }) -- any statement
hi("Type", { ctermfg = syntax.fg }) -- any type
hi("PreProc", { ctermfg = syntax.fg }) -- generic preprocessor
hi("Special", { ctermfg = syntax.fg }) -- any special symbol

-- punctuation
hi("Operator", { ctermfg = syntax.punct })
hi("Delimiter", { ctermfg = syntax.punct })

-- =============
-- Treesitter ==
-- =============

local ts_plain = {
	-- variables
	"@variable",
	"@variable.builtin",
	"@variable.parameter",
	"@variable.parameter.builtin",
	"@variable.member",
	-- functions
	"@function.builtin", -- built-in functions
	"@function.call", -- function calls
	"@function.macro", -- preprocessor macros
	"@function.method.call", -- method calls
	-- others
	"@attribute",
	"@constructor",
	"@label",
	"@operator",
	"@property",
	-- types
	"@type",
	"@type.builtin",
	"@type.qualifier",
	-- namespaces
	"@module",
	-- keywords
	"@keyword",
	"@keyword.conditional",
	"@keyword.coroutine",
	"@keyword.debug",
	"@keyword.directive",
	"@keyword.exception",
	"@keyword.function",
	"@keyword.import",
	"@keyword.modifier",
	"@keyword.operator",
	"@keyword.repeat",
	"@keyword.return",
	"@keyword.type",
}

for _, group in ipairs(ts_plain) do
	-- hi(group, { ctermfg = syntax.fg })
	hi(group, { link = "Normal" })
end

-- Comments
hi("@comment", { ctermfg = syntax.comment })
hi("@comment.todo", { ctermfg = ui.bg1, ctermbg = syntax.constant })

-- Strings
hi("@character", { ctermfg = syntax.string })
hi("@string", { ctermfg = syntax.string })
hi("@string.escape", { ctermfg = syntax.special })
hi("@string.regexp", { ctermfg = syntax.special })
hi("@string.special", { ctermfg = syntax.special })
hi("@string.special.path", { ctermfg = syntax.string, underline = true })
hi("@string.special.url", { ctermfg = syntax.string, underline = true })

-- Constants & literals
hi("@boolean", { ctermfg = syntax.constant })
hi("@constant", { ctermfg = syntax.constant })
hi("@constant.builtin", { ctermfg = syntax.constant })
hi("@number", { ctermfg = syntax.constant })
hi("@number.float", { ctermfg = syntax.constant })

-- Definitions
hi("@function", { ctermfg = syntax.definition })
hi("@function.method", { ctermfg = syntax.definition })
hi("@type.definition", { ctermfg = syntax.definition })

-- Punctuation
hi("@punctuation", { ctermfg = syntax.punct })
hi("@punctuation.bracket", { ctermfg = syntax.punct })
hi("@punctuation.delimiter", { ctermfg = syntax.punct })
hi("@punctuation.special", { ctermfg = syntax.punct })

-- =============
-- LSP tokens ==
-- =============

local lsp_plain = {
	-- identifiers
	"@lsp.type.class",
	"@lsp.type.enum",
	"@lsp.type.enumMember",
	"@lsp.type.function",
	"@lsp.type.interface",
	"@lsp.type.macro",
	"@lsp.type.method",
	"@lsp.type.namespace",
	"@lsp.type.parameter",
	"@lsp.type.property",
	"@lsp.type.struct",
	"@lsp.type.type",
	"@lsp.type.typeParameter",
	"@lsp.type.variable",
	-- syntax
	"@lsp.type.event",
	"@lsp.type.keyword",
	"@lsp.type.modifier",
	"@lsp.type.operator",
}

for _, group in ipairs(lsp_plain) do
	-- hi(group, { ctermfg = syntax.fg })
	hi(group, { link = "Normal" })
end

-- literals/special
hi("@lsp.type.string", { ctermfg = syntax.string })
hi("@lsp.type.number", { ctermfg = syntax.constant })
hi("@lsp.type.regexp", { ctermfg = syntax.special })
hi("@lsp.type.comment", { ctermfg = syntax.comment })
hi("@lsp.type.decorator", { ctermfg = syntax.punct })
hi("@lsp.type.formatSpecifier", { ctermfg = syntax.special })

-- enumerate what you actually want blue
hi("@lsp.typemod.class.declaration", { ctermfg = syntax.definition })
hi("@lsp.typemod.enum.declaration", { ctermfg = syntax.definition })
hi("@lsp.typemod.function.declaration", { ctermfg = syntax.definition })
hi("@lsp.typemod.interface.declaration", { ctermfg = syntax.definition })
hi("@lsp.typemod.method.declaration", { ctermfg = syntax.definition })
hi("@lsp.typemod.struct.declaration", { ctermfg = syntax.definition })
hi("@lsp.typemod.type.declaration", { ctermfg = syntax.definition })
hi("@lsp.typemod.variable.declaration", { ctermfg = syntax.definition })

-- special
hi("@lsp.mod.deprecated", { strikethrough = true })

-- ============
-- Git Signs ==
-- ============

hi("GitSignsAdd", { ctermfg = git.added, bold = true })
hi("GitSignsChange", { ctermfg = git.changed, bold = true })
hi("GitSignsDelete", { ctermfg = git.deleted, bold = true })
hi("GitSignsChangeDelete", { ctermfg = diag.warning, bold = true })

-- ==========
-- fzf-lua ==
-- ==========

hi("FzfLuaNormal", { link = "Normal" })
hi("FzfLuaBorder", { ctermfg = ui.bg2 })
hi("FzfLuaTitle", { ctermfg = syntax.definition, bold = true })
hi("FzfLuaHeaderBind", { ctermfg = syntax.definition })
hi("FzfLuaHeaderText", { ctermfg = ui.fg2 })
hi("FzfLuaCursorLine", { ctermbg = ui.bg1 })
hi("FzfLuaSearch", { ctermfg = syntax.constant })

-- =====================
-- Rainbow Delimiters ==
-- =====================

-- Cool-warm alternating order, aggressive colors at depth.
vim.g.rainbow_delimiters = {
	highlight = {
		"RainbowDelimiterBlue",
		"RainbowDelimiterYellow",
		"RainbowDelimiterCyan",
		"RainbowDelimiterViolet",
		"RainbowDelimiterGreen",
		"RainbowDelimiterRed",
	},
}

-- =========
-- Markup ==
-- =========

hi("@markup.heading", { ctermfg = syntax.definition, bold = true })
hi("@markup.bold", { bold = true })
hi("@markup.italic", { italic = true })
hi("@markup.strikethrough", { strikethrough = true })
hi("@markup.link", { ctermfg = syntax.definition, underline = true })
hi("@markup.link.url", { ctermfg = syntax.special, underline = true })
hi("@markup.raw", { ctermfg = syntax.string })
hi("@markup.list", { ctermfg = syntax.constant })
hi("@markup.quote", { ctermfg = ui.fg2 })
