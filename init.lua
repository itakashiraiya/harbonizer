#!/usr/bin/env lua
-- lua vim.opt.runtimepath:append(',~/dev/lua/harbonizer/nvim')
-- lua print(vim.inspect(vim.api.nvim_list_runtime_paths()))
C = require("lua.constants")

package.path = C.harb_dir .. "/?/init.lua;" .. C.harb_dir .. "/?.lua;" .. package.path

require("lua.tmux").init(C.name)

G = {}

G.dir_to_filename = function(dir)
	dir = dir:gsub("%%", "%%.")
	dir = dir:gsub("/", "%%%%")
	return dir
end

G.filename_to_dir = function(filename)
	filename = filename:gsub("%%%%", "/")
	filename = filename:gsub("()%%+()%.", function(start, stop)
		local len = stop - start
		if len % 2 == 0 then
			return nil
		end
		return string.rep("/", len - 1) .. "%"
	end)
	return filename
end

G.toCargoPath = function(shipDir)
	return C.dockyard .. "/" .. G.dir_to_filename(shipDir)
end

G.GetCargoPath = function()
	return G.toCargoPath(require("utils.tmux").getShipDir())
end

local lfs = require("mylfs")

G.cmd = setmetatable({}, {
	__index = function(_, cmd_name)
		return function(...)
			if not cmd_name or not lfs.attributes(C.harb_dir .. "/lua/cmds/" .. cmd_name:gsub("%.", "/") .. ".lua") then
				print("cmd: default main")
				require("lua.cmds.main")(cmd_name, ...)
			else
				print("cmd: " .. cmd_name)
				require("lua.cmds." .. cmd_name)(...)
			end
		end
	end,
})

local cmd = arg[1]
table.remove(arg, 1)
G.cmd[cmd](table.unpack(arg))
