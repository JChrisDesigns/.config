#!/usr/bin/env lua

local AERO = "/opt/homebrew/bin/aerospace"
local SKETCHYBAR = "/opt/homebrew/bin/sketchybar"
local STATE_FILE = "/tmp/sketchybar_app_workspace.json"

local app_icons = {
  ["Notion Mail"] = "", ["Notion"] = "", ["Figma"] = "",
  ["Notes"] = "", ["Safari"] = "", ["Messages"] = "󰭹",
  ["Goodnotes"] = "", ["Brave Browser"] = "", ["Ghostty"] = "",
  ["Code"] = "", ["Finder"] = "", ["Print Center"] = "",
  ["System Settings"] = "", ["Spotify"] = "", ["Legcord"] = "",
  ["Preview"] = "", ["Dev Server"] = ""
}

local app_colors = {
  ["Code"] = "0xFF1D88EB",
  ["Spotify"] = "0xFF24D34E"
}

-- Utilities
local function read_json(path)
  local f = io.open(path, "r")
  if not f then return {} end
  local content = f:read("*a")
  f:close()
  local ok, result = pcall(function() return assert(load("return " .. content))() end)
  return ok and result or {}
end

local function write_json(path, tbl)
  local f = io.open(path, "w")
  if not f then return end
  f:write("{")
  local first = true
  for k, v in pairs(tbl) do
    if not first then f:write(",") end
    f:write(string.format("[%q]=%q", k, v))
    first = false
  end
  f:write("}")
  f:close()
end

local function get_visible_app_workspace_map()
  local map, seen = {}, {}
  local pipe = io.popen(AERO .. " list-windows --all --format '%{app-name}|%{workspace}'")
  if not pipe then return map end

  for line in pipe:lines() do
    local app, ws = line:match("^%s*(.-)%s*|%s*(.-)%s*$")
    if app and ws and not seen[app] then
      seen[app] = true
      map["app." .. app:gsub(" ", "_")] = ws
    end
  end

  pipe:close()
  return map
end

local function reverse_name(item)
  return item:match("^app%.(.+)$"):gsub("_", " ")
end

-- Load state
local prev_ws_map = read_json(STATE_FILE)
local curr_ws_map = get_visible_app_workspace_map()

-- Skip if no change
local changed = false
for k, v in pairs(curr_ws_map) do
  if prev_ws_map[k] ~= v then
    changed = true
    break
  end
end
if not changed then return end

-- Save new state
write_json(STATE_FILE, curr_ws_map)

-- Track active items
local open_items = {}

for item, ws in pairs(curr_ws_map) do
  open_items[item] = true
  local app = reverse_name(item)
  local icon = app_icons[app]
  local color = app_colors[app] or "0xFFFFFFFF"

  if icon and icon ~= "" then
    -- Check if item exists
    local check = io.popen(SKETCHYBAR .. " --query " .. item .. " 2>/dev/null")
    local exists = check:read("*a")
    check:close()

    if not exists or exists == "" then
      os.execute(string.format('%s --add item "%s" left', SKETCHYBAR, item))
    end

    os.execute(string.format(
      '%s --set "%s" label="%s" label.color=%s label.padding_left=0 padding_left=0',
      SKETCHYBAR, item, icon, color
    ))

    if prev_ws_map[item] ~= ws then
      os.execute(string.format('%s --move "%s" after "space.%s"', SKETCHYBAR, item, ws))
    end
  end
end

-- Remove unused items
local bar = io.popen(SKETCHYBAR .. " --query bar"):read("*a")
for item in bar:gmatch('"app%.[^"]+"') do
  local clean = item:sub(2, -2)
  if not open_items[clean] then
    os.execute(string.format('%s --remove "%s"', SKETCHYBAR, clean))
  end
end
