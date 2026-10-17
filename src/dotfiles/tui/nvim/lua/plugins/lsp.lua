return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		vim.lsp.enable({ "lua_ls", "pyright", "gopls", "bashls" })
	end,
}
