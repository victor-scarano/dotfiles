local wezterm = require("wezterm")

local events = {}

function events.apply_to_config(config)
    -- updates the right status to show the current active key table
    wezterm.on('update-right-status', function(window)
        local name = window:active_key_table()
        if name then name = "Current key table: " .. name end
        window:set_right_status(name or "")
    end)
    
    -- updates the state.json file to reflect the user's current config state
    wezterm.on("update-state", function(data)
        local state = util.load_json("state")

        local key, value = next(data)
        state[key] = value

        local file = io.open(util.expand_relative_path("state.json"), "w")
        file:write(wezterm.json_encode(state))
        file:close()
    end)
end

return events

