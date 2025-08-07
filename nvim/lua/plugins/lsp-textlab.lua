return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              build = {
                executable = "latexmk",
                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                onSave = false, -- avoid building on every save
              },
              forwardSearch = {
                executable = "zathura", -- or your preferred PDF viewer
                args = { "--synctex-forward", "%l:1:%f", "%p" },
              },
              chktex = {
                onOpenAndSave = false, -- disables linting at open/save
              },
              diagnosticsDelay = 300, -- delay diagnostics for responsiveness
              formatterLineLength = 100, -- wider line wrap limit
              latexFormatter = "latexindent", -- still allows on-demand format
              latexindent = {
                modifyLineBreaks = false,
              },
            },
          },
        },
      },
    },
  },
}
