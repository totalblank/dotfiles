local vim = vim
vim.g.mapleader = "\\"
vim.g.tex_flavor = "latex"

local Plug = vim.fn['plug#']

--- General settings ---
vim.opt.number = true            -- show line numbers
vim.opt.relativenumber = true    -- relative line numbers (useful for motions)
vim.opt.cursorline = true        -- highlight current line

vim.opt.tabstop = 4              -- number of spaces a <Tab> counts for
vim.opt.shiftwidth = 4           -- spaces for autoindent
vim.opt.expandtab = true         -- convert tabs to spaces
vim.opt.smartindent = true       -- auto-indent new lines

vim.opt.wrap = false             -- don’t wrap long lines
vim.opt.scrolloff = 5            -- keep 5 lines visible above/below cursor
vim.opt.sidescrolloff = 8        -- keep 8 columns visible left/right

vim.opt.ignorecase = true        -- ignore case in searches…
vim.opt.smartcase = true         -- …unless you type a capital letter
vim.opt.hlsearch = false         -- don’t highlight all matches by default
vim.opt.incsearch = true         -- show matches as you type

vim.opt.termguicolors = true     -- enable 24-bit colors
vim.opt.signcolumn = "yes"       -- always show the sign column
vim.opt.splitbelow = true        -- splits open below
vim.opt.splitright = true        -- splits open to the right

vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.mouse = "a"              -- enable mouse support

-- UI improvements
vim.opt.showmode = false         -- don’t show mode (e.g. -- INSERT --)
vim.opt.cmdheight = 1            -- keep command line small
vim.opt.laststatus = 3           -- global statusline
vim.opt.updatetime = 300         -- faster diagnostics/updates
vim.opt.timeoutlen = 500         -- shorter wait for mapped sequences

-- Undo & backup
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true          -- persistent undo

vim.filetype.add{
    extension = {
        tpp = "cpp",
        ipp = "cpp",
        tcc = "cpp",
    },
}


vim.call('plug#begin')
	Plug('rebelot/kanagawa.nvim')
	Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })

    Plug('L3MON4D3/LuaSnip')
    Plug('rafamadriz/friendly-snippets')

    Plug('hrsh7th/nvim-cmp')
    Plug('hrsh7th/cmp-nvim-lsp')
    Plug('hrsh7th/cmp-buffer')
    Plug('hrsh7th/cmp-path')
    Plug('hrsh7th/cmp-cmdline')
    Plug('neovim/nvim-lspconfig')
    Plug('windwp/nvim-autopairs')

    Plug("mason-org/mason.nvim")
    Plug("mason-org/mason-lspconfig.nvim")

    Plug("HakonHarnes/img-clip.nvim")

    Plug("jpalardy/vim-slime")

    Plug('junegunn/fzf', { ['do'] = vim.fn['fzf#install'] })
    Plug('ibhagwan/fzf-lua')
vim.call('plug#end')

--- Color Scheme ---

-- Default options:
require('kanagawa').setup({
    compile = true,             -- enable compiling the colorscheme
    undercurl = true,            -- enable undercurls
    statementStyle = { bold = true, italic = false },
    transparent = true,         -- do not set background color
    dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
    terminalColors = true,       -- define vim.g.terminal_color_{0,17}
    theme = "wave",              -- Load "wave" theme

    commentStyle = { italic = false },
    keywordStyle = { italic = false },
    overrides = function() return { ["@variable.builtin"] = { italic = false }, } end,
})

-- Detect if running in TTY (without GUI/truecolor support)
if vim.fn.has('gui_running') == 0 and vim.o.termguicolors == false then
  -- TTY-friendly colorschemes
  vim.cmd('slient! colorscheme desert')
  -- or other TTY-friendly options:
  -- vim.cmd('colorscheme elflord')
  -- vim.cmd('colorscheme slate')
  -- vim.cmd('colorscheme industry')
  -- vim.cmd('colorscheme evening')
else
  -- Your regular colorscheme for GUI/truecolor terminals
  vim.cmd("silent! colorscheme kanagawa")
end


--- Treesitter ---
require'nvim-treesitter'.setup {
  ensure_installed = { "c", "cpp", "lua", "markdown", "markdown_inline", "latex", "r", "python" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,

    disable = function(_, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    additional_vim_regex_highlighting = false,
  },
}

--- Popup ---
require("popup")

--- LSP ---
require("lsp_config")

--- Clipboard ---
require("clipboard")

--- Snippets ---
require("snippets")

--- Code Runner for Python and R ---
require("slime")

--- fzf-lua ---
require("fzf_config")

-- Create a new autocommand group to prevent duplication
vim.api.nvim_create_augroup("MarkdownTemplate", { clear = true })

-- Add an autocommand to insert the template on creating a new markdown file
vim.api.nvim_create_autocmd("BufNewFile", {
  group = "MarkdownTemplate",
  pattern = "*.md",
  callback = function()
    -- Replace the path with the correct location of your markdown template
    local template_file = vim.fn.expand("~/dotfiles/nvim/templates/md.md")
    vim.cmd("0r " .. template_file)  -- Read the template at the first line
  end,
})

-- Helper function to read the template file and insert it into the current buffer
local function load_latex_template(filename)
  local template_path = vim.fn.stdpath("config") .. "/templates/" .. filename
  if vim.fn.filereadable(template_path) == 1 then
    local lines = vim.fn.readfile(template_path)
    -- Replace the contents of the current empty buffer with the template lines
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  else
    vim.notify("Template not found: " .. template_path, vim.log.levels.WARN)
  end
end

-- Define the autocommand for new TeX files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.tex",
  callback = function()
      local options = {
          "Casual Template",
          "Academic Journal Template",
          "Empty File",
    }

    -- Open a selection menu
    vim.ui.select(options, {
      prompt = "Select a LaTeX template:",
    }, function(choice)
      if choice == "Casual Template" then
        load_latex_template("casual.tex")
      elseif choice == "Academic Journal Template" then
        load_latex_template("academic.tex")
      end
    end)
  end,
})
