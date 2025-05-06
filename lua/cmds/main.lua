local tmux = require("lua.tmux")
local bash = require("bash")
local argparse = require("argparse")

return function(...)
	local parser = argparse("harb", "Main harb cmd")
	parser:argument("sess", "sess to open"):args("?")
	parser:option("-c --cmd", "Commands to pass into tmux")

	local args = parser:parse(table.pack(...))

	for key, value in pairs(args) do
		print(key, value)
	end

	if tmux.serverOn() and bash.getEnv(C.dir_env) ~= "" then
		print("in harb")
		args.file = args.file or ""
	else
		if bash.getEnv("TMUX") ~= "" then
			print("detatch > attach")
			bash.exec('tmux detach -E "' .. C.harb_dir .. '/init.lua"')
			-- TODO: find a way of switching servers
		else
			if not tmux.serverOn() then
				G.cmd.start(args.cmd) -- TODO: args
			end
			print("attach")
			tmux.exec("attach")
		end
	end

	-- if args.sess then
	-- 	print("sail")
	-- 	Cmd("sail", args.sess)
	-- end
	-- if args.cmd then
	-- 	tmux.exec(args.cmd)
	-- end
end
