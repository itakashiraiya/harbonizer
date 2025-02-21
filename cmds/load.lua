local tmux = require("utils.tmux")
local bash = require("bash")
local json = require("cjson")

return function()
	print(bash.read(Fleet))
	local fleet = json.decode(bash.read(Fleet))
	print(table.unpack(fleet))
	tmux.exec(
		'new-session -d -c "'
			.. fleet[1]
			.. '" "tmux run-shell \''
			.. Harbonizer_Dir
			.. "/init.lua sail "
			.. fleet[1]
			.. "'; bash\""
	)
	local sess_id = tmux.execRet('ls -F "#{session_created}|#{session_id}" | sort -n | tail -1 | cut -d"|" -f2')
	tmux.exec("switch-client -t '" .. sess_id .. "'")
	tmux.exec("kill-session -a -t '" .. sess_id .. "'")
	for i = 2, #fleet do
		tmux.exec(
			'new-session -d -c "'
				.. fleet[i]
				.. '" "tmux run-shell \''
				.. Harbonizer_Dir
				.. "/init.lua sail "
				.. fleet[i]
				.. "'; bash\""
		)
		sess_id = bash.execRet('tmux ls -F "#{session_created}|#{session_id}" | sort -n | tail -1 | cut -d"|" -f2')
		tmux.exec("switch-client -t" .. sess_id)
	end
end
