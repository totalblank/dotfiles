local o = vim.opt
o.number         = true
o.relativenumber = true
o.mouse          = "a"
o.clipboard      = "unnamedplus"
o.ignorecase     = true
o.smartcase      = true
o.termguicolors  = true
o.hidden         = true
o.updatetime     = 300
o.timeoutlen     = 400
o.signcolumn     = "yes"
o.splitright     = true
o.splitbelow     = true
o.scrolloff      = 4
o.sidescrolloff  = 8
o.expandtab      = true
o.shiftwidth     = 2
o.tabstop        = 2
o.cursorline     = true
o.completeopt    = { "menuone", "noselect" }  -- for built-in completion popup
o.shortmess:append("c")
-- statusline that's simple and fast
vim.o.laststatus = 3
vim.o.statusline = table.concat({
  " %f %m%r%h", " %=", " [%{&filetype}] ", " %l:%c ", " %p%% "
}, "")

