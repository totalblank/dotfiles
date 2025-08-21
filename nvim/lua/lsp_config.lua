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


--- LaTeX ---

-- Backslash behaves as part of a word in TeX
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex", "latex" },
  callback = function()
    vim.opt_local.iskeyword:append("\\")
  end,
})

lsp.texlab.setup({
  capabilities = caps,
  settings = {
    texlab = {
      auxDirectory      = "./build",
      forwardSearch = { executable = "zathura", args = { "%p" } }, -- set your viewer
      chktex = { onOpenAndSave = true },  -- linting
      diagnosticsDelay = 300,
    }
  }
})

