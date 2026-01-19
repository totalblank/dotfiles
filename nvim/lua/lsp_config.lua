local lsp = require('lspconfig')
local caps = require('cmp_nvim_lsp').default_capabilities()
local runners = require("runners")

vim.o.completeopt = "menu,menuone,noselect"

local cmp = require("cmp")
local luasnip = require("luasnip")
pcall(require("luasnip.loaders.from_vscode").lazy_load)
local win = vim.fn.has("win32") == 1


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

vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 2 },
  underline = true,
  update_in_insert = false,
  severity_sort = true,

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.Error .. " ",
      [vim.diagnostic.severity.WARN]  = icons.Warn  .. " ",
      [vim.diagnostic.severity.HINT]  = icons.Hint  .. " ",
      [vim.diagnostic.severity.INFO]  = icons.Info  .. " ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
    },
  },
})

vim.lsp.config("clangd", {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
})

vim.lsp.enable("clangd")

vim.keymap.set("n", "<leader>r", function()
  -- Save current file first
  vim.cmd("write")

  local file = vim.fn.expand("%:p") -- absolute path
  if file == "" then
    vim.notify("No file to run", vim.log.levels.WARN)
    return
  end

  local ft = vim.bo.filetype
  local cmd = runners.command_for(file, ft)

  -- vim.cmd("botright vsplit")
  -- vim.cmd("resize 60")
  vim.cmd("enew") -- ensure we have an empty buffer for the terminal

  vim.fn.termopen(cmd, {
    on_exit = function(_, code)
      if code ~= 0 then
        vim.schedule(function()
          vim.notify("Command exited with code " .. code, vim.log.levels.WARN)
        end)
      end
    end,
  })

  vim.cmd("startinsert")
end, { desc = "Run current file" })

vim.lsp.config.basedpyright = {
  cmd = { "uv", "run", "basedpyright-langserver", "--stdio" },
}

vim.lsp.config.lua_ls = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".git", vim.uv.cwd() },
  settings = {
    Lua = {
      telemetry = {
        enable = false,
      },
    },
  },
}

vim.lsp.enable("basedpyright")
vim.lsp.enable("lua_ls")
