local wezterm = require "wezterm"
local compat = require "system-compat"

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font "FiraMono Nerd Font"
config.font_size = 10

compat.set_default_prog(config)

local launch_menu = {}
compat.add_vs_cmds(launch_menu)
config.launch_menu = launch_menu

return config
