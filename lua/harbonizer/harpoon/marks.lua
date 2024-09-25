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

M.create_mark = function()
	local file = vim.api.nvim_buf_get_name(0)

	for _, mark in ipairs(M.marks) do
		if mark.file == file then
			update_mark_cursor(mark)
			return
		end
	end

	table.insert(M.marks, create_mark(file))
end

M.nav_to = function(idx)
	local mark = M.marks[idx]
	vim.api.nvim_set_current_buf(mark.buf)
end

local function swap_marks(i1, i2)
	local temp = M.marks[i1]
	M.marks[i1] = M.marks[i2]
	M.marks[i2] = temp
end

M.update_mark_order = function(buf)
	local harbonizer_marks = vim.api.nvim_buf_get_lines(buf, 0, 4, true)
	for i, line in ipairs(harbonizer_marks) do
		if line == "" then
			table.insert(M.marks, "")
			swap_marks(i, #M.marks)
		else
			for i2, mark in ipairs(M.marks) do
				if mark.line == line then
					swap_marks(i, i2)
					return
				end
			end
		end
	end
end

M.get_mark_list = function()
	local list = {}

	for _, mark in ipairs(M.marks) do
		if mark == "" then
			table.insert(list, "")
		else
			table.insert(list, mark.file)
		end
	end

	return list
end

return M
