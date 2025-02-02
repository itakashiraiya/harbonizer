-- Notify when the plugin is loaded
vim.notify("Plugin 'harbonizer.nvim.test' is loaded and ready!!!", vim.log.levels.INFO)

-- local mainDir = "default"
-- local M = {
-- 	init = function(mainScriptDir)
-- 		mainDir = mainScriptDir
-- 	end,
-- }

vim.api.nvim_create_autocmd("VimEnter", {
	-- Define a command to test the plugin
	callback = function()
		local bash = require("bash")
		local dir = bash.getEnv("HARBONIZER_DIR")
		bash.exec(dir .. "/init.lua test")
		vim.notify("Plugin 'plugin-name' is running correctly!\ninit: " .. dir, vim.log.levels.INFO)
	end,
})

vim.api.nvim_create_user_command("HarbonizerQuery", function()
	vim.notify(
		"Plugin 'plugin-name' is running correctly!\nserver name: " .. vim.fn.serverlist()[1],
		vim.log.levels.INFO
	)
end, {})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		os.execute("touch /home/viktor/dev/lua/harbonizer/tmp")
	end,
})
