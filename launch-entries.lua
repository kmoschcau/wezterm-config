local M = {}

---@param config Config
local function add_windows_entries_and_default(config)
  ---@type Wezterm
  local wezterm = require "wezterm"

  local function is_executable_in_path(executable)
    return wezterm.run_child_process { "where.exe", "/Q", executable }
  end

  local pwsh_present = is_executable_in_path "pwsh.exe"
  local powershell_present = is_executable_in_path "powershell.exe"
  local nu_present = is_executable_in_path "nu.exe"

  local cmd_args = { os.getenv "COMSPEC", "/k" }

  if pwsh_present then
    local pwsh_args = { "pwsh.exe", "-NoLogo" }
    table.insert(config.launch_menu, {
      label = "PowerShell",
      args = pwsh_args,
    })
    config.default_prog = pwsh_args
  elseif powershell_present then
    local powershell_args = { "powershell.exe", "-NoLogo" }
    table.insert(config.launch_menu, {
      label = "Windows PowerShell",
      args = powershell_args,
    })
    config.default_prog = powershell_args
  else
    config.default_prog = cmd_args
  end

  table.insert(config.launch_menu, {
    label = "Command Prompt",
    args = cmd_args,
  })

  if nu_present then
    local nu_args = { "nu.exe" }
    table.insert(config.launch_menu, {
      label = "Nushell",
      args = nu_args,
    })
    config.default_prog = nu_args
  end
end

---@param config Config
function M.add_launch_entries_and_default_program(config)
  config.launch_menu = {}

  -- See: https://github.com/wezterm/wezterm/issues/5963

  if require("system-compat").is_on_windows() then
    add_windows_entries_and_default(config)
  else
    -- TODO: Make this more sensitive on Linux machines.
    local nu_args = { "nu" }
    table.insert(config.launch_menu, {
      label = "Nushell",
      args = nu_args,
    })

    local fish_args = { "fish" }
    table.insert(config.launch_menu, {
      label = "fish",
      args = fish_args,
    })
    config.default_prog = fish_args
  end
end

return M
