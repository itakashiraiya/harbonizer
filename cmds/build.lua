local json = require("cjson")
local bash = require("bash")
local lfs = require("mylfs")
local tmux = require("utils.tmux")

return function(path, extra)
	-- if true then
	-- 	print("called build")
	-- 	return
	-- end
	if extra then
		error([[accepts one arg max:
		build <shipDir>]])
		assert(false, "!!!????????????????")
		return
	end

	path = path or lfs.currentdir()
	path = bash.realpath(path)
	if path == "" then
		error("No such dir")
		assert(false, "!!!!????????????????")
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

	for _, v in ipairs(cargo) do
		print(v)
		for index, value in pairs(v) do
			print(index, value)
		end
	end

	tmux.exec("neww -t2")
	tmux.exec("killw -t1")
	tmux.exec("neww -t1 -c", cargo[1].dir and "-c '" .. cargo[1].dir .. "'" or "", "\\; killw -a -t1")
	tmux.exec("neww -t", cargo[1].idx, cargo[1].dir and "-c '" .. cargo[1].dir .. "'" or "")
	tmux.exec("killw -a -t", cargo[1].idx)
	for _, win in ipairs(cargo) do
		tmux.exec("neww -t", win.idx, win.dir and "-c '" .. win.dir .. "'" or "")
	end

	for _, win in ipairs(cargo) do
		local str = ""
		for k, v in pairs(win) do
			str = str .. k .. ": " .. v .. ", "
		end
		print(str)
	end
end
