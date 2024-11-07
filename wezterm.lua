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

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = scheme_for_appearance(get_appearance())
config.font = wezterm.font "FiraMono Nerd Font"
config.font_size = 10

compat.set_default_prog(config)

local launch_menu = {}
compat.add_vs_cmds(launch_menu)
config.launch_menu = launch_menu

return config
