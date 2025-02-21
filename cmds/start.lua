return function(...)
	local bash = require("bash")
	local tmux = require("utils.tmux")
	local lfs = require("mylfs")

	local args = table.pack(...)
	local ENV = "BASH_ENV"
	local env = bash.getEnv(ENV)
	if env ~= "" then
		env = env .. ":"
	end
	env = env .. Harbonizer_Dir .. "/bash/init.sh"
	print(table.unpack(args))
	local dir = args[1] or lfs.currentdir()
	tmux.exec(
		"new-session -d -c " .. dir .. "\\;",
		"set-env -g " .. ENV .. " '" .. env .. "'\\;",
		"set-env -g " .. EnvDir .. " '" .. Harbonizer_Dir .. "'\\;",
		"source-file " .. Harbonizer_Dir .. "/files/priv.tmux\\;",
		"source-file " .. Config .. "/tmux.conf\\;",
		"move-window -s1 -t2 \\; neww\\; killw -t2\\;"
	)
	Cmd("source", Config .. "/harb.conf")
end
