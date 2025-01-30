local bash = require("bash")
local tmux = require("utils.tmux")
local cargo = ToCargoPath(tmux.getShipDir())
bash.exec("rm " .. cargo)
