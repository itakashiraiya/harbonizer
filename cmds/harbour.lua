local bash = require("bash")
local tmux = require("utils.tmux")
local json = require("cjson")

local cargo = tmux.getCargo()
local name = GetCargoPath()
bash.exec("mkdir -p " .. name)
local cargoJson = json.encode(cargo)
bash.write(name .. "/cargo", cargoJson)
