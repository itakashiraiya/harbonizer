return function()
	local bash = require("bash")
	local tmux = require("utils.tmux")
	local ships = Filename_to_dir(bash.execRet("ls " .. Dockyard))
	local file = bash.execRet('echo "' .. ships .. '" | fzf')
	if file == "" then
		print("No file selected.")
		return
	end
	print("Selected: " .. file)
	print("Dockyard: " .. Dockyard)
end
