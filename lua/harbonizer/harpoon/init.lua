local popup = require("plenary.popup")

local M = {}

M.hello = function()
	print("hello harpoon")
end

M.popup = function()
	popup.create(1)
end

return M
