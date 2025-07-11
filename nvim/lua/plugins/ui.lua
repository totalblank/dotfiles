return {
  {
    "folke/noice.nvim",
    dependencies = {
      {
        "rcarriga/nvim-notify",
        opts = {
          timeout = 8000, -- ← This controls the timeout (in milliseconds)
          stages = "fade", -- Optional: style of animation
          max_width = nil, -- ← allow full message width
          max_height = nil, -- ← allow full height if multi-line
          render = "default",
        },
      },
    },
    opts = function(_, opts)
      -- Skip noisy messages
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })

      -- Set Noice to use nvim-notify for notifications
      opts.views = opts.views or {}
      opts.views.notify = {
        backend = "notify",
      }

      opts.presets.lsp_doc_border = true
      opts.presets.inc_rename = true
    end,
  },
  --- filename
  {
    "b0o/incline.nvim",
    dependencies = { "rebelot/kanagawa.nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local colors = require("kanagawa.colors").setup()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.palette.dragonAsh, guifg = colors.palette.autumnRed },
            InclineNormalNC = { guibg = colors.palette.dragonBlack3, guifg = colors.palette.dragonRed },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+]" .. filename
          end
        end,
      })
    end,
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous Tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icon = false,
        show_close_icon = false,
      },
    },
  },

  -- animations
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.scroll = {
        enable = false,
      }
    end,
  },

  -- logo
}
