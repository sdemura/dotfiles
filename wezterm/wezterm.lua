-- Pull in the wezterm API
local wezterm = require("wezterm")

-- update left status with zoom indicator
wezterm.on("update-status", function(window, pane)
	local our_tab = pane:tab()
	local is_zoomed = false
	if our_tab ~= nil then
		for _, pane_attributes in pairs(our_tab:panes_with_info()) do
			is_zoomed = pane_attributes["is_zoomed"] or is_zoomed
		end
	end
	if is_zoomed then
		window:set_left_status(wezterm.format({
			{ Attribute = { Underline = "Single" } },
			{ Background = { Color = "#254147" } },
			{ Foreground = { Color = "#ebebeb" } },
			{ Text = "-- ZOOMED --" },
		}))
		-- the below assumes you have written a handler that forces tabs to be open
		-- I do this aggressively to force my UI to remind me that I am zoomed
		wezterm.emit("force-tabs-shown", window, pane)
	else
		window:set_left_status("")
	end

	--- whatever else you want to do with your update-status
end)

-- update right status when leader pressed
wezterm.on("update-right-status", function(window, pane)
	local leader = ""
	if window:leader_is_active() then
		leader = "-- LEADER --"
	end
	window:set_right_status(leader)
end)

local TAB_BAR_BACKGROUND = "#254147"

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- performance
config.front_end = "WebGpu"
config.window_close_confirmation = "NeverPrompt"

-- Appearance
config.color_scheme = "terafox"
config.default_cursor_style = "BlinkingBlock"
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 25

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 11
config.window_frame = {
	font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Bold" }),
	font_size = 12,
}

-- only for fancy
config.window_frame = {
	font = wezterm.font({ family = "JetBrainsMono", weight = "Bold" }),
	inactive_titlebar_bg = "#254147",
	active_titlebar_bg = "#254147",
}

config.colors = {
	-- change the cursor color when a dead key or leader key is active
	-- doesn't seem to actually work...
	-- compose_cursor = "#fdb292",
	compose_cursor = "orange",
	tab_bar = {
		-- applicable for fancy
		inactive_tab_edge = "#254147",
		-- only works for retry
		background = "#254147",
		active_tab = {
			bg_color = TAB_BAR_BACKGROUND,
			fg_color = "#fdb292",
			intensity = "Bold",
			underline = "None",
		},
		inactive_tab = {
			bg_color = TAB_BAR_BACKGROUND,
			fg_color = "#7aa4a1",
			intensity = "Half",
		},
		new_tab = {
			bg_color = TAB_BAR_BACKGROUND,
			fg_color = "#7aa4a1",
		},
		new_tab_hover = {
			bg_color = TAB_BAR_BACKGROUND,
			fg_color = "#fdb292",
			italic = false,
		},
		inactive_tab_hover = {
			bg_color = TAB_BAR_BACKGROUND,
			fg_color = "#ebebeb",
			italic = false,
		},
	},
}
config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}

-- leader key like tmux
-- config.disable_default_key_bindings = true
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
	-- Make Option-Right equivalent to Alt-f; forward-word
	{ key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },

	-- start tmux emulation mode
	-- { key = "b", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
	{ key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "\\", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "s", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "v", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
	{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
	{ key = "&", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
	{ key = "d", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
	{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },

	-- rename tabs
	{
		key = ",",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- pane select
	{ key = " ", mods = "LEADER", action = wezterm.action.PaneSelect({ alphabet = "1234567890" }) },

	-- close all but current pane
	{
		key = "O",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			local tab = win:active_tab()
			for _, p in ipairs(tab:panes()) do
				if p:pane_id() ~= pane:pane_id() then
					p:activate()
					win:perform_action(wezterm.action.CloseCurrentPane({ confirm = false }), p)
				end
			end
		end),
	},
	-- end tmux emulation mode
}

-- and finally, return the configuration to wezterm
return config
