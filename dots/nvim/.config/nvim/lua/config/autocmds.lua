local api = vim.api

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- TODO: [[ Highlight variable under cursor ]]
vim.cmd([[
	au CursorHold * :exec 'match Question /\V\<' . expand('<cword>') . '\>/'
]])

api.nvim_create_user_command("W", "noautocmd write", { nargs = 0 })
