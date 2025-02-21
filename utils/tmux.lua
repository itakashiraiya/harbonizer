local M = {}

local strings = require("strings")
local bash = require("bash")
local servername = ""
local delimiter = "|"
local subDelimiter = ";"
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

function M.init(name)
	servername = " -L " .. name
	return M
end

function M.exec(...)
	bash.exec("tmux" .. servername, ...)
end

function M.execRet(...)
	return bash.execRet("tmux" .. servername, ...)
end

function M.serverOn()
	return M.execRet("has 2>&1") == ""
end

function M.source(file)
	M.execRet("source-file ", file)
end

function M.display(...)
	M.exec("display '", ..., "'")
end

function M.info(...)
	return M.execRet("display -p", ...)
end

function M.toTmuxFmt(fmt)
	local function processArg(val)
		if #val == 1 then
			return "#" .. val
		else
			return "#{" .. val .. "}"
		end
	end

	local ret = ""
	for _, arg in ipairs(fmt) do
		if type(arg) == "table" then
			for _, subArg in ipairs(arg) do
				ret = ret .. processArg(subArg) .. subDelimiter
			end
		else
			ret = ret .. processArg(arg) .. delimiter
		end
	end
	return ret:sub(1, -2)
end

function M.decodeFmt(string, fmt)
	-- TODO: how to solve the fact that sub args dont have an arg name?
	local ret = {}
	for line in string:gmatch("[^\n]*") do
		local info = {}
		line = strings.split(line, delimiter)
		if #line ~= #fmt then
			return nil, error("Provided tmux return string and format dont match")
		end
		for i = 1, #line do
			if type(fmt[i]) == "table" then
				local subFmt = fmt[i]
				local subline = strings.split(line[i], subDelimiter)
				if #subline == 1 or #subline ~= #subFmt then
					return nil, error("Provided tmux return string and format dont match")
				end
			elseif type(fmt[i]) then
				info[fmt[i]] = line[i]
			end
		end

		table.insert(ret, info)
	end

	if #ret == 1 then
		return ret[1]
	end
	return ret

	-- local function splitArgs(args, delim)
	-- 	args = strings.split(line, delim)
	-- 	for i = 1, math.min(#format, #line) do
	-- 		info[format[i]] = line[i]
	-- 	end
	-- 	table.insert(ret, info)
	-- end
	--
	-- local ret = {}
	-- local format = table.pack(...)
	-- for line in string:gmatch("[^\n]*") do
	-- 	local info = {}
	-- end
	-- if #ret == 1 then
	-- 	return ret[1]
	-- end
	-- return ret
end

function M.getShipDir()
	return M.info("'#{session_path}'")
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
	result = strings.cut(result, "\n", -2)[3]
	return result
end

function M.getCargo(...)
	local args = ... and table.pack(...) or { "I", "{pane_current_path}" }
	table.insert(args, 1, "{window_stack_index}")
	local str = "'#" .. table.concat(args, "|#") .. "'"

	local cargoStr = M.execRet("list-windows -F " .. str)
	cargoStr = strings.split(cargoStr, "\n")

	table.sort(cargoStr, function(a, b)
		return a > b
	end)

	local cargo = {}
	for _, win in ipairs(cargoStr) do
		local _, idx, dir = table.unpack(strings.split(win, delimiter))
		-- local info = getWindowInfo[name] and delimiter .. getWindowInfo[name](idx)
		local info

		table.insert(cargo, { idx = idx, dir = dir, info = info })
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
