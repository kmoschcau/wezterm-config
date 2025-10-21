local M = {}

--- @return boolean
function M.is_on_windows()
  ---@type Wezterm
  local wezterm = require "wezterm"

  return wezterm.target_triple == "x86_64-pc-windows-msvc"
end

return M
