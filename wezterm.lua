---@type Wezterm
local wezterm = require "wezterm"

local compat = require "system-compat"

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Dark"
end

local function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

---@type Config
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = scheme_for_appearance(get_appearance())

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

local launch_menu = {}
compat.add_vs_cmds(launch_menu)
config.launch_menu = launch_menu

return config
