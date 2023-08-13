local M = {}

M.setup = function(opts)
	if opts.chars == nil then
		M.chars = {
			['('] = { ')', true },
			['{'] = { '}', true },
			['['] = { ']', true },
		}
	else
		M.chars = opts.chars
	end

	if M.augroup == nil then
		M.augroup = vim.api.nvim_create_augroup("bracketer", {
			clear = false
		})

		vim.api.nvim_create_autocmd({"BufWinEnter"}, {
			group = M.augroup,
			pattern = opts.pattern,
			callback = function ()
				M.attach(M.augroup)
			end
		})

		vim.api.nvim_create_autocmd({"BufLeave"}, {
			group = M.augroup,
			callback = function ()
				M.detach()
			end
		})
	end
end

-- Add autocommands to detect when chars should be added to the buffer
M.attach = function (augroup)
	-- This autocommand adds the associated char (if any) to the buffer 
	vim.api.nvim_create_autocmd({"InsertCharPre"}, {
		group = augroup,
		callback = function ()
			-- Get that char that is about to inserted
			M.input = vim.v.char
			-- Get the char associated with the char we are about to insert (if any)
			M.current_char = M.chars[M.input]

			-- If the associated char is not null, we want to add that to buffer as well
			if M.current_char ~= nil then
				-- Add the associated char
				vim.v.char = M.input .. M.current_char[1]

				-- Indicate that a char has been added by this plugin
				M.char_added = true
			end
		end
	})

	-- This autocommand moves the cursor back one column if specified
	vim.api.nvim_create_autocmd({"TextChangedI"}, {
		group = augroup,
		callback = function ()
			-- If no char was added by this plugin then dont move the cursor
			if not M.char_added then
				return
			end

			-- Second field in the char table is a boolean value,
			-- that tells ud if we need to move the cursor
			if M.current_char[2] then
				-- Move cursor

				-- Get current cursor pos
				local cursor = vim.api.nvim_win_get_cursor(0)
				-- Subtract one from current cursor column
				cursor[2] = cursor[2] - 1
				-- Apply new cursor position
				vim.api.nvim_win_set_cursor(0, cursor)
			end

			-- Keep lastinput in case its needed
			M.lastinput = M.input
			-- Reset state for next input
			M.input = nil
			M.char_added = false
		end
	})
end

-- Delete the current active autocommands
M.detach = function ()

	-- Get all autocommands associated to this group and these events
	-- Which were created when attach was called
	local autocommands = vim.api.nvim_get_autocmds({
		group = M.augroup,
		event = {"InsertCharPre", "TextChangedI"},
	})

	for _, cmd in ipairs(autocommands) do
		-- if any commands are found, we delete these
		vim.api.nvim_del_autocmd(cmd.id)
	end
end

return M
