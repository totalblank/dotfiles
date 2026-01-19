local ls = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

vim.keymap.set({"i"}, "<C-k>", function() ls.expand() end, {silent=true})
vim.keymap.set({"i", "s"}, "<C-l>", function() ls.jump(1) end, {silent=true})
vim.keymap.set({"i", "s"}, "<C-h>", function() ls.jump(-1) end, {silent=true})
