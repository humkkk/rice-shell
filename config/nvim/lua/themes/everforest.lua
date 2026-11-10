return {
	"neanias/everforest-nvim",
	lazy = true,
	config = function()
		require("everforest").setup({
			background = "medium", -- "soft", "medium" ou "hard"
			transparent_background_level = 2, -- 0, 1 or 2; 2 makes the background transparent
		})
	end,
}
