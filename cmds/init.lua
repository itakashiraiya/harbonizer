local bash = require("bash")
local tmux = require("utils.tmux")
bash.exec("mkdir -p " .. Dockyard)
local ENV = "BASH_ENV"
local env = bash.getEnv(ENV)
if env ~= "" then
	env = env .. ":"
end
env = env .. Harbonizer_Dir .. "/bash/init.sh"
print(Config)
tmux.launch(
	"new-session",
	'"tmux set-env -g ' .. ENV .. " '" .. env .. "';",
	"export " .. ENV .. "='" .. env .. "';",
	"tmux set-env -g " .. EnvDir .. " '" .. Harbonizer_Dir .. "';",
	"export " .. EnvDir .. "='" .. Harbonizer_Dir .. "';",
	'bash"',
	"\\; source-file " .. Config .. "/tmux.conf"
)
