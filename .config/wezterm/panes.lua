local wezterm = require("wezterm")

local action = wezterm.action
local ActivateKeyTable = action.ActivateKeyTable
local ActivatePaneDirection = action.ActivatePaneDirection
local CloseCurrentPane = action.CloseCurrentPane
local SplitPane = action.SplitPane
local PopKeyTable = action.PopKeyTable
local AdjustPaneSize = action.AdjustPaneSize

local panes = {}

local keys = {}
function keys.apply_to_config(config)
    util.insert_keys(config, {
        -- activate `split_pane` key table
        { key = "s", mods = "CTRL", action = ActivateKeyTable { name = "split_pane" } },
        -- activate `resize_pane` key table
        {
            key = "r",
            mods = "CTRL",
            action = wezterm.action_callback(function(window, pane)
                local active_tab = window:active_tab()
                local panes = active_tab:panes()
                if #panes > 1 then
                    window:perform_action(ActivateKeyTable { name = "resize_pane", one_shot = false, until_unknown = true }, pane)
                end
            end)
        },

        -- activate pane left
        { key = "h", mods = "CTRL", action = ActivatePaneDirection("Left") },
        -- activate pane below
        { key = "j", mods = "CTRL", action = ActivatePaneDirection("Down") },
        -- activate pane above
        { key = "k", mods = "CTRL", action = ActivatePaneDirection("Up") },
        -- activate pane right
        { key = "l", mods = "CTRL", action = ActivatePaneDirection("Right") },

        -- close pane
		{
			key = "s",
			mods = "CTRL|ALT",
			action = wezterm.action_callback(function(window, pane)
				local active_tab = window:active_tab()
				local panes = active_tab:panes()
				window:perform_action(CloseCurrentPane { confirm = #panes == 1 }, pane)
			end)
		}
    })
end

local key_tables = {}
function key_tables.apply_to_config(config)
    config.key_tables.split_pane = {
        -- split pane vertically with the new pane to the left of the current pane
        { key = "h", action = SplitPane { direction = "Left" } },
        -- split pane horizontally with the new pane below the current pane
        { key = "j", action = SplitPane { direction = "Down" } },
        -- split pane horizontally with the new pane above the current pane
        { key = "k", action = SplitPane { direction = "Up" } },
        -- split pane vertically with the new pane to the right of the current pane
        { key = "l", action = SplitPane { direction = "Right" } },

        -- exit `split_pane` key table
        { key = "Escape", action = PopKeyTable }
    }

    config.key_tables.resize_pane = {
        -- split pane vertically with the new pane to the left of the current pane
        { key = "h", action = AdjustPaneSize { "Left", 1 } },
        -- split pane horizontally with the new pane below the current pane
        { key = "j", action = AdjustPaneSize { "Down", 1 } },
        -- split pane horizontally with the new pane above the current pane
        { key = "k", action = AdjustPaneSize { "Up", 1 } },
        -- split pane vertically with the new pane to the right of the current pane
        { key = "l", action = AdjustPaneSize { "Right", 1 } },

        -- exit `resize_pane` key table
        { key = "Escape", action = PopKeyTable }
    }
end

function panes.apply_to_config(config)
    keys.apply_to_config(config)
    key_tables.apply_to_config(config)
end

return panes

