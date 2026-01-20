local fzf_lua = require('fzf-lua')

fzf_lua.setup({
  "telescope",                  -- makes it look and behave like Telescope
  winopts = { preview = { layout = "vertical" } },

  fzf_opts = {
    ["--preview-window"] = "right:60%:hidden", -- Customize preview window
  }
})

-- Define key mappings
vim.api.nvim_set_keymap('n', '<Leader>f', ':FzfLua files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>b', ':FzfLua buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>o', ':FzfLua oldfiles<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>g', ':FzfLua live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>p', ':FzfLua find_files<CR>', { noremap = true, silent = true })
