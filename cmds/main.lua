local tmux = require("utils.tmux")
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

	local routine

	if tmux.serverOn() then
		if bash.getEnv(EnvDir) ~= "" then
			print("in harb")
			args.file = args.file or ""
		else
			if bash.getEnv("TMUX") ~= "" then
				print("TODO: switch/detach/attach")
				-- TODO: find a way of switching servers
			else
				print("attach")
				tmux.exec("attach")
			end
		end
	else
		print("start")
		Cmd("start", args.cmd) -- TODO: args
		Cmd("load") -- TODO: args
		-- routine = require("nvim/monitor")
		if bash.getEnv("TMUX") ~= "" then
			print("TODO: switch/detach/attach")
			-- TODO: find a way of switching servers
		else
			print("attach")
			tmux.exec("attach")
		end
	end
	if args.sess then
		print("sail")
		Cmd("sail", args.sess)
	end
	if args.cmd then
		tmux.exec(args.cmd)
	end

	bash.exec("touch " .. Harbonizer_Dir .. "/sus")
	-- routine = require("nvim/monitor")
end
