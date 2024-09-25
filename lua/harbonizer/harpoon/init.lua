local monitor = require("harbonizer.harpoon.monitor")
local marks = require("harbonizer.harpoon.marks")

local M = {}

M.hello = function()
	print("hello function")
end

print("hello harpooner")

M.toggle = function()
	monitor.toggleWin()
end

M.new_mark = function()
	marks.create_mark()
end

M.list = function()
	return marks.get_mark_list()
end

M.nav_to = function(idx)
	marks.nav_to(idx)
end

return M
