local lsp = require('lspconfig')
local caps = require('cmp_nvim_lsp').default_capabilities()

vim.o.completeopt = "menu,menuone,noselect"

-- nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")
pcall(require("luasnip.loaders.from_vscode").lazy_load)

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = false }),
    ["<Tab>"]     = cmp.mapping(function(fb)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fb() end
    end, { "i", "s" }),
    ["<S-Tab>"]   = cmp.mapping(function(fb)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fb() end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
})

--- Mason
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = { "clangd", "lua_ls", "texlab", "r_language_server" }, -- auto-install these servers
    automatic_installation = true,
})

--- diagnostic
-- Prefer this on Neovim 0.10+
local has010 = vim.fn.has("nvim-0.10") == 1

local icons = {
  Error = "✘",
  Warn  = "▲",
  Hint  = "⚑",
  Info  = "",
}

if has010 then
  vim.diagnostic.config({
    -- Put your general diagnostics prefs here
    virtual_text = { prefix = "●", spacing = 2 },
    underline = true,
    update_in_insert = false,
    severity_sort = true,

    -- NEW: define signs without sign_define()
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.Error .. " ",
        [vim.diagnostic.severity.WARN]  = icons.Warn  .. " ",
        [vim.diagnostic.severity.HINT]  = icons.Hint  .. " ",
        [vim.diagnostic.severity.INFO]  = icons.Info  .. " ",
      },
      -- Optional: use theme’s highlight groups for number column/line
      numhl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
        [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
        [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
        [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
      },
      -- linehl = { … } -- similarly, if you like line highlighting
    },
  })
else
  -- Fallback for Neovim < 0.10 (no warning on older versions)
  for type, icon in pairs(icons) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon .. " ", texthl = hl, numhl = "" })
  end
  vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 2 },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    signs = true,
  })
end


