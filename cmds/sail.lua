local lfs = require("mylfs")
local bash = require("bash")
local tmux = require("utils.tmux")

return function(file, ...)
	file = file and bash.realpath(file)

	if file and not lfs.attributes(ToCargoPath(file)) then
		print("not a stored ship")
		return
	end
	print(file)
	local ships = Filename_to_dir(bash.execRet("ls " .. Dockyard))
	file = file or bash.execRet('echo "' .. ships .. '" | fzf')
	if file == "" then
		print("No file selected.")
		return
	end
	Cmd("build", file)
	print("Selected: " .. file)
	print("Dockyard: " .. Dockyard)
end
