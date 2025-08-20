-- === R REPL without plugins (Neovim 0.5+) ===
-- Save in init.lua (or lua/rrepl.lua and `require('rrepl')`)

local R = { term_buf = nil, term_win = nil, chan = nil }

local function chan_is_open()
  if not R.chan then return false end
  -- jobwait returns -1 if job is still running
  local st = vim.fn.jobwait({ R.chan }, 0)[1]
  return st == -1
end

-- make R.open() reuse the existing split/buffer instead of always creating:
function R.open()
  -- If the terminal job is alive and the window exists, just jump to it.
  if chan_is_open() and R.term_win and vim.api.nvim_win_is_valid(R.term_win) then
    return
  end

  -- If we still have a valid terminal buffer but lost the job (or window), reuse it.
  if R.term_buf and vim.api.nvim_buf_is_valid(R.term_buf) then
    -- create (or reuse) a bottom split and show the old buffer
    vim.cmd('botright 12split')
    R.term_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(R.term_win, R.term_buf)
    -- restart R in that buffer if needed
    if not chan_is_open() then
      R.chan = vim.fn.termopen({ "R", "--quiet", "--no-save" })
    end
    vim.wo.number, vim.wo.relativenumber = false, false
    return
  end

  -- Otherwise create everything fresh
  vim.cmd('botright 12split')
  R.term_buf = vim.api.nvim_create_buf(false, true)
  R.term_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(R.term_win, R.term_buf)
  R.chan = vim.fn.termopen({ "R", "--quiet", "--no-save" })
  vim.wo.number, vim.wo.relativenumber = false, false
end

local function ensure()
  if not chan_is_open() then R.open() end
end

local function send(text_or_lines)
  ensure()
  local payload
  if type(text_or_lines) == "table" then
    payload = table.concat(text_or_lines, "\n") .. "\n"
  else
    payload = tostring(text_or_lines)
    if not payload:match("\n$") then payload = payload .. "\n" end
  end
  -- Use nvim_chan_send if available; fallback to chansend for older builds
  if vim.api.nvim_chan_send then
    vim.api.nvim_chan_send(R.chan, payload)
  else
    vim.fn.chansend(R.chan, payload)
  end
end

function R.send_line() send(vim.api.nvim_get_current_line()) end

function R.send_block()
  local s = vim.fn.search('^\\s*$', 'bnW') + 1
  local e = vim.fn.search('^\\s*$', 'nW') - 1
  if e < s then s, e = vim.fn.line('.'), vim.fn.line('.') end
  send(vim.api.nvim_buf_get_lines(0, s-1, e, false))
end

function R.send_file()
  send(vim.api.nvim_buf_get_lines(0, 0, -1, false))
end

function R.send_selection()
  -- Works for v/V/CTRL-V
  local mode = vim.fn.mode()
  if not (mode == 'v' or mode == 'V' or mode == '\022') then
    vim.notify("Visual-select the code first", vim.log.levels.WARN); return
  end
  local s = vim.fn.getpos("'<")
  local e = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, s[2]-1, e[2], false)
  if mode == 'v' and #lines > 0 then
    local first_col, last_col = s[3], e[3]
    if #lines == 1 then
      lines[1] = string.sub(lines[1], first_col, last_col)
    else
      lines[1] = string.sub(lines[1], first_col)
      lines[#lines] = string.sub(lines[#lines], 1, last_col)
    end
  end
  send(lines)
end

function R.interrupt() if chan_is_open() then send("\003") end end -- Ctrl-C
function R.close()
  if chan_is_open() then pcall(vim.fn.chanclose, R.chan) end
  if R.term_buf and vim.api.nvim_buf_is_valid(R.term_buf) then
    vim.api.nvim_buf_delete(R.term_buf, { force = true })
  end
  R.term_buf, R.term_win, R.chan = nil, nil, nil
end

-- Keymaps (change <leader> if you like)
vim.keymap.set('n', '<leader>ro', R.open,           {desc='Open R REPL'})
vim.keymap.set('n', '<leader>rl', R.send_line,      {desc='Send line to R'})
vim.keymap.set('v', '<leader>rs', R.send_selection, {desc='Send selection to R'})
vim.keymap.set('n', '<leader>rb', R.send_block,     {desc='Send paragraph to R'})
vim.keymap.set('n', '<leader>rf', R.send_file,      {desc='Send whole file to R'})
vim.keymap.set('n', '<leader>rk', R.interrupt,      {desc='Interrupt R (Ctrl-C)'})
vim.keymap.set('n', '<leader>rq', R.close,          {desc='Close R REPL'})

