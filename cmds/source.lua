local bash = require("bash")
local strings = require("strings")
local tmux = require("utils.tmux")

return function(file)
	file = file or Config .. "/harb.conf"
	if not tmux.serverOn() then
		print("can only be run if harbonizer is active")
		return
	end

	local text = bash.read(file)

	for line in text:gmatch("[^\n]*") do
		if not line:match("^%s*$") and not line:match("^#") then
			local args = strings.split(line, "%s")
			if #args == 3 then
				if args[1] == "hook" or args[1] == "set-hook" then
					args[1] = "set-hook -g"
				end

				tmux.exec(args[1], args[2], "\"run-shell '" .. Harbonizer_Dir .. "/init.lua", args[3] .. "'\"")
			else
				print("invalid conf: " .. line)
				print("correct usage: <bind/hook> <keys/event> <harbCmd>")
			end
		end
	end
end
