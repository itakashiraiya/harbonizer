local bash = require("bash")
local tmux = require("utils.tmux")
bash.exec("mkdir -p " .. Dockyard)
local conf = {}
for _, v in ipairs({ Config .. "/tmux.conf", Home .. "/.tmux.conf", Home .. "/.config/tmux/tmux.conf" }) do
	if os.rename(v, v) then
		table.insert(conf, v)
	end
end
conf = arg[2] and { arg[2] } or conf
table.insert(conf, Harbonizer_Dir .. "/files/priv.tmux")
local ENV = "BASH_ENV"
local env = bash.getEnv(ENV)
if env ~= "" then
	env = env .. ":"
end
env = env .. Harbonizer_Dir .. "/bash/init.sh"
tmux.launch(
	conf,
	"new-session",
	'"tmux set-env -g ' .. ENV .. " '" .. env .. "';",
	"export " .. ENV .. "='" .. env .. "';",
	"tmux set-env -g " .. EnvDir .. " '" .. Harbonizer_Dir .. "';",
	"export " .. EnvDir .. "='" .. Harbonizer_Dir .. "';",
	'bash"'
)
