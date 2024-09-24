local popup = require("plenary.popup")

local M = {}

M.hello = function()
	print("hello function")
end

print("hello harpooner")

--[[
M.pop = function()
	local popup_result = popup.create(1) -- Assuming popup.create returns a table or something to inspect

	-- If you want to print the popup_result, use vim.inspect
	print(vim.inspect(popup_result))
end
]]
--

return M
