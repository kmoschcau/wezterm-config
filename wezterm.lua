local wezterm = require "wezterm"
local windows = require "windows"

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

local launch_menu = {}
windows.add_vs_cmds(launch_menu)

config.default_prog = { "pwsh", "-NoLogo" }
config.launch_menu = launch_menu

return config
