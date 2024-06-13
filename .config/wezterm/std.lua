local wezterm = require("wezterm")

local action = wezterm.action
local CopyTo = action.CopyTo
local SendKey = action.SendKey
local PasteFrom = action.PasteFrom
local QuitApplication = action.QuitApplication
local ToggleFullScreen = action.ToggleFullScreen

local std = {}

local keys = {}
function keys.apply_to_config(config)
    util.insert_keys(config, {
        -- copy to clipboard
        {
			key = "c",
			mods = "CTRL",
			action = wezterm.action_callback(function(window, pane)
				local text = window:get_selection_text_for_pane(pane)
				if string.len(text) ~= 0 then
					window:perform_action(CopyTo("Clipboard"), pane)
				else
					window:perform_action(SendKey { key = "c", mods = "CTRL" }, pane)
				end
			end)
		},
        -- paste from clipboard
        { key = "v", mods = "CTRL", action = PasteFrom("Clipboard") },
        -- quit application
        { key = "q", mods = "CTRL", action = QuitApplication },
		-- toggle fullscreen
		{ key = "F11", action = ToggleFullScreen }
    })
end

function std.apply_to_config(config)
    keys.apply_to_config(config)
end

return std

