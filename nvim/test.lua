-- Notify when the plugin is loaded
vim.notify("Plugin 'harbonizer.nvim.test' is loaded and ready!", vim.log.levels.INFO)

-- Define a command to test the plugin
vim.api.nvim_create_user_command("harbonizer.query", function()
	vim.notify(
		"Plugin 'plugin-name' is running correctly!\nserver name: " .. vim.fn.serverlist()[1],
		vim.log.levels.INFO
	)
end, {})

vim.api.nvim_create_user_command("harbonizer.init", function()
	vim.notify("Plugin 'plugin-name' is running correctly!\ninit", vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command("harbonizer.shutdown", function()
	vim.notify("Plugin 'plugin-name' is running correctly!\nshutdown", vim.log.levels.INFO)
end, {})
