return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  opts = {
    formatters_by_ft = {
      python = { "ruff_format" },
      go = { "gofmt" },
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      kdl = { "kdlfmt" },
    },
    format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
  },
}
