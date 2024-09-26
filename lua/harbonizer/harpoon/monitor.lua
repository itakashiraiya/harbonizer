local popup = require("plenary.popup")
local marks = require("harbonizer.harpoon.marks")

local M = {}

Harbonizer_win_id = nil

local function newWin()
	local height = 10
	local width = 80
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	local list = marks.get_mark_list()
	print(vim.inspect(list))

	Harbonizer_win_id = popup.create(list, {
		title = "Harpoon",
		--highlight = "HarpoonWindow",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = borderchars,
		--padding = { 2, 2, 2, 2 },
	})
end

local function closeWin()
	local buf = vim.api.nvim_win_get_buf(Harbonizer_win_id)
	marks.update_mark_order(buf)
	vim.api.nvim_win_close(0, false)
end

M.toggleWin = function()
	if Harbonizer_win_id ~= nil and vim.api.nvim_win_is_valid(Harbonizer_win_id) then
		closeWin()
		return
	end

	newWin()
end

return M
