-- https://github.com/wez/wezterm/issues/5318
-- https://github.com/wez/wezterm/issues/5240

local wezterm = require("wezterm")
local util = require("util")
local config = wezterm.config_builder()

-- color scheme and background
config.color_scheme = "Catppuccin Mocha" -- or Tokyo Night
config.window_background_image_hsb = { brightness = 0.1 }
local state = util.load_json("state")
if state then config.window_background_image = state.window_background_image end

-- font
config.font = wezterm.font("Hack")
config.font_size = 18

-- tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- window decorations
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_decorations = "RESIZE"
config.max_fps = 60
config.adjust_window_size_when_changing_font_size = false

-- key bindings
local events = require("events")
local panes = require("panes") -- this is done lmao, dont touch it 
local tabs = require("tabs")
local bg = require("bg")
local font = require("font")
local std = require("std")

config.disable_default_key_bindings = true
config.leader = { key = "Control" } -- figure out why leader doesnt work
config.keys = {}
config.key_tables = {}

events.apply_to_config(config)
panes.apply_to_config(config)
tabs.apply_to_config(config)
bg.apply_to_config(config)
font.apply_to_config(config)
std.apply_to_config(config)

return config
