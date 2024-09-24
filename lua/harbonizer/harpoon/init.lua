local popup = require("plenary.popup")

local M = {}

M.hello = function()
	print("hello function")
end

print("hello harpoon")

M.popup = function()
	popup.create(1)
end

return M
