return {
  vim.lsp.set_log_level("off"),

  vim.api.nvim_create_user_command("E", function(opts)
    vim.cmd("tabnew " .. opts.args)
  end, { nargs = 1 }),

  vim.keymap.set("n", "<Tab>", "gt", { noremap = true, silent = true }),
  vim.keymap.set("n", "<S-Tab>", "gT", { noremap = true, silent = true }),
}
