local M = {}

local state_file = vim.fn.stdpath("state") .. "/theme"

-- nome do comando -> { plugin do lazy, colorscheme }
M.themes = {
	everforest = { plugin = "everforest-nvim", scheme = "everforest" },
	gruvbox = { plugin = "gruvbox.nvim", scheme = "gruvbox" },
}

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

function M.names()
	local list = { "matugen" }
	for name in pairs(M.themes) do
		table.insert(list, name)
	end
	table.sort(list)
	return list
end

function M.use(name)
	if name == "matugen" then
		require("matugen").setup()
		vim.api.nvim_exec_autocmds("ColorScheme", {})
	elseif M.themes[name] then
		local t = M.themes[name]
		require("lazy").load({ plugins = { t.plugin } })
		vim.cmd.colorscheme(t.scheme)
	else
		return
	end
	vim.g.my_theme = name
	save(name)
end

function M.restore()
	M.use(load() or "everforest")
end

return M
