#!/usr/bin/env lua

local bash = require("bash")

local function get_script_dir()
	local str = debug.getinfo(1, "S").source:sub(2) -- Remove the "@" prefix from the source path
	str = str:match("(.*/)"):sub(1, -2)
	return bash.bashRet("realpath " .. str):gsub("\n$", "")
end

package.path = get_script_dir() .. "/?/init.lua;" .. get_script_dir() .. "/?.lua;" .. package.path

local json = require("cjson")
local strings = require("strings")
local tmux = require("utils.tmux")
local home = os.getenv("HOME")
local name = "harbonizer"
local config = home .. "/.config/" .. name
local data = home .. "/.local/share/" .. name
local dockyard = data .. "/dockyard"
local fleet = data .. "/fleet"

local function toCargoPath(shipDir)
	return dockyard .. shipDir
end

local cmds = {}

function cmds.test()
	cmds.harbour()
	print("aa")
	-- tmux.temp(1, "/home/viktor/dev/lua/harbonizer/files/temp.tmux,3,16")
end

function cmds.help()
	print("Available commands: init, shutdown, sail, harbour, destroy, build")
end

function cmds.burn()
	local cargo = toCargoPath(tmux.getShipDir())
	bash.bash("rm " .. cargo)
end

function cmds.build()
	local blueprint = io.open(config .. "/default_ship", "r") or io.open(get_script_dir() .. "/default_ship", "r")
	assert(blueprint, "error opening file")
	local str = blueprint:read("*a")

	blueprint:close()
end

function cmds.harbour()
	local dir = tmux.getShipDir()
	local cargo = tmux.getCargo()
	local parent = strings.cut(dir, "/", -1)
	bash.bash("mkdir -p " .. dockyard .. parent[1])
	cargo = json.encode(cargo)
	cargo = bash.write(cargo, dockyard .. dir)
end

function cmds.sail()
	local cargo = toCargoPath(tmux.getShipDir())
end

function cmds.shutdown() end

function cmds.startup()
	print("woooooW")
end

function cmds.init()
	bash.bash("mkdir -p " .. dockyard)
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
	print("env: " .. env)
	tmux.launch(
		conf,
		"new-session",
		'"tmux set-env -g ' .. ENV .. " '" .. env .. "';",
		"export " .. ENV .. "='" .. env .. "';",
		'bash"'
	)
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
