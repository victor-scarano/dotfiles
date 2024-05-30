local wezterm = require("wezterm")

local action = wezterm.action
local ActivateTab = action.ActivateTab
local SpawnTab = action.SpawnTab
local ActivateTabRelative = action.ActivateTabRelative
local CloseCurrentTab = action.CloseCurrentTab
local MoveTabRelative = action.MoveTabRelative

local tabs = {}

local keys = {}
function keys.apply_to_config(config)
    util.insert_keys(config, {
        -- spawn a new tab
        { key = "t", mods = "CTRL", action = SpawnTab("CurrentPaneDomain") },
        -- activate the tab to the left of the current tab
        { key = "[", mods = "CTRL", action = ActivateTabRelative(-1) },
        -- activate the tab to the right of the current tab
        { key = "]", mods = "CTRL", action = ActivateTabRelative(1) },
        -- close the current tab
        { key = "T", mods = "CTRL|SHIFT", action = CloseCurrentTab { confirm = false } },
        -- move the current tab to the left
        { key = "{", mods = "CTRL|SHIFT", action = MoveTabRelative(-1) },
        -- move the current tab to the right
        { key = "}", mods = "CTRL|SHIFT", action = MoveTabRelative(1) }
    })

    -- activate a tab by its index
    for i = 1, 8 do
        table.insert(config.keys, { key = "F" .. tostring(i), action = ActivateTab(i - 1) })
    end
end

function tabs.apply_to_config(config)
    keys.apply_to_config(config)
end

return tabs
