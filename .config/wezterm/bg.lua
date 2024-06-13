local wezterm = require("wezterm")

local action = wezterm.action
local ActivateKeyTable = action.ActivateKeyTable
local PopKeyTable = action.PopKeyTable
local Nop = action.Nop

local bg = {}

local keys = {}
function keys.apply_to_config(config)
    util.insert_keys(config, {
        -- activate `background` key table with CTRL+b
        { key = "b", mods = "CTRL", action = ActivateKeyTable { name = "bg", one_shot = false } },
    })
end

local key_tables = {}
function key_tables.apply_to_config(config)
    config.key_tables.bg = {
        -- increment brightness
        -- should not deactivate key table
        {
            key = "=",
            action = wezterm.action_callback(function(window, pane)
                local state = util.load_json("state")
                local defaults = util.load_json("defaults")

                local window_background_image_hsb = state.window_background_image_hsb
                if not window_background_image_hsb then
                    window_background_image_hsb = defaults.window_background_image_hsb
                    wezterm.emit("update-state", { window_background_image_hsb = defaults.window_background_image_hsb })
                end

                window_background_image_hsb.brightness = window_background_image_hsb.brightness + 0.005
                if window_background_image_hsb.brightness > 2 then
                    window_background_image_hsb.brightness = 2
                end

                wezterm.emit("update-state", { window_background_image_hsb = window_background_image_hsb })

                local overrides = window:get_config_overrides() or {}
                overrides.window_background_image_hsb = window_background_image_hsb
                window:set_config_overrides(overrides)

                window:perform_action(ActivateKeyTable { name = "bg", one_shot = false }, pane)
            end)
        },
        -- decrement brightness
        -- should not deactivate key table
        {
            key = "-",
            action = wezterm.action_callback(function(window, pane)
                local state = util.load_json("state")
                local defaults = util.load_json("defaults")

                local window_background_image_hsb = state.window_background_image_hsb
                if not window_background_image_hsb then
                    window_background_image_hsb = defaults.window_background_image_hsb
                    wezterm.emit("update-state", { window_background_image_hsb = defaults.window_background_image_hsb })
                end

                window_background_image_hsb.brightness = window_background_image_hsb.brightness - 0.005
                if window_background_image_hsb.brightness < 0 then
                    window_background_image_hsb.brightness = 0
                end

                wezterm.emit("update-state", { window_background_image_hsb = window_background_image_hsb })

                local overrides = window:get_config_overrides() or {}
                overrides.window_background_image_hsb = window_background_image_hsb
                window:set_config_overrides(overrides)

                window:perform_action(ActivateKeyTable { name = "bg", one_shot = false }, pane)
            end)
        },

        -- increment window opacity
        -- should not deactivate key table
        {
            key = "=",
            mods = "CTRL",
            action = wezterm.action_callback(function(window, pane)
                local state = util.load_json("state")
                local defaults = util.load_json("defaults")

                local window_background_opacity = state.window_background_opacity
                if not window_background_opacity then
                    window_background_opacity = defaults.window_background_opacity
                    wezterm.emit("update-state", { window_background_opacity = defaults.window_background_opacity })
                end

                window_background_opacity = window_background_opacity + 0.05
                if window_background_opacity > 1 then
                    window_background_opacity = 1
                end

                wezterm.emit("update-state", { window_background_opacity = window_background_opacity })

                local overrides = window:get_config_overrides() or {}
                overrides.window_background_opacity = window_background_opacity
                window:set_config_overrides(overrides)

                window:perform_action(ActivateKeyTable { name = "bg", one_shot = false }, pane)
            end)
        },
        -- decrement window opacity
        -- should not deactivate key table
        {
            key = "-",
            mods = "CTRL",
            action = wezterm.action_callback(function(window, pane)
                local state = util.load_json("state")
                local defaults = util.load_json("defaults")

                local window_background_opacity = state.window_background_opacity
                if not window_background_opacity then
                    window_background_opacity = defaults.window_background_opacity
                    wezterm.emit("update-state", { window_background_opacity = defaults.window_background_opacity })
                end

                window_background_opacity = window_background_opacity - 0.05
                if window_background_opacity < 0 then
                    window_background_opacity = 0
                end

                wezterm.emit("update-state", { window_background_opacity = window_background_opacity })

                local overrides = window:get_config_overrides() or {}
                overrides.window_background_opacity = window_background_opacity
                window:set_config_overrides(overrides)

                window:perform_action(ActivateKeyTable { name = "bg", one_shot = false }, pane)
            end)
        },

        -- reset brightness and window opacity
        {
            key = "0",
            action = wezterm.action_callback(function(window)
                local defaults = util.load_json("defaults")

                wezterm.emit("update-state", { window_background_image_hsb = defaults.window_background_image_hsb })
                wezterm.emit("update-state", { window_background_opacity = defaults.window_background_opacity })

                local overrides = window:get_config_overrides() or {}
                overrides.window_background_image_hsb = defaults.window_background_image_hsb
                overrides.window_background_opacity = defaults.window_background_opacity
                window:set_config_overrides(overrides)
            end)
        },
	
        -- toggle background image
        { key = "b", action = Nop },
        -- cycle backward background image
        {
            key = "[",
            action = wezterm.action_callback(function(window, pane)
                local state = util.load_json("state")
                local defaults = util.load_json("defaults")

                local window_background_image = state.window_background_image
                if not window_background_image then
                    window_background_image = defaults.window_background_image
                    wezterm.emit("update-state", { window_background_image = defaults.window_background_image })
                end

                local dir = wezterm.home_dir .. "/.wallpapers/"

                local bgs = {}
                local count = 0

                local out = io.popen("ls " .. dir)
                for bg in out:lines() do
                    table.insert(bgs, bg)
                    count = count + 1
                end
                out:close()

                for i, bg in ipairs(bgs) do
                    if dir .. bg == state.window_background_image then
                        i = i - 1
                        if i < 1 then
                            i = count
                        end
                        window_background_image = dir .. bgs[i]
                        break
                    end
                end

                wezterm.emit("update-state", { window_background_image = window_background_image })

                local overrides = window:get_config_overrides() or {}
                overrides.window_background_image = window_background_image
                window:set_config_overrides(overrides)

                window:perform_action(ActivateKeyTable { name = "bg", one_shot = false }, pane)
            end)
        },
        -- cycle forward background image
        {
            key = "]",
            action = wezterm.action_callback(function(window, pane)
                local state = util.load_json("state")
                local defaults = util.load_json("defaults")

                local window_background_image = state.window_background_image
                if not window_background_image then
                    window_background_image = defaults.window_background_image
                    wezterm.emit("update-state", { window_background_image = defaults.window_background_image })
                end

                local dir = wezterm.home_dir .. "/.wallpapers/"

                local bgs = {}
                local count = 0

                local out = io.popen("ls " .. dir)
                for bg in out:lines() do
                    table.insert(bgs, bg)
                    count = count + 1
                end
                out:close()

                for i, bg in ipairs(bgs) do
                    if dir .. bg == state.window_background_image then
                        i = i + 1
                        if i > count then
                            i = 1
                        end
                        window_background_image = dir .. bgs[i]
                        break
                    end
                end

                wezterm.emit("update-state", { window_background_image = window_background_image })

                local overrides = window:get_config_overrides() or {}
                overrides.window_background_image = window_background_image
                window:set_config_overrides(overrides)

                window:perform_action(ActivateKeyTable { name = "bg", one_shot = false }, pane)
            end)
        },

        -- cycle backward color scheme
        {
            key = "[",
            mods = "CTRL",
            action = wezterm.action_callback(function(window, pane)
                local state = util.load_json("state")
                local defaults = util.load_json("defaults")
                local options = util.load_json("options")

                local color_scheme = state.color_scheme
                if not color_scheme then
                    color_scheme = defaults.color_scheme
                    wezterm.emit("update-state", { font = defaults.font })
                end

                color_scheme = color_scheme - 1
                if color_scheme < 1 then
                    color_scheme = #options.color_scheme
                end

                wezterm.emit("update-state", { color_scheme = color_scheme })

                local overrides = window:get_config_overrides() or {}
                overrides.color_scheme = options.color_scheme[color_scheme]
                window:set_config_overrides(overrides)

                window:perform_action(ActivateKeyTable { name = "bg", one_shot = false }, pane)
            end)
        },
        -- cycle forward color scheme
        {
            key = "]",
            mods = "CTRL",
            action = wezterm.action_callback(function(window, pane)
                local state = util.load_json("state")
                local defaults = util.load_json("defaults")
                local options = util.load_json("options")

                local color_scheme = state.color_scheme
                if not color_scheme then
                    color_scheme = defaults.color_scheme
                    wezterm.emit("update-state", { font = defaults.font })
                end

                color_scheme = color_scheme + 1
                if color_scheme > #options.color_scheme then
                    color_scheme = 1
                end

                wezterm.emit("update-state", { color_scheme = color_scheme })

                local overrides = window:get_config_overrides() or {}
                overrides.color_scheme = options.color_scheme[color_scheme]
                window:set_config_overrides(overrides)
                
                window:perform_action(ActivateKeyTable { name = "bg", one_shot = false }, pane)
            end)
        },

        -- reset background image and color scheme
        {
            key = "0",
            mods = "CTRL",
            action = wezterm.action_callback(function(window)
                local defaults = util.load_json("defaults")
                local options = util.load_json("options")

                wezterm.emit("update-state", { window_background_image = defaults.window_background_image })
                wezterm.emit("update-state", { color_scheme = defaults.color_scheme })

                local overrides = window:get_config_overrides() or {}
                overrides.window_background_image = defaults.window_background_image
                overrides.color_scheme = options.color_scheme[defaults.color_scheme]
                window:set_config_overrides(overrides)
            end)
        },

        -- exit `background` key table
        { key = "Escape", action = PopKeyTable }
    }
end

function bg.apply_to_config(config)
    keys.apply_to_config(config)
    key_tables.apply_to_config(config)
end

return bg

