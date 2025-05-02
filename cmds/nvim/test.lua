local strings = require("strings")
local bash = require("bash")

return function()
	print("nvim test")
	local socket = table.unpack(
		strings.split(bash.execRet("lsof -U 2>/dev/null | grep nvim | grep '\\(LISTEN\\)' | awk '{print$9}'"), "\n")
	)
	print(socket)
end
