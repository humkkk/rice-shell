return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {},
	keys = {
		{ "]h", "<cmd>Gitsigns next_hunk<cr>", desc = "Próxima mudança" },
		{ "[h", "<cmd>Gitsigns prev_hunk<cr>", desc = "Mudança anterior" },
		{ "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview da mudança" },
		{ "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame da linha" },
		{ "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Desfazer mudança" },
	},
}
