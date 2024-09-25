local popup = require("plenary.popup")

local M = {}

Harbonizer_win_id = nil

local function newWin()
	local height = 10
	local width = 80
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	Harbonizer_win_id = popup.create({
		"1.woooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOOOOow",
		"2.WOW!",
		"3.wtf??",
		"4.sussy",
		"5.baki",
		"6.sigma",
	}, {
		title = "Harpoon",
		--		highlight = "HarpoonWindow",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = borderchars,
		padding = { 2, 2, 2, 2 },
	})
end

local function closeWin()
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
