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

vim.schedule(apply_transparency)
