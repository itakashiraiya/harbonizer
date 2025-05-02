#!/usr/bin/env lua
-- lua vim.opt.runtimepath:append(',~/dev/lua/harbonizer/nvim')
-- lua print(vim.inspect(vim.api.nvim_list_runtime_paths()))
local bash = require("bash")
local str = debug.getinfo(1, "S").source:sub(2)
str = str:match("(.*/)"):sub(1, -2)
Harbonizer_Dir = bash.realpath(str)

package.path = Harbonizer_Dir .. "/?/init.lua;" .. Harbonizer_Dir .. "/?.lua;" .. package.path

Name = "harbonizer"
require("utils.tmux").init(Name)
EnvDir = "HARBONIZER_DIR"
Home = os.getenv("HOME")
Config = Home .. "/.config/" .. Name
Data = Home .. "/.local/share/" .. Name
Dockyard = Data .. "/dockyard"
Fleet = Data .. "/fleet"

function Dir_to_filename(dir)
	dir = dir:gsub("%%", "%%.")
	dir = dir:gsub("/", "%%%%")
	return dir
end

function Filename_to_dir(filename)
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

function ToCargoPath(shipDir)
	return Dockyard .. "/" .. Dir_to_filename(shipDir)
end

function GetCargoPath()
	return ToCargoPath(require("utils.tmux").getShipDir())
end

local lfs = require("mylfs")

function Cmd(cmd_name, ...)
	if not cmd_name or not lfs.attributes(Harbonizer_Dir .. "/cmds/" .. cmd_name:gsub("%.", "/") .. ".lua") then
		print("cmd: default main")
		require("cmds.main")(cmd_name, ...)
	else
		print("cmd: " .. cmd_name)
		require("cmds." .. cmd_name)(...)
	end
end

Cmd(table.unpack(arg))
