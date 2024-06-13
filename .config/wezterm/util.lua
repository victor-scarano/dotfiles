local wezterm = require("wezterm")

util = {}

function util.expand_relative_path(path)
    return wezterm.home_dir .. "/.config/wezterm/" .. path
end

function util.insert_keys(config, keys)
    for _, key in ipairs(keys) do
        table.insert(config.keys, key)
    end
end

function util.load_json(file)
    local file = io.open(util.expand_relative_path(file .. ".json"), "r")
    local data = file:read("*a")
    data = wezterm.json_parse(data)
    file:close()
    return data
end

return util

