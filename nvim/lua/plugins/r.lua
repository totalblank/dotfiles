return {
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("quarto").setup({
        debug = false,
        closePreviewOnExit = true,
        lspFeatures = {
          enabled = true,
          chunks = "curly",
          languages = { "r", "python", "julia", "bash", "html" },
          diagnostics = {
            enabled = false,
            triggers = { "BufWritePost" },
          },
          completion = {
            enabled = true,
          },
        },
        codeRunner = {
          enabled = true,
          default_method = "slime", -- "molten", "slime", "iron" or <function>
          ft_runners = {}, -- filetype to runner, ie. `{ python = "molten" }`.
          -- Takes precedence over `default_method`
          never_run = { "yaml" }, -- filetypes which are never sent to a code runner
        },
        keymap = {
          preview = "<leader>qp",
        },

        vim.keymap.set("n", "<leader>qp", function()
          local file = vim.fn.expand("%:p") -- full path
          vim.cmd('belowright split | terminal quarto preview "' .. file .. '"')
        end, { desc = "Quarto: Preview current file in terminal" }),

        vim.keymap.set("n", "<leader>rc", function()
          local lines = {
            "```{r}",
            "",
            "```",
          }
          vim.api.nvim_put(lines, "l", true, true)
          -- Move cursor up to the middle of the chunk
          vim.cmd("normal! k")
        end, { desc = "Insert R code chunk" }),
      })
    end,
  },
  {
    "jpalardy/vim-slime",
    init = function()
      -- these two should be set before the plugin loads
      -- vim.g.slime_target = "tmux"
      -- vim.g.slime_no_mappings = true

      vim.g.slime_target = "tmux"
    end,
    config = function()
      vim.g.slime_input_pid = false
      vim.g.slime_suggest_default = true
      vim.g.slime_menu_config = false
      vim.g.slime_neovim_ignore_unlisted = false
      -- options not set here are g:slime_neovim_menu_order, g:slime_neovim_menu_delimiter, and g:slime_get_jobid
      -- see the documentation above to learn about those options

      -- called MotionSend but works with textobjects as well
      vim.keymap.set("n", "gz", "<Plug>SlimeMotionSend", { remap = true, silent = false })
      vim.keymap.set("n", "gzz", "<Plug>SlimeLineSend", { remap = true, silent = false })
      vim.keymap.set("x", "gz", "<Plug>SlimeRegionSend", { remap = true, silent = false })
      vim.keymap.set("n", "gzc", "<Plug>SlimeConfig", { remap = true, silent = false })
    end,
  },
  { -- preview equations
    "jbyuki/nabla.nvim",
    keys = {
      { "<leader>qm", ':lua require"nabla".toggle_virt()<cr>', desc = "toggle [m]ath equations" },
    },
  },
  { -- paste an image from the clipboard or drag-and-drop
    "HakonHarnes/img-clip.nvim",
    event = "BufEnter",
    ft = { "markdown", "quarto", "latex" },
    opts = {
      default = {
        dir_path = "img",
      },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = {
            download_images = false,
          },
        },
        quarto = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = {
            download_images = false,
          },
        },
      },
    },
    config = function(_, opts)
      require("img-clip").setup(opts)
      vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "insert [i]mage from clipboard" })
    end,
  },
}
