return function(...)
	local args = table.pack(...)
	local bash = require("bash")
	local tmux = require("utils.tmux")
	local lfs = require("mylfs")

	local ENV = "BASH_ENV"
	local env = bash.getEnv(ENV)
	if env ~= "" then
		env = env .. ":"
	end
	env = env .. Harbonizer_Dir .. "/bash/init.sh"
	print(Config)
	bash.write(
		Harbonizer_Dir .. "/files/temp.tmux",
		"set-env -g " .. ENV .. " '" .. env .. "'\n",
		"set-env -g " .. EnvDir .. " '" .. Harbonizer_Dir .. "'\n",
		"source-file " .. Harbonizer_Dir .. "/files/priv.tmux\n",
		"source-file " .. Config .. "/tmux.conf\n"
	)
	print(table.unpack(args))
	local dir = args[1] or lfs.currentdir()
	tmux.exec("new-session -d -c " .. dir .. "\\;", "source-file " .. Harbonizer_Dir .. "/files/temp.tmux")
	local sess_id = tmux.execRet('ls -F "#{session_created} #{session_id}" | sort -nr | cut -d" " -f2 | head -n1')
	print(sess_id)
	if bash.getEnv("HARBONIZER_DIR") == "" then
		tmux.exec("attach -t '" .. sess_id .. "'")
	else
		tmux.exec("switch-client -t '" .. sess_id .. "'")
	end
end
