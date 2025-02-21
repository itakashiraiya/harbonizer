return function(...)
	local args = table.pack(...)
	local tmux = require("utils.tmux")
	local bash = require("bash")
	local json = require("cjson")
	local nvim = require("nvim-client/0.2.4-1")

	local pane_id = bash.getEnv("TMUX_PANE")
	local win_idx = tonumber(tmux.info("-t", pane_id, '"#{window_index}"'))
	local win_id = tmux.info("-t", pane_id, '"#{window_id}"')
	local socket = args[1]

	local ship = GetCargoPath()
	print("ship: ", ship)
	local state = bash.read(ship .. "/state")
	if not state then
		bash.exec("mkdir -p", ship)
		state = "[]"
	end
	state = json.decode(state)
	if #state < win_idx then
		for i = #state + 1, win_idx do
			state[i] = {}
		end
	end
	state[win_idx].pane_id = pane_id
	state[win_idx].win_id = win_id
	state[win_idx].state = "nvim"
	state[win_idx].socket = socket
	local vim = nvim.attach("socket", socket)
	print(table.unpack(state))
	for i, v in pairs(state[win_idx]) do
		print(i, v)
	end
	print(state[win_idx].pane_id)
	bash.write(json.encode(state), ship .. "/state")
	print(socket, pane_id, win_id, win_idx)
end
