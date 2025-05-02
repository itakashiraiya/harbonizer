local bash = require("bash")

return function()
	bash.exec("touch " .. Harbonizer_Dir .. "/jusk")
	Cmd("nvim.setup")
end
