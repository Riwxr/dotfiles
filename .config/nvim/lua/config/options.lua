vim.o.relativenumber = true --Relative line numbers
vim.o.number = true --Show numbers

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

vim.opt.expandtab = true  --Tabs into spaces
vim.opt.shiftwidth = 4  --Dedualt tab indentation to be 4
vim.opt.tabstop = 4
vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true --Keep indententaion across line

--How diffrent whitespaces get displayed
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

--Preview substitutions live in the split window thingy, doesnt look good with transpant bg
vim.o.inccommand = 'split'

--Show which line your cursor is on
vim.o.cursorline = true

--Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

--if performing an operation that would fail due to unsaved changes in the buffer (like `:q`) instead raise a dialog asking if you wish to save the current file(s)

vim.o.confirm = true


--Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})


