-- ~/.config/nvim/init.lua
-- Targeting Neovim 0.11+ (uses vim.pack from 0.12)

-- Leader key: prefix for custom mappings. Space is popular because it's easy to hit.
-- Must be set before plugins load so they can reference it.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers: absolute on current line, relative on others.
-- Relative makes jump commands (5j, 12k) easier to eyeball.
vim.opt.number = true
vim.opt.relativenumber = true

-- Mouse support. Handy for resizing splits, scrolling.
vim.opt.mouse = "a"

-- System clipboard integration. Yank goes to OS clipboard.
vim.opt.clipboard = "unnamedplus"

-- Always show the sign column (left gutter) so buffer doesn't shift
-- when diagnostics/git signs appear.
vim.opt.signcolumn = "yes"

-- Status column: signs, then right-aligned line numbers.
-- %=: right-align, %l: line number, %s: sign column (git signs).
vim.opt.statuscolumn = "%s%=%l "

-- Splits open in the direction you'd read: right and down.
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Persist undo history across sessions. Saves to ~/.local/state/nvim/undo/
vim.opt.undofile = true

-- Search: case-insensitive unless you use uppercase.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Faster CursorHold trigger and swap writes. Affects some plugins.
vim.opt.updatetime = 250

-- 24-bit color. Enable for GUI colorschemes.
vim.opt.termguicolors = true

-- Default indentation (fallback when no editorconfig/ftplugin).
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Show trailing whitespace, tabs, non-breaking spaces.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Live preview of :s substitutions in a split.
vim.opt.inccommand = "split"

-- Highlight current line.
vim.opt.cursorline = true

-- Clear search highlight with Escape.
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Wrapped lines continue visually indented.
vim.opt.breakindent = true

-- Escape exits terminal mode (default <C-\><C-n> is awkward).
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- Disable Q (ex mode—useless and easy to hit accidentally).
vim.keymap.set("n", "Q", "<nop>")

-- Navigate splits with Ctrl+hjkl.
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<cr>")
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<cr>")
vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<cr>")

-- Show diagnostic in float with <leader>e (or whatever)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

-- Diagnostic display: severity on line numbers, gutter reserved for git signs.
vim.diagnostic.config({
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticNumError",
			[vim.diagnostic.severity.WARN] = "DiagnosticNumWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticNumInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticNumHint",
		},
	},
	virtual_text = false,
	underline = true,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
	"nvim-treesitter/nvim-treesitter",
	"HiPhish/rainbow-delimiters.nvim",
	"ellisonleao/gruvbox.nvim",
	"ibhagwan/fzf-lua",
	"lewis6991/gitsigns.nvim",
	"neovim/nvim-lspconfig", -- still needed for server definitions
}, {
	performance = {
		rtp = { reset = false }, -- don't mess with runtimepath
	},
})

-- Colorscheme
vim.opt.background = "dark"
vim.cmd.colorscheme("plaster")

-- Treesitter: syntax highlighting via AST parsing.
require("nvim-treesitter.configs").setup({
	ensure_installed = { "rust", "python", "lua" },
	highlight = { enable = true },
})

-- LSP servers (0.11+ native config, no lspconfig plugin needed).
-- Binaries must be in PATH: rust-analyzer, ruff, ty
vim.lsp.enable({ "rust_analyzer", "ruff", "ty" })

-- LSP keybindings + native completion (only active when LSP attaches).
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)

		-- Native LSP completion (0.11+). <C-n>/<C-p> to navigate, <C-y> to accept.
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.opt.completeopt = { "menuone" }

-- Format on save via LSP.
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- fzf-lua: fuzzy finder for files, grep, buffers.
require("fzf-lua").setup({})
vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>sg", "<cmd>FzfLua live_grep<cr>")
vim.keymap.set("n", "<leader>sb", "<cmd>FzfLua buffers<cr>")

-- gitsigns: git gutter + hunk staging.
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
	on_attach = function(bufnr)
		local gs = require("gitsigns")
		local opts = { buffer = bufnr }
		vim.keymap.set("n", "]h", gs.next_hunk, opts)
		vim.keymap.set("n", "[h", gs.prev_hunk, opts)
		vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts)
		vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, opts)
		vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts)
		vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
	end,
})

-- Statusline: mode-aware color + diagnostic counts.
function _G.StatusMode()
	local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
	local hl = ({
		i = "StatusLineInsert",
		v = "StatusLineVisual",
		V = "StatusLineVisual",
		["\22"] = "StatusLineVisual", -- ctrl-v
		R = "StatusLineReplace",
		c = "StatusLineCommand",
	})[mode] or "StatusLine"
	return "%#" .. hl .. "#"
end

function _G.StatusDiag()
	local e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
	local parts = {}
	if e > 0 then
		table.insert(parts, "E:" .. e)
	end
	if w > 0 then
		table.insert(parts, "W:" .. w)
	end
	return #parts > 0 and " " .. table.concat(parts, " ") .. " " or ""
end

vim.opt.statusline = "%{%v:lua.StatusMode()%} %f %m%{%v:lua.StatusDiag()%} %= %l:%c "
