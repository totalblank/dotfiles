local M = {}

function M.is_windows()
  return vim.fn.has("win32") == 1
end

function M.open_pdf_cmd(pdf, opts)
  opts = opts or {}
  local win = M.is_windows()

  if win then
    -- Change this path if needed
    local sumatra = opts.sumatra_path or [[C:\Users\Takiz\AppData\Local\SumatraPDF\SumatraPDF.exe]]
    return {
      "powershell",
      "-NoProfile",
      "-ExecutionPolicy",
      "Bypass",
      "-Command",
      ('& "%s" -reuse-instance "%s"'):format(sumatra, pdf),
    }
  end

  return { "sh", "-lc", ('xdg-open "%s"'):format(pdf) }
end

function M.md_to_pdf_cmd(file, opts)
  opts = opts or {}
  local stem = vim.fn.fnamemodify(file, ":r")
  local pdf  = stem .. ".pdf"

  if M.is_windows() then
    local sumatra = opts.sumatra_path or [[C:\Users\Takiz\AppData\Local\SumatraPDF\SumatraPDF.exe]]
    local ps = ([[pandoc "%s" -o "%s";
if ($LASTEXITCODE -eq 0) { & "%s" -reuse-instance "%s" }]]):format(file, pdf, sumatra, pdf)

    return { "powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", ps }
  end

  return { "sh", "-lc", ('pandoc "%s" -o "%s" && zathura "%s"'):format(file, pdf, pdf) }
end

function M.latexmk_pdf_cmd(file, opts)
  opts = opts or {}
  local stem = vim.fn.fnamemodify(file, ":r")
  local pdf  = stem .. ".pdf"

  if M.is_windows() then

    local sumatra = opts.sumatra_path or [[C:\Users\Takiz\AppData\Local\SumatraPDF\SumatraPDF.exe]]
    local ps = ([[latexmk -pdflatex=lualatex -pdf "%s";
if ($LASTEXITCODE -eq 0) { & "%s" -reuse-instance "%s" }]]):format(file, sumatra, pdf)

    return { "powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", ps }
  end

  return { "sh", "-lc", ('latexmk -pdflatex=lualatex -pdf "%s" && xdg-open "%s"'):format(file, pdf) }
end

function M.c_cmd(file)
  if M.is_windows() then
    local stem = vim.fn.fnamemodify(file, ":r")
    local exe  = stem .. ".exe"
    local ps = ([[gcc "%s" -O2 -o "%s";
if ($LASTEXITCODE -eq 0) { & "%s" }]]):format(file, exe, exe)
    return { "powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", ps }
  end

  local exe = "/tmp/nvim_run.out"
  return { "sh", "-lc", ('gcc "%s" -O2 -o "%s" && "%s"'):format(file, exe, exe) }
end

function M.cpp_cmd(file)
  local flags = '-std=c++17 -Wall -Wextra -Wpedantic -O2'

  if M.is_windows() then
    local stem = vim.fn.fnamemodify(file, ":r")
    local exe  = stem .. ".exe"
    local ps = ([[g++ "%s" %s -o "%s";
if ($LASTEXITCODE -eq 0) { & "%s" }]]):format(file, flags, exe, exe)
    return { "powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", ps }
  end

  local exe = "/tmp/nvim_run.out"
  return {
    "sh",
    "-lc",
    ('g++ "%s" %s -o "%s" && "%s"'):format(file, flags, exe, exe)
  }
end

function M.command_for(file, ft, opts)
  opts = opts or {}
  local win = M.is_windows()

  local runners = {
    python = { "uv", "run", file },
    lua    = { "lua", file },
    sh     = win and { "powershell", "-NoProfile", "-File", file } or { "bash", file },

    markdown = M.md_to_pdf_cmd(file, opts),
    tex      = M.latexmk_pdf_cmd(file, opts),

    c   = M.c_cmd(file),
    cpp = M.cpp_cmd(file),
  }

  return runners[ft]
end

return M
