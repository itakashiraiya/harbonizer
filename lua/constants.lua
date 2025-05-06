local bash = require("bash")
local strings = require("strings")

local constants = {}

local str = debug.getinfo(1, "S").source:sub(2)
str = str:match("(.*/)"):sub(1, -2)
str = strings.cut(str, "/", -1)[1]
constants.harb_dir = bash.realpath(str)
print("harb_dir: " .. constants.harb_dir)

constants.name = "harbonizer"
constants.dir_env = "HARBONIZER"
constants.home = os.getenv("HOME")
constants.config = constants.home .. "/.config/" .. constants.name
constants.data = constants.home .. "/.local/share/" .. constants.name
constants.dockyard = constants.data .. "/dockyard"
constants.fleet = constants.data .. "/fleet"

return setmetatable({}, {
	__index = constants,
	__newindex = function(_, k)
		error("tried to change constant: " .. k, 2)
	end,
})
