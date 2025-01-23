local M = {}

local strings = require("strings")
local bash = require("bash")
local delimiter = "|"
local subDelimiter = ","
-- local hooks = {}
-- hooks.nvim = {}
-- hooks.nvim.load = {}
--
-- table.insert(hooks.nvim.load, function()
-- 	return 1
-- end)
--
-- function M.setHook()
--
-- end

function M.launch(configs_table, ...)
	local configs = "-f " .. table.concat(configs_table, " -f ") .. " " .. table.concat(table.pack(...), " ")
	print(configs)
	os.execute("tmux " .. configs)
end

function M.exec(...)
	bash.bash("tmux", ...)
end

function M.execRet(...)
	return bash.bashRet("tmux", ...)
end

function M.source(file)
	M.execRet(" source-file ", file)
end

function M.msg(str)
	return M.execRet("display -p '" .. str .. "'")
end

function M.getShipDir()
	return M.msg("#{session_path}")
end

local getWindowInfo = {}

function getWindowInfo.nvim(idx)
	M.exec("send-keys -t", idx, "C-[")
	M.exec("send-keys -t", idx, "C-[")
	os.execute("sleep 0.05")
	M.exec(
		"send-keys -t",
		idx,
		"':lua print(vim.api.nvim_buf_get_name(0) .. \""
			.. subDelimiter
			.. '" .. table.concat(vim.api.nvim_win_get_cursor(0), "'
			.. subDelimiter
			.. "\"))'"
	)
	M.exec("send-keys -t", idx, "C-m")

	os.execute("sleep 0.05")

	local result = M.execRet("capture-pane -t", idx, "-p -S -1")
	result = strings.cut(result, "\n", -2)[2]
	return result
end

function M.getCargo()
	local cargoStr = M.execRet("list-windows -F '#{window_stack_index}#I|#W'")
	cargoStr = strings.split(cargoStr, "\n")

	table.sort(cargoStr, function(a, b)
		return a > b
	end)

	local cargo = {}
	for _, win in ipairs(cargoStr) do
		local idx, name = table.unpack(strings.split(string.sub(win, 2), delimiter))
		local info = getWindowInfo[name] and delimiter .. getWindowInfo[name](idx)

		table.insert(cargo, { idx = idx, name = name, info = info })
	end

	return cargo
end

local restoreWindowInfo = {}

function restoreWindowInfo.nvim(idx, info)
	local file, pos = table.unpack(strings.cut(info, subDelimiter, 2, 3))
	os.execute("nvim " .. file .. ' -c "lua vim.fn.cursor(' .. pos .. ')"')
end

M.temp = restoreWindowInfo.nvim

function M.loadCargo(cargo)
	local win = cargo[1]
	M.exec("new-session -d", win.idx)

	local _ = restoreWindowInfo[win.name] and restoreWindowInfo[win.name](win.idx, win.info)

	for i = 2, #cargo do
		win = cargo[i]
		M.exec("new-window -t", win.idx)
		local _ = restoreWindowInfo[win.name] and restoreWindowInfo[win.name](win.idx, win.info)
	end
end

return M
