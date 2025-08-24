-- recent_videos.lua
-- Show and play recently opened videos (press 'r' to open menu, 1–9 to pick)
-- Stores history at: ~~/recent-videos.json

local mp = require('mp')
local utils = require('mp.utils')

-- ===== Config =====
local MAX_HISTORY = 50   -- total items to keep
local MENU_SIZE   = 9    -- how many to show in the menu
local HISTORY_PATH = mp.command_native({'expand-path', '~~/recent-videos.json'})

-- ===== Utility =====
local function read_file(path)
    local f = io.open(path, 'r')
    if not f then return nil end
    local data = f:read('*a')
    f:close()
    return data
end

local function write_file(path, data)
    local f, err = io.open(path, 'w')
    if not f then
        mp.msg.error('Failed to write history: '..(err or 'unknown error'))
        return false
    end
    f:write(data)
    f:close()
    return true
end

local function load_history()
    local raw = read_file(HISTORY_PATH)
    if not raw or raw == '' then return {} end
    local ok, tbl = pcall(utils.parse_json, raw)
    if not ok or type(tbl) ~= 'table' then return {} end
    return tbl
end

local function save_history(hist)
    -- trim to MAX_HISTORY and write
    if #hist > MAX_HISTORY then
        for i = MAX_HISTORY + 1, #hist do hist[i] = nil end
    end
    local json = utils.format_json(hist)
    write_file(HISTORY_PATH, json)
end

local function basename(path)
    local dir, file = utils.split_path(path or '')
    return file ~= '' and file or (path or '(unknown)')
end

local function dedupe_and_prepend(hist, item_path, title)
    -- remove any existing entry with same path
    local out = { { path = item_path, title = title, ts = os.time() } }
    local seen = { [item_path] = true }
    for _, e in ipairs(hist) do
        if e and e.path and not seen[e.path] then
            table.insert(out, e)
            seen[e.path] = true
        end
        if #out >= MAX_HISTORY then break end
    end
    return out
end

-- ===== Track openings =====
local function on_file_loaded()
    local path = mp.get_property('path')
    if not path then return end
    -- skip non-file protocols like ytdl? You can choose to keep them:
    -- if path:match('^%a+:%/%/') then return end  -- uncomment to skip URLs
    local title = mp.get_property('media-title') or basename(path)
    local hist = load_history()
    hist = dedupe_and_prepend(hist, path, title)
    save_history(hist)
end
mp.register_event('file-loaded', on_file_loaded)

-- ===== Menu and selection =====
local tmp_binds = {}
local menu_showing = false

local function clear_temp_binds()
    for _, b in ipairs(tmp_binds) do
        mp.remove_key_binding(b)
    end
    tmp_binds = {}
end

local function play_index(idx, hist)
    local entry = hist[idx]
    if not entry then return end
    mp.osd_message('Loading: ' .. (entry.title or basename(entry.path)), 1.5)
    mp.commandv('loadfile', entry.path, 'replace')
    clear_temp_binds()
    menu_showing = false
end

local function show_menu()
    local hist = load_history()
    if #hist == 0 then
        mp.osd_message('Recent videos: (empty)', 2)
        return
    end

    local n = math.min(MENU_SIZE, #hist)
    local lines = { 'Recent videos:' }
    for i = 1, n do
        local e = hist[i]
        local label = string.format('%d) %s', i, e.title or basename(e.path))
        table.insert(lines, label)
    end
    table.insert(lines, '')
    table.insert(lines, 'Press 1–' .. n .. ' to load, Esc to cancel')
    mp.osd_message(table.concat(lines, '\n'), 10)

    clear_temp_binds()
    menu_showing = true

    -- Bind digits 1..n
    for i = 1, n do
        local key = tostring(i % 10)  -- 10 -> 0 (not used here but safe)
        local name = 'recent_pick_' .. i
        mp.add_forced_key_binding(key, name, function() play_index(i, hist) end, { repeatable = false })
        table.insert(tmp_binds, name)
    end

    -- Cancel with Esc
    mp.add_forced_key_binding('ESC', 'recent_cancel', function()
        clear_temp_binds()
        mp.osd_message('Cancelled', 0.5)
        menu_showing = false
    end)
    table.insert(tmp_binds, 'recent_cancel')
end

-- Public key binding: press 'r' to open menu
mp.add_key_binding('r', 'recent-menu', show_menu)

-- Optional: expose script-message for external triggers:
--   script-message-to recent_videos show
mp.register_script_message('show', show_menu)

