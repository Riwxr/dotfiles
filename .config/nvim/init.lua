--LeaderKeys
vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.o.relativenumber = true --Relative line numbers
-- vim.o.number = true --Show numbers

vim.o.mouse = "" --Disable mouse

vim.o.showmode = false --Removes the fuckin --INSERT-- thingy

--Copy Sync in Nvim and OS
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

--Line warping and all those things for readiblity
vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true

--Save Mah Undos
vim.o.undofile = true

--Assinging W Q as w q for saving
vim.cmd([[
  cabbrev W w
  cabbrev Wq wq
  cabbrev WQ wq
  cabbrev Q q
]])

--Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

--Keep signcolumn on by defaul; looks good to me
vim.o.signcolumn = "yes"

--Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

--How diffrent whitespaces get displayed
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

--Preview substitutions live in the split window thingy, doesnt look good with transpant bg
vim.o.inccommand = "split"

--Show which line your cursor is on
vim.o.cursorline = true

--Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

--if performing an operation that would fail due to unsaved changes in the buffer (like `:q`) instead raise a dialog asking if you wish to save the current file(s)

vim.o.confirm = true

-- [[ Basic Keymaps ]] --

--Clear highlights from serch whn pressing <Esc> in Normal Mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

--Be a MAN
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

--Split navigation using ctrl-hljk
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Basic Autocommands ]] --

--Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]] --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]] --

require("lazy").setup({
	{ import = "plugins" },
})

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
