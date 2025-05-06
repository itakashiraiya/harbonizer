local tmux = require("lua.tmux")
local bash = require("bash")
local lfs = require("mylfs")

return function(...)
	local args = table.pack(...)
	local env_name = "BASH_ENV"
	local env_dirs = bash.getEnv(env_name)
	if env_dirs ~= "" then
		env_dirs = env_dirs .. ":"
	end
	env_dirs = env_dirs .. C.harb_dir .. "/bash/init.sh"
	print(table.unpack(args))
	local dir = args[1] or lfs.currentdir()
	tmux.exec(
		"new-session -d -c " .. dir .. "\\;",
		"set-env -g " .. env_name .. " '" .. env_dirs .. "'\\;",
		"set-env -g " .. C.dir_env .. " '" .. C.harb_dir .. "'\\;",
		"set-env -g HARBONIZER_BASHRC '-1'\\;",
		-- "source-file " .. C.harb_dir .. "/files/priv.tmux\\;",
		-- "source-file " .. C.config .. "/tmux.conf\\;",
		"move-window -s1 -t2 \\; neww\\; killw -t2\\;"
	)
	-- G.cmd.source(C.config .. "/harb.conf")
end
