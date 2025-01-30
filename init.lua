#!/usr/bin/env lua

local bash = require("bash")
local str = debug.getinfo(1, "S").source:sub(2)
str = str:match("(.*/)"):sub(1, -2)
Harbonizer_Dir = bash.execRet("realpath " .. str)

package.path = Harbonizer_Dir .. "/?/init.lua;" .. Harbonizer_Dir .. "/?.lua;" .. package.path

EnvDir = "HARBONIZER_DIR"
Home = os.getenv("HOME")
Name = "harbonizer"
Config = Home .. "/.config/" .. Name
Data = Home .. "/.local/share/" .. Name
Dockyard = Data .. "/dockyard"
Fleet = Data .. "/fleet"

function ToCargoPath(shipDir)
	return Dockyard .. shipDir
end

function Dir_to_filename(dir)
	dir = dir:gsub("%%", "%%.")
	dir = dir:gsub("/", "%%%%")
	return dir
end

function Filename_to_dir(filename)
	filename = filename:gsub("%%%%", "/")
	print(filename .. " : test")
	filename = filename:gsub("()%%+()%.", function(start, stop)
		local len = stop - start
		if len % 2 == 0 then
			return nil
		end
		return string.rep("/", len - 1) .. "%"
	end)
	return filename
end

local lfs = require("mylfs")

local cmd_name, arg = arg[1], { table.unpack(arg, 2) }
cmd_name = cmd_name and cmd_name:gsub("%.", "/")

lfs.chdir(Harbonizer_Dir)
if not cmd_name or not lfs.attributes("cmds/" .. cmd_name .. ".lua") then
	print(cmd_name)
	cmd_name = "init"
	arg = _G.arg
end
_G.arg = arg
dofile("cmds/" .. cmd_name .. ".lua")
