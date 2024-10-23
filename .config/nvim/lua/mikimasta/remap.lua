vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- end/beginning of line
vim.keymap.set("v", "<leader>l", "$")
vim.keymap.set("n", "<leader>l", "$")
vim.keymap.set("v", "<leader>h", "0")
vim.keymap.set("n", "<leader>h", "0")

-- makes moving paragraphs or lines up and down possible
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keeps cursor in the middle of the file (if possible) while browsing search terms
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- makes pasting on something not rewrite the contents of the void registry thus keeping what you copied first
-- foo bar example (ThePrimeagen)
vim.keymap.set("x", "<leader>p", "\"_dP")

-- yanking straight into system registry so that you can paste stuff apart from vim
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("x", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- paste from system registry
vim.keymap.set("n", "<leader>pp", "\"+p")

-- makes sure mode switching behaves the same in all modes
vim.keymap.set("i", "<C-c>", "<Esc>")

-- dont press Q! ;p
vim.keymap.set("n", "Q", "<nop>")

-- don't interfere with tmux prefix
vim.keymap.set("n", "<C-a>", "<nop>")
vim.keymap.set("v", "<C-a>", "<nop>")
vim.keymap.set("i", "<C-a>", "<nop>")


-- go stuff
local group = vim.api.nvim_create_augroup("go", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.go", command = ":%! goimports" })
