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
	local list = vim.tbl_keys(M.themes)
	table.sort(list)
	return list
end

function M.use(name)
	local t = M.themes[name]
	if not t then
		return
	end
	require("lazy").load({ plugins = { t.plugin } })
	vim.cmd.colorscheme(t.scheme)
	vim.g.my_theme = name
	save(name)
end

function M.restore()
	M.use(load() or "everforest")
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    for i = 1, 6 do
      vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i .. "Bg", { bg = "NONE" })
    end
  end,
})

return M
