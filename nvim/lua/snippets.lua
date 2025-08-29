local ls = require("luasnip")
-- Load vscode-style snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Example keymaps
vim.keymap.set({"i"}, "<C-k>", function() ls.expand() end, {silent=true})
vim.keymap.set({"i", "s"}, "<C-l>", function() ls.jump(1) end, {silent=true})
vim.keymap.set({"i", "s"}, "<C-h>", function() ls.jump(-1) end, {silent=true})
