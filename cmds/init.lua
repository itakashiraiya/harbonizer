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
bash.write(
	Harbonizer_Dir .. "/files/temp.tmux",
	"set-env -g " .. ENV .. " '" .. env .. "'\n",
	"set-env -g " .. EnvDir .. " '" .. Harbonizer_Dir .. "'\n",
	"source-file " .. Harbonizer_Dir .. "/files/priv.tmux\n",
	"source-file " .. Config .. "/tmux.conf\n"
)
tmux.launch("new-session \\;", "source-file " .. Harbonizer_Dir .. "/files/temp.tmux")
