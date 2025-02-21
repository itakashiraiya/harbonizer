local json = require("cjson")
local bash = require("bash")
local lfs = require("mylfs")
local tmux = require("utils.tmux")

return function(path, ...)
	if ... then
		print("accepts one arg max")
		print("build <shipDir>")
		return
	end

	path = path or lfs.currentdir()
	path = bash.realpath(path)
	if path == "" then
		print("no such dir")
		return
	end

	local cargoPath = ToCargoPath(path)
	local blueprint = io.open(cargoPath .. "/cargo", "r")
		or io.open(Config .. "/default_ship", "r")
		or io.open(Harbonizer_Dir .. "/files/default_ship", "r")
	assert(blueprint, "error opening file")
	local cargo = blueprint:read("*a")
	blueprint:close()
	cargo = json.decode(cargo)

	tmux.exec("neww -t2")
	tmux.exec("killw -t1")
	tmux.exec("neww -t1 -c", cargo[1].dir, "\\; killw -a -t1")
	bash.exec("echo 'testing 3' >>", Harbonizer_Dir .. "/log")
	tmux.exec("neww -t", cargo[1].idx, "-c", cargo[1].dir)
	tmux.exec("killw -a -t", cargo[1].idx)
	for _, win in ipairs(cargo) do
		tmux.exec("neww -t", win.idx, "-c", win.dir)
		bash.exec("echo 'testing 4' >>", Harbonizer_Dir .. "/log")
	end

	for _, win in ipairs(cargo) do
		local str = ""
		for k, v in pairs(win) do
			str = str .. k .. ": " .. v .. ", "
		end
		print(str)
	end

	print("path: " .. path)
	print("cargoPath: " .. cargoPath)
end
