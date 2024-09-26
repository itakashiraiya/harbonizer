local monitor = require("harbonizer.harpoon.monitor")
local marks = require("harbonizer.harpoon.marks")

local M = {}

M.toggle = function()
	monitor.toggleWin()
end

M.new_mark = function()
	marks.create_mark()
end

M.nav_to = function(idx)
	marks.nav_to(idx)
end

return M
