local wezterm = require "wezterm"

local M = {}

function M.add_vs_cmds(launch_menu)
  if M.is_on_windows() then
    table.insert(launch_menu, {
      label = "Powershell",
      args = { "pwsh", "-NoLogo" },
    })

    -- Find installed visual studio version(s) and add their compilation
    -- environment command prompts to the menu
    for _, vsvers in
      ipairs(
        wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")
      )
    do
      local year = vsvers:gsub("Microsoft Visual Studio/", "")
      table.insert(launch_menu, {
        label = "x64 Native Tools VS " .. year,
        args = {
          "cmd.exe",
          "/k",
          "C:/Program Files (x86)/"
            .. vsvers
            .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
        },
      })
    end

    -- Find installed visual studio version(s) and add their compilation
    -- environment command prompts to the menu
    for _, vsvers in
      ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files"))
    do
      local year = vsvers:gsub("Microsoft Visual Studio/", "")
      table.insert(launch_menu, {
        label = "x64 Native Tools VS " .. year,
        args = {
          "cmd.exe",
          "/k",
          "C:/Program Files/"
            .. vsvers
            .. "/Enterprise/VC/Auxiliary/Build/vcvars64.bat",
        },
      })
    end
  end
end

--- @return boolean
function M.is_on_windows()
  return wezterm.target_triple == "x86_64-pc-windows-msvc"
end

function M.set_default_prog(config)
  if M.is_on_windows() then
    config.default_prog = { "pwsh", "-NoLogo" }
  else
    config.default_prog = { "fish" }
  end
end

return M
