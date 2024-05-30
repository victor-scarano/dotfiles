local wezterm = require("wezterm")

local action = wezterm.action
local CopyTo = action.CopyTo
local PasteFrom = action.PasteFrom
local QuitApplication = action.QuitApplication

local std = {}

local keys = {}
function keys.apply_to_config(config)
    util.insert_keys(config, {
        -- copy to clipboard
        { key = "c", mods = "CTRL", action = CopyTo("Clipboard") },
        -- paste from clipboard
        { key = "v", mods = "CTRL", action = PasteFrom("Clipboard") },
        -- quit application
        { key = "q", mods = "CTRL", action = QuitApplication }
    })
end

function std.apply_to_config(config)
    keys.apply_to_config(config)
end

return std
