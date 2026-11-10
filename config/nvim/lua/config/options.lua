local o = vim.opt
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus" -- clipboard
vim.opt.number = true             -- número da linha atual e das demais
vim.opt.relativenumber = true     -- números relativos ao cursor (bom para 5j, 3k etc.)
vim.opt.fillchars:append({ eob = " " })

-- Tab Control
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true
o.smartindent = true
