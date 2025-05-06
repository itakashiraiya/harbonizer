local bash = require("bash")

return function()
	local cmds = bash.execRet("ls", C.harb_dir .. "/cmds")
	cmds = cmds:gsub("\n", ", ")
	cmds = cmds:gsub("%.lua", "")
	print("Available commands: init, " .. cmds)
	print(table.unpack(arg))
end
