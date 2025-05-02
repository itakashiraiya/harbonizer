local bash = require("bash")
local strings = require("strings")
local tmux = require("utils.tmux")

local function loop(openFunc, closeFunc)
	local last_sockets = {}
	while true do
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

		for sock, _ in pairs(last_sockets) do
			closeFunc(sock)
		end
		last_sockets = temp_sockets
		coroutine.yield()
	end
end

local function setup(openFunc, closeFunc)
	if type(openFunc) ~= "function" or type(closeFunc) ~= "function" then
		print("invalid args, correct usage:")
		print("setup <openFunc> <closeFunc>")
		return
	end

	local co = coroutine.create(loop)
	local sucsess = coroutine.resume(co, openFunc, closeFunc)
	while sucsess do
		sucsess = coroutine.resume(co)
	end
end

local function connectSocket(socket) end

return function()
	local function opened(sock)
		tmux.display("opened: " .. sock)
	end

	local function closed(sock)
		tmux.display("closed: " .. sock)
	end
	setup(opened, closed)
end
