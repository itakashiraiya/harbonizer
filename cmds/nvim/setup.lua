local bash = require("bash")
local strings = require("strings")

return function(openFunc, closeFunc, extra)
	if type(openFunc) ~= "function" or type(closeFunc) ~= "function" or extra then
		print("invalid args, correct usage:")
		print("setup <openFunc> <closeFunc>")
		return
	end
	local last_sockets = {}
	while true do
		local ret = { opened = {} }
		local temp_sockets = {}
		local new_sockets =
			strings.split(bash.execRet("lsof -U 2>/dev/null | grep nvim | grep '\\(LISTEN\\)' | awk '{print$9}'"), "\n")
		for _, sock in pairs(new_sockets) do
			temp_sockets[sock] = true
			if last_sockets[sock] then
				last_sockets[sock] = nil
			else
				openFunc(sock)
			end
		end

		for sock, _ in pairs(temp_sockets) do
			closeFunc(sock)
		end
		last_sockets = temp_sockets
		coroutine.yield(ret)
	end
end
