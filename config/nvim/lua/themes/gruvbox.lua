return {
	"ellisonleao/gruvbox.nvim",
	lazy = true,
	config = function()
		require("gruvbox").setup({
			contrast = "", -- "hard", "soft" ou "" (médio)
			transparent_mode = true,
		})
	end,
}
