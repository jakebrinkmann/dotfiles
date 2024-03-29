vim.g.mapleader = " "

-- [[ Basic Keymaps ]]
vim.keymap.set("n", "<C-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("n", "<C-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("n", "<C-k>", [[<Cmd>wincmd k<CR>]]) -- This is buggy
vim.keymap.set("n", "<C-l>", [[<Cmd>wincmd l<CR>]])

vim.keymap.set("n", "<C-c>", [[<Cmd>bn|:bd!#<CR>]], { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>vs", vim.cmd.vsplit)

-- [[ \\ switches back/forth between buffers ]]
vim.keymap.set("n", "\\\\", [[<C-^>]])

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Remap the CMap
vim.keymap.set("c", "ZMD", [[<C-R>=strftime("%y%m%d-%H%M-")<CR>]])

-- Format
vim.keymap.set("n", "=a", [[<cmd>lua vim.lsp.buf.format { async = true }<CR>]], { desc = "Format the file" })

-- Escape
vim.keymap.set("i", "kj", [[<Esc>]])

-- TODO: how to do this in lua?
vim.cmd([[
vnoremap > >gv
vnoremap < <gv
]])
