return function()
	local bash = require("bash")
	local cargoPath = GetCargoPath()
	bash.exec("rm " .. cargoPath .. "/*")
	bash.exec("rm -d " .. cargoPath)
end
