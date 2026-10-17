local M = {}

local state_file = vim.fn.stdpath("state") .. "/theme"

local function save(name)
	local f = io.open(state_file, "w")
	if f then
		f:write(name)
		f:close()
	end
end

local function load()
	local f = io.open(state_file, "r")
	if not f then
		return nil
	end
	local name = f:read("*l")
	f:close()
	return name
end

function M.use(name)
	if name == "matugen" then
		require("matugen").setup()
		vim.api.nvim_exec_autocmds("ColorScheme", {})
	elseif name == "everforest" then
		require("lazy").load({ plugins = { "everforest-nvim" } })
		vim.cmd.colorscheme("everforest")
	else
		return
	end
	vim.g.my_theme = name
	save(name)
end

function M.restore()
	M.use(load() or "everforest") -- everforest se ainda não houver tema salvo
end

return M
