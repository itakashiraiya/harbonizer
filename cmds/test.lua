local function test1()
	-- Define the function you want to serialize
	local function fn()
		os.execute("touch /home/viktor/dev/lua/harbonizer/hmmm")
	end

	-- Serialize the function using string.dump
	local serialized_fn = string.dump(fn)

	-- In Lua 5.2 and later, use load instead of loadstring
	local func, err = load(serialized_fn)

	os.execute(
		"local serialized_fn = [["
			.. serialized_fn
			.. "\n]]\nlocal func, err = load(serialized_fn)\nif err or not func then print('error') else func() end"
	)
	print(
		"local serialized_fn = [["
			.. serialized_fn
			.. "\n]]\nlocal func, err = load(serialized_fn)\nif err or not func then print('error') else func() end"
	)
	print("test:")
	print("[[]]")

	if func then
		-- Execute the function
		-- func()
	else
		-- Handle error in loading
		print("Error loading function: " .. err)
	end
end

local function test2()
	local serialized_fn = [[uaT

xV
]]
	local func, err = load(serialized_fn)
	if err or not func then
		print("error")
	else
		func()
	end
end

local function test3()
	local tmux = require("utils.tmux")
	local a = tmux.toFmt("S", "session_id", { "W", "session_path" })
	local ret = tmux.info('"' .. a .. '"')
	print(a)
	print(ret)
end

local function test4()
	local nvim = require("nvim-client")
end

return test4
