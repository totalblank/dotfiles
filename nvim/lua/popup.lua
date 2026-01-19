vim.o.termguicolors = true
vim.o.pumblend      = 10      -- translucent cmp menu (0 = opaque)
vim.o.winblend      = 10      -- translucent floating windows

vim.api.nvim_set_hl(0, "NormalFloat", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "FloatBorder", { link = "Pmenu" })

local cmp = require("cmp")
cmp.setup({
  window = {
    completion = cmp.config.window.bordered({
      border = "rounded",
      winhighlight = table.concat({
        "Normal:Pmenu",
        "FloatBorder:FloatBorder",
        "CursorLine:PmenuSel",
        "Search:None",
      }, ","),
      scrollbar = true,
    }),
    documentation = cmp.config.window.bordered({
      border = "rounded",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    }),
  },

  experimental = { ghost_text = true },
})

local borders = "rounded"
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { border = borders }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, { border = borders }
)

local orig = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
  opts = opts or {}; opts.border = opts.border or borders
  return orig(contents, syntax, opts, ...)
end

vim.api.nvim_set_hl(0, "FloatTitle", { link = "Title" })
