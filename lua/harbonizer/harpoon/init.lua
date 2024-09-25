local monitor = require("harbonizer.harpoon.monitor")

local M = {}

M.hello = function()
	print("hello function")
end

print("hello harpooner")

M.toggle = function()
	monitor.toggleWin()
end

return M
