#!/usr/bin/env lua
-- nvim --cmd "lua package.path = '/home/viktor/dev/lua/?.lua;' .. package.path; require('harbonizer.nvim.test')"

local function get_script_dir()
	local bash = require("bash")
	local str = debug.getinfo(1, "S").source:sub(2) -- Remove the "@" prefix from the source path
	str = str:match("(.*/)"):sub(1, -2)
	return bash.execRet("realpath " .. str)
end

package.path = get_script_dir() .. "/?/init.lua;" .. get_script_dir() .. "/?.lua;" .. package.path

local envDir = "HARBONIZER_DIR"
local home = os.getenv("HOME")
local name = "harbonizer"
local config = home .. "/.config/" .. name
local data = home .. "/.local/share/" .. name
local dockyard = data .. "/dockyard"
local fleet = data .. "/fleet"

local function toCargoPath(shipDir)
	return dockyard .. shipDir
end

local function dir_to_filename(dir)
	dir = dir:gsub("%%", "%%.")
	dir = dir:gsub("/", "%%%%")
	return dir
end

local function filename_to_dir(filename)
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

local cmds = {}

function cmds.help()
	print("Available commands: init, shutdown, sail, harbour, destroy, build")
end

function cmds.burn()
	local bash = require("bash")
	local tmux = require("utils.tmux")
	local cargo = toCargoPath(tmux.getShipDir())
	bash.exec("rm " .. cargo)
end

function cmds.build()
	local blueprint = io.open(config .. "/default_ship", "r") or io.open(get_script_dir() .. "/default_ship", "r")
	assert(blueprint, "error opening file")
	local str = blueprint:read("*a")

	blueprint:close()
end

function cmds.harbour()
	local bash = require("bash")
	local tmux = require("utils.tmux")
	local json = require("cjson")
	local dir = tmux.getShipDir()
	local cargo = tmux.getCargo()
	dir = dir_to_filename(dir)
	bash.exec("mkdir -p " .. dockyard .. "/" .. dir)
	local cargoJson = json.encode(cargo)
	bash.write(cargoJson, dockyard .. "/" .. dir .. "/cargo")
end

function cmds.sail()
	local tmux = require("utils.tmux")
	local cargo = toCargoPath(tmux.getShipDir())
end

function cmds.shutdown() end

function cmds.startup()
	print("woooooW")
end

function cmds.init()
	local bash = require("bash")
	local tmux = require("utils.tmux")
	bash.exec("mkdir -p " .. dockyard)
	local conf = {}
	for _, v in ipairs({ config .. "/tmux.conf", home .. "/.tmux.conf", home .. "/.config/tmux/tmux.conf" }) do
		if os.rename(v, v) then
			table.insert(conf, v)
		end
	end
	conf = arg[2] and { arg[2] } or conf
	table.insert(conf, get_script_dir() .. "/files/priv.tmux")
	local ENV = "BASH_ENV"
	local env = bash.getEnv(ENV)
	if env ~= "" then
		env = env .. ":"
	end
	env = env .. get_script_dir() .. "/bash/init.sh"
	tmux.launch(
		conf,
		"new-session",
		'"tmux set-env -g ' .. ENV .. " '" .. env .. "';",
		"export " .. ENV .. "='" .. env .. "';",
		"tmux set-env -g " .. envDir .. " '" .. get_script_dir() .. "';",
		"export " .. envDir .. "='" .. get_script_dir() .. "';",
		'bash"'
	)
end

function cmds.test()
	local tmux = require("utils.tmux")
	local bash = require("bash")
	cmds.harbour()
	print("as")
	tmux.display("aaa")
	bash.exec("touch " .. get_script_dir() .. "/temp")
end

local cmd_name = arg[1] or "init"
if arg[1] == "-f" then
	cmd_name = "init"
end
local cmd = cmds[cmd_name]
if cmd ~= nil then
	cmd()
else
	print("Unknown command: " .. cmd_name)
	cmds.help()
end
