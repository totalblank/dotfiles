local vim = vim
vim.g.mapleader = "\\"

local uname = vim.loop.os_uname()
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
  -- vim.cmd('slient! colorscheme desert')
  -- or other TTY-friendly options:
  -- vim.cmd('colorscheme elflord')
  -- vim.cmd('colorscheme slate')
  -- vim.cmd('colorscheme industry')
  vim.cmd('colorscheme evening')
else
  -- Your regular colorscheme for GUI/truecolor terminals
  vim.cmd("silent! colorscheme kanagawa")
end


--- Treesitter ---
require'nvim-treesitter'.setup {
  ensure_installed = { "c", "cpp", "lua", "markdown", "markdown_inline", "latex", "r" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,

    disable = function(lang, buf)
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
