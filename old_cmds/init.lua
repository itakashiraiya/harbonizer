return function(...)
	local bash = require("bash")
	local tmux = require("utils.tmux")
	local lfs = require("mylfs")
	bash.exec("mkdir -p " .. Dockyard)
	if tmux.execRet("has-session", "2>&1") ~= "" then
		Cmd("new-ship", ...)
	else
		if bash.getEnv("HARBONIZER_DIR") == "" then
			tmux.exec("attach")
		else
			Cmd("sail")
		end
	end
end
