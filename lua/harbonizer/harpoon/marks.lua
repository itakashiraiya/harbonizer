local M = {}

local function update_mark_cursor(mark)
	local pos = vim.api.nvim_win_get_cursor(0)
	mark.row = pos[1]
	mark.col = pos[2]
	return mark
end

local function create_mark(file)
	local buf = vim.api.nvim_get_current_buf()

	return update_mark_cursor({
		buf = buf,
		file = file,
	})
end

M.marks = {}
M.file_list = {}

local function get_mark_from_file(file)
	if file[1] == 'X' then
		return nil
	end

	for _, mark in ipairs(M.marks) do
		if mark.file == file then
			return mark
		end
	end
	return nil
end

local function marks_contain_file(file)
	return get_mark_from_file(file) ~= nil
end

local function list_contains_file(list, file)
	for _, other in ipairs(list) do
		if file == other then
			return true
		end
	end
	return false
end

M.update_mark_list = function(buf)
	local new_list = vim.api.nvim_buf_get_lines(buf, 0, 4, false)
	for i, line in ipairs(new_list) do
		if line:sub(1, 1) == 'X' then
			print("M.update_mark_list(): line[1] == 'X' && i == " .. i)
			goto continue
		end

		if marks_contain_file(line) then
			goto continue
		end

		new_list[i] = "X" .. line

		::continue::
	end

	local idx_to_remove = {}
	for i, mark in ipairs(M.marks) do
		if not list_contains_file(new_list, mark.file) then
			table.insert(idx_to_remove, i)
		end
	end
	table.sort(idx_to_remove, function (a, b) return a > b end)
	for _, idx in ipairs(idx_to_remove) do
		table.remove(M.marks, idx)
	end

	M.file_list = new_list
end

M.nav_to = function(idx)
	if idx > #M.file_list then
		print("file list index out of bounds")
		return
	end
	local file = M.file_list[idx]
	local mark = get_mark_from_file(file)

	if mark == nil then
		print("nonexistent mark")
		return
	end

	vim.api.nvim_set_current_buf(mark.buf)
end

M.create_mark = function()
	local file = vim.api.nvim_buf_get_name(0)

	if file == "" then
		return
	end

	for _, mark in ipairs(M.marks) do
		if mark.file == file then
			update_mark_cursor(mark)
			return
		end
	end

	table.insert(M.marks, create_mark(file))
	table.insert(M.file_list, file)
end

return M
