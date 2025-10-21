---@type Wezterm
local wezterm = require "wezterm"

local compat = require "system-compat"

---@return "Dark"|"DarkHighContrast"|"Light"|"LightHighContrast"
local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Dark"
end

---@param appearance "Dark"|"DarkHighContrast"|"Light"|"LightHighContrast"
---@return string
local function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

---@param tab_info TabInformation
---@return string
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end

  -- Otherwise, use the title from the active pane in that tab
  return tab_info.active_pane.title
end

local PCT_GLYPHS = {
  wezterm.nerdfonts.md_checkbox_blank_circle_outline,
  wezterm.nerdfonts.md_circle_slice_1,
  wezterm.nerdfonts.md_circle_slice_2,
  wezterm.nerdfonts.md_circle_slice_3,
  wezterm.nerdfonts.md_circle_slice_4,
  wezterm.nerdfonts.md_circle_slice_5,
  wezterm.nerdfonts.md_circle_slice_6,
  wezterm.nerdfonts.md_circle_slice_7,
  wezterm.nerdfonts.md_circle_slice_8,
}

---@param pct number
---@return string
local function pct_glyph(pct)
  local slot = math.floor(pct / 12.5)
  return PCT_GLYPHS[slot + 1]
end

wezterm.on("format-tab-title", function(tab)
  ---@type "None"|"Indeterminate"|{ Percentage: number?, Error: number? }
  local progress = tab.active_pane.progress or "None"
  local title = tab_title(tab)
  local elements = {
    { Text = string.format("%d: ", tab.tab_index + 1) },
  }

  if progress ~= "None" then
    local color = "green"
    local status
    if progress.Percentage ~= nil then
      -- status = string.format("%d%%", progress.Percentage)
      status = pct_glyph(progress.Percentage)
    elseif progress.Error ~= nil then
      -- status = string.format("%d%%", progress.Error)
      status = pct_glyph(progress.Error)
      color = "red"
    elseif progress == "Indeterminate" then
      status = wezterm.nerdfonts.md_dots_circle
    else
      ---@diagnostic disable-next-line: param-type-mismatch
      status = wezterm.serde.json_encode(progress)
    end

    table.insert(elements, { Foreground = { Color = color } })
    table.insert(elements, { Text = status .. "  " })
    table.insert(elements, { Foreground = "Default" })
  end

  table.insert(elements, { Text = title })

  return elements
end)

---@type Config
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = scheme_for_appearance(get_appearance())

if compat.is_on_windows() then
  config.default_ssh_auth_sock = "\\\\.\\pipe\\openssh-ssh-agent"
end

local base_font = "FiraMono Nerd Font"
if compat.is_on_windows() then
  config.font = wezterm.font_with_fallback {
    base_font,
    "Segoe UI Emoji",
    { family = "Unifont Upper", scale = 2.0 },
  }
else
  config.font = wezterm.font(base_font)
end
config.font_size = 10
config.underline_position = "210%"

compat.set_default_prog(config)

---@type SpawnCommand[]
local launch_menu = {}
compat.add_vs_cmds(launch_menu)

---@type SpawnCommand
local nushell = {
  label = "Nushell",
  args = { "nu" },
}
table.insert(launch_menu, nushell)

config.launch_menu = launch_menu

return config
