local lsp = require('lspconfig')
local caps = require('cmp_nvim_lsp').default_capabilities()

vim.o.completeopt = "menu,menuone,noselect"

-- nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")
pcall(require("luasnip.loaders.from_vscode").lazy_load)

cmp.setup({
  snippet = {
      expand = function(args)
          luasnip.lsp_expand(args.body)
      end
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
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
    ensure_installed = {"texlab"}, -- auto-install these servers
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

vim.lsp.config('clangd', {})

vim.lsp.config('r_language_server', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    
    -- Mappings
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- See `:help vim.lsp.*` for documentation
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end
})

vim.keymap.set("n", "<leader>r", function()
  -- Save current file first
  vim.cmd("write")

  local file = vim.fn.expand("%:p") -- absolute path
  if file == "" then
    vim.notify("No file to run", vim.log.levels.WARN)
    return
  end

  -- vim.cmd("botright vsplit")
  -- vim.cmd("resize 60")
  vim.cmd("enew") -- ensure we have an empty buffer for the terminal

  vim.fn.termopen({ "uv", "run", file }, {
    on_exit = function(_, code)
      if code ~= 0 then
        vim.schedule(function()
          vim.notify("uv run exited with code " .. code, vim.log.levels.WARN)
        end)
      end
    end,
  })

  vim.cmd("startinsert")
end, { desc = "Run current file: uv run" })

require("lspconfig").basedpyright.setup({
  cmd = { "uv", "run", "basedpyright-langserver", "--stdio" },
})

