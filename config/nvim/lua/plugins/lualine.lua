return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	config = function()
		local nr = vim.fn.nr2char

		local function setup()
			-- força o lualine a gerar o tema de novo a partir do colorscheme atual
			package.loaded["lualine.themes.auto"] = nil
			local theme = require("lualine.themes.auto")
			for _, mode in pairs(theme) do
				if type(mode) == "table" and mode.c then
					mode.c.bg = "NONE"
				end
			end

			require("lualine").setup({
				options = {
					theme = theme,
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = {
						left = nr(0xe0bc),
						right = nr(0xe0ba),
					},
					disabled_filetypes = {
						statusline = { "TelescopePrompt", "TelescopeResults" },
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "filename" },
					lualine_c = {},
					lualine_x = {},
					lualine_y = { "filetype" },
					lualine_z = {
						{ "location", separator = { right = nr(0xe0b4) } },
					},
				},
			})
		end

		setup()

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.schedule(setup)
			end,
		})
	end,
}
