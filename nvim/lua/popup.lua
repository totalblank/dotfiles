-- 1) General UI niceties
vim.o.termguicolors = true
vim.o.pumblend      = 10      -- translucent cmp menu (0 = opaque)
vim.o.winblend      = 10      -- translucent floating windows

-- Optional: softer popup highlights (keeps your colorscheme)
-- Uncomment and tweak if you want stronger contrast.
vim.api.nvim_set_hl(0, "NormalFloat", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "FloatBorder", { link = "Pmenu" })

-- 2) nvim-cmp windows: rounded, with highlight routing
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

  -- Optional: faint inline suggestion
  experimental = { ghost_text = true },
})

-- LSP hover/signature: rounded borders everywhere
local borders = "rounded"
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { border = borders }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, { border = borders }
)

-- If you use :lua vim.lsp.util.open_floating_preview internally:
local orig = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
  opts = opts or {}; opts.border = opts.border or borders
  return orig(contents, syntax, opts, ...)
end

-- Optional: smaller padding inside float borders (depends on colorscheme)
vim.api.nvim_set_hl(0, "FloatTitle", { link = "Title" })
