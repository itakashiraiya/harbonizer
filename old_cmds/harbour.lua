return function()
	local bash = require("bash")
	local tmux = require("utils.tmux")
	local json = require("cjson")

	local cargo = tmux.getCargo()
	local name = GetCargoPath()
	bash.exec("mkdir -p " .. name)
	local cargoJson = json.encode(cargo)
	-- print(cargoJson)
	bash.write(name .. "/cargo", cargoJson)
	print(tmux.execRet('ls -F "#{session_last_attached}|#{session_id} #{session_path}" | sort -nr | cut -d"|" -f2'))
end
