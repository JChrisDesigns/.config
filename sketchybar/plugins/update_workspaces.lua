-- ~/.config/sketchybar/plugins/update_workspaces.lua

local sketchybar = require("sketchybar")
local json = require("json")

local AERO = "/opt/homebrew/bin/aerospace"
local STATE_FILE = "/tmp/sketchybar_app_workspace.json"

-- Load previous state
local prev_ws_map = read_json(STATE_FILE)
local curr_ws_map = get_visible_app_workspace_map()

-- If nothing changed, exit early
if json.encode(prev_ws_map) == json.encode(curr_ws_map) then return end

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

local function read_json(path)
  local f = io.open(path, "r")
  if not f then return {} end
  local data = f:read("*a")
  f:close()
  return data and json.decode(data) or {}
end

local function write_json(path, value)
  local f = io.open(path, "w")
  if f then f:write(json.encode(value)); f:close() end
end

local function get_visible_app_workspace_map()
  local cmd = io.popen(AERO .. " list-windows --visible --format '%{app-name}|%{workspace}'")
  if not cmd then return {} end

  local seen, result = {}, {}
  for line in cmd:lines() do
    local app, ws = line:match("^%s*(.-)%s*|%s*(.-)%s*$")
    if app and not seen[app] then
      seen[app] = true
      result["app." .. app:gsub(" ", "_")] = ws
    end
  end
  cmd:close()
  return result
end

-- Save new state
write_json(STATE_FILE, curr_ws_map)

-- Get reverse app name from item name
local function reverse_name(name)
  return name:match("^app%.(.+)$"):gsub("_", " ")
end

-- Track active items
local open_items = {}

for item_name, ws in pairs(curr_ws_map) do
  open_items[item_name] = true
  local app = reverse_name(item_name)
  local icon = app_icons[app]
  local color = app_colors[app] or "0xFFFFFFFF"

  if icon and icon ~= "" then
    if not sketchybar.query(item_name) then
      sketchybar.add({ item = item_name, position = "left" })
      sketchybar.set({
        [item_name] = {
          label = icon,
          ["label.color"] = color,
          ["label.padding_left"] = 0,
          ["padding_left"] = 0
        }
      })
    end

    if prev_ws_map[item_name] ~= ws then
      sketchybar.move({ item = item_name, after = "space." .. ws })
    end
  end
end

-- Remove any items no longer in the map
local items = sketchybar.query("bar").items or {}
for _, item in ipairs(items) do
  if item:match("^app%.") and not open_items[item] then
    sketchybar.remove({ item = item })
  end
end
