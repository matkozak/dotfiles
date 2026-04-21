-- ~/.config/nvim/init.lua
-- Targeting Neovim 0.12+ (uses vim.pack)

-- Leader
vim.g.mapleader = " " -- prefix for custom mappings (set before plugins)
vim.g.maplocalleader = " " -- buffer-local mapping prefix (used by some plugins)

-- Display
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- make them relative to current line
vim.opt.signcolumn = "yes" -- always show gutter (git signs etc.)
vim.opt.statuscolumn = "%s%=%l " -- signs first, right-aligned numbers second
vim.opt.termguicolors = true -- 24-bit color
vim.opt.cursorline = true -- highlight current line
vim.opt.scrolloff = 10 -- keep cursor away from top/bottom edges
vim.opt.sidescrolloff = 8 -- keep cursor away from left/right edges
vim.opt.smoothscroll = true -- smooth <C-d>/<C-u> jumps
vim.opt.wrap = false -- no line wrapping
vim.opt.list = true -- show whitespace characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- map whitespace chars

-- Editing
vim.opt.mouse = "a" -- mouse support
vim.opt.clipboard = "unnamedplus" -- use OS clipboard
vim.opt.undofile = true -- persist undo history across sessions
vim.opt.breakindent = true -- wrapped lines continue visually indented (when wrap is on)
vim.opt.linebreak = true -- wrap at word boundaries (when wrap is on)
vim.opt.completeopt = { "menuone" } -- show menu even for single match, no auto-insert

-- Indentation
vim.opt.tabstop = 4 -- tab width
vim.opt.shiftwidth = 4 -- indent width
vim.opt.expandtab = true -- use spaces
vim.opt.shiftround = true -- round indent to multiple of shiftwidth

-- Search
vim.opt.ignorecase = true -- case-insensitive by default
vim.opt.smartcase = true -- case-sensitive if uppercase used
vim.opt.hlsearch = true -- highlight matches
vim.opt.inccommand = "split" -- live preview of :s substitutions

-- Splits
vim.opt.splitright = true -- :vsp right
vim.opt.splitbelow = true -- :sp down

-- Performance
vim.opt.updatetime = 250 -- faster CursorHold and swap writes
vim.opt.swapfile = false -- undofile is enough
vim.opt.autowrite = true -- auto-save on buffer switch / :make

-- Keymaps
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- clear search highlight
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]]) -- exit terminal mode
vim.keymap.set("n", "Q", "<nop>") -- disable ex mode
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<cr>") -- C-k up
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<cr>") -- C-j down
vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<cr>") -- C-h left
vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<cr>") -- C-l right
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float) -- show diagnostic float
vim.keymap.set("v", "<", "<gv") -- stay in visual after dedent
vim.keymap.set("v", ">", ">gv") -- stay in visual after indent
vim.keymap.set("n", "<leader>q", "gqip") -- reflow paragraph to text width
vim.keymap.set("n", "<leader>Q", "gggqG") -- reflow entire document to text width

--Commands
vim.api.nvim_create_user_command("Reload", function()
	vim.cmd("source $MYVIMRC")
end, {})

-- Diagnostics
vim.diagnostic.config({
	severity_sort = true, -- errors before warnings
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
		numhl = { -- color the line number by severity (gutter left for git signs)
			[vim.diagnostic.severity.ERROR] = "DiagnosticNumError",
			[vim.diagnostic.severity.WARN] = "DiagnosticNumWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticNumInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticNumHint",
		},
	},
	virtual_text = false, -- no inline text, signs + numhl are enough
	underline = true,
})

-- Reload files changed outside nvim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Soft wrap + spell for prose filetypes (gitcommit handled by ftplugin)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en,fr,pl"
	end,
})

-- Recompile parsers when treesitter is updated
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

-- Plugins
vim.pack.add({
	{ src = "https://github.com/HiPhish/rainbow-delimiters.nvim", version = "master" },
	{ src = "https://github.com/ibhagwan/fzf-lua", version = "main" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim", version = "main" },
	{ src = "https://github.com/neovim/nvim-lspconfig", version = "master" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/stevearc/conform.nvim", version = "master" },
})

-- Colorscheme
vim.opt.background = "dark"
vim.cmd.colorscheme("plaster")

-- Treesitter: syntax highlighting via AST parsing.
require("nvim-treesitter").install({
	"latex",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"r",
	"rust",
})

-- LSP server config
-- servers must be installed and available in PATH
vim.lsp.enable({ "pyright", "ruff", "rust_analyzer" })

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

-- Format on save via LSP.
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- prettier
		astro = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },
		svelte = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettierd", "prettier", stop_after_first = true },
	},
	default_format_opts = { lsp_format = "fallback" },
	format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
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
