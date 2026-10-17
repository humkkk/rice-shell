local transparent_groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"SignColumn",
	"EndOfBuffer",
	"LineNr",
	"FoldColumn",
	"StatusLine",
	"StatusLineNC",
	"TelescopeNormal",
	"TelescopeBorder",
	"TelescopePromptNormal",
	"TelescopePromptBorder",
	"TelescopeResultsNormal",
	"TelescopePreviewNormal",
	"MiniPickNormal",
	"MiniPickBorder",
	"MiniPickPrompt",
}

local function apply_transparency()
	for _, group in ipairs(transparent_groups) do
		local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
		hl.bg = nil
		hl.ctermbg = nil
		vim.api.nvim_set_hl(0, group, hl)
	end
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("Transparency", { clear = true }),
	callback = apply_transparency,
})

if _G.__transparency_signal then
	_G.__transparency_signal:stop()
	_G.__transparency_signal:close()
end
_G.__transparency_signal = vim.uv.new_signal()
_G.__transparency_signal:start(
	"sigusr1",
	vim.schedule_wrap(function()
		vim.defer_fn(function()
			if vim.g.my_theme == "everforest" then
				require("config.theme").use("everforest")
			else
				apply_transparency()
			end
		end, 50)
	end)
)

vim.schedule(apply_transparency)
