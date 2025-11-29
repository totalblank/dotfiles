vim.g.slime_target = "tmux"
vim.g.slime_default_config = { socket_name = "default", target_pane = "1" }
vim.g.slime_dont_ask_default = 1

vim.keymap.set("x", "<leader>s", "<Plug>SlimeRegionSend")
vim.keymap.set("n", "<leader>s", "<Plug>SlimeParagraphSend")
vim.keymap.set("n", "<leader>ss", "<Plug>SlimeLineSend")
