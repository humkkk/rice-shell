return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"python",
			"go",
			"lua",
			"bash",
			"kdl",
			"markdown",
			"markdown_inline",
			"vim",
			"vimdoc",
			"query",
			"json",
			"toml",
		})

		-- liga o highlight do Neovim para cada filetype
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}
