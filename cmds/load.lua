local tmux = require("utils.tmux")
local bash = require("bash")
local json = require("cjson")
local lfs = require("mylfs")

local sess_id

local function loadShip(ship)
	print("test2")
	tmux.exec(
		'new-session -d -c "'
			.. ship
			.. '" "tmux run-shell \''
			.. Harbonizer_Dir
			.. "/init.lua build "
			.. ship
			.. "'; bash\""
	)
	print("test3")
	sess_id = tmux.execRet('ls -F "#{session_created}|#{session_id}" | sort -n | tail -1 | cut -d"|" -f2')
	tmux.exec("switch-client -t" .. sess_id)
	print("test4")
end

return function()
	print("ship0")
	print(Fleet)
	local fleet = bash.read(Fleet)
	print("fleet1: ")
	print(fleet)
	fleet = fleet and json.decode(fleet) or {}
	print("ship1")
	print(table.unpack(fleet))
	if #fleet == 0 then
		print("ship2.1")
		print("loading default...")
		print("sdfa: " .. lfs.currentdir())
		loadShip(lfs.currentdir())
		return
	end
	print("ship3")
	loadShip(fleet[1])
	tmux.exec("kill-session -a -t '" .. sess_id .. "'")
	for i = 2, #fleet do
		loadShip(fleet[i])
	end
end
