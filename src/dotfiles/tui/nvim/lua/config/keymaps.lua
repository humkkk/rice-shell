require("config.theme")

vim.api.nvim_create_user_command("Theme", function(opts)
	require("config.theme").use(opts.args)
end, {
	nargs = 1,
	complete = function()
		return { "matugen", "everforest" }
	end,
})

-- Lsp
local map = vim.keymap.set

map("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Próximo diagnóstico" })
map("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Diagnóstico anterior" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Mensagem do diagnóstico" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Lista de diagnósticos" })
