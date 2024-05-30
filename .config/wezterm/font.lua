local wezterm = require("wezterm")

local action = wezterm.action
local ActivateKeyTable = action.ActivateKeyTable
local IncreaseFontSize = action.IncreaseFontSize
local DecreaseFontSize = action.DecreaseFontSize
local ResetFontSize = action.ResetFontSize
local PopKeyTable = action.PopKeyTable

local font = {}

local keys = {}
function keys.apply_to_config(config)
    util.insert_keys(config, {
        -- activate `font` key table
        { key = "f", mods = "CTRL", action = ActivateKeyTable { name = "font", one_shot = false } },
    })
end

local key_tables = {}
function key_tables.apply_to_config(config)
    config.key_tables.font = {
        -- increase font size
        { key = "=", action = IncreaseFontSize },
        -- decrease font size
        { key = "-", action = DecreaseFontSize },
        -- reset font size
        { key = "0", action = ResetFontSize },

        -- cycle backward font
        {
            key = "[",
            action = wezterm.action_callback(function(window)
                local state = util.load_json("state")
                local defaults = util.load_json("defaults")
                local options = util.load_json("options")

                local font_index = state.font
                if not font_index then
                    font_index = defaults.font
                    wezterm.emit("update-state", { font = defaults.font })
                end

                font_index = font_index - 1
                if font_index < 1 then
                    font_index = #options.font
                end

                wezterm.emit("update-state", { font = font_index })

                local overrides = window:get_config_overrides() or {}
                overrides.font = wezterm.font(options.font[font_index])
                window:set_config_overrides(overrides)
            end)
        },
        -- cycle forward font
        {
            key = "]",
            action = wezterm.action_callback(function(window)
                local state = util.load_json("state")
                local defaults = util.load_json("defaults")
                local options = util.load_json("options")

                local font_index = state.font
                if not font_index then
                    font_index = defaults.font
                    wezterm.emit("update-state", { font = font_index })
                end

                font_index = font_index + 1
                if font_index > #options.font then
                    font_index = 1
                end

                wezterm.emit("update-state", { font = font_index })

                local overrides = window:get_config_overrides() or {}
                overrides.font = wezterm.font(options.font[font_index])
                window:set_config_overrides(overrides)
            end)
        },
        -- reset font
        {
            key = "0",
            mods = "CTRL",
            action = wezterm.action_callback(function(window)
                local defaults = util.load_json("defaults")
                local options = util.load_json("options")
                
                wezterm.emit("update-state", { font = defaults.font })

                local overrides = window:get_config_overrides() or {}
                overrides.font = wezterm.font(options.font[defaults.font])
                window:set_config_overrides(overrides)
            end)
        },

        -- exit `font` key table
        { key = "Escape", action = PopKeyTable }
    }
end

function font.apply_to_config(config)
    keys.apply_to_config(config)
    key_tables.apply_to_config(config)
end

return font
