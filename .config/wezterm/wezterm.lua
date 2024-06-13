-- https://github.com/wez/wezterm/issues/5318
-- https://github.com/wez/wezterm/issues/5240

-- TODO: resolve bugs when wezterm issues fixed
-- TODO: remove full file path from json files
-- NOTE: I'm eventually gonna change the keybinds on this to match the default(ish) i3/sway keybindings for consistency
-- NOTE: I'm also probably gonna switch to kitty, because there seems to be input and render latency using wezterm

local wezterm = require("wezterm")
local util = require("util")
local config = wezterm.config_builder()

local state = util.load_json("state")
local options = util.load_json("options")

-- color scheme and background
config.window_background_image = state.window_background_image
config.color_scheme = options.color_scheme[state.color_scheme]
config.window_background_image_hsb = state.window_background_image_hsb

-- font
config.font = wezterm.font(options.font[state.font])
config.font_size = 20
config.underline_position = "-3pt"
config.underline_thickness = "3pt"
config.cursor_thickness = "2pt"
-- https://wezfurlong.org/wezterm/faq.html?h=underline#how-do-i-enable-undercurl-curly-underlines

-- tab bar
config.use_fancy_tab_bar = false

-- window decorations
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.max_fps = 120
config.animation_fps = 60
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.adjust_window_size_when_changing_font_size = false
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
	if gpu.device_type == "DiscreteGpu" and gpu.backend == "Vulkan" then
		config.webgpu_preferred_adapter = gpu
	end
end

-- key bindings
local events = require("events")
local panes = require("panes")
local tabs = require("tabs")
local bg = require("bg")
local font = require("font")
local std = require("std")

config.disable_default_key_bindings = true
config.leader = { key = "Control" } -- leader not working
config.keys = {}
config.key_tables = {}

events.apply_to_config(config)
panes.apply_to_config(config)
tabs.apply_to_config(config)
bg.apply_to_config(config)
font.apply_to_config(config)
std.apply_to_config(config)

return config

