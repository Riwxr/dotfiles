-- main/windowRules.lua

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	name = "Browsers",
	match = {
		class = "zen",
	},
	workspace = 2,
})
hl.window_rule({
	name = "Browsers-sfw",
	match = {
		class = "firefox|brave-browser",
	},
	workspace = 1,
})
hl.window_rule({
	name = "Browsers-nsfw",
	match = {
		class = "microsoft-edge|one.ablaze.floorp",
	},
	workspace = 3,
})
hl.window_rule({
	name = "Games",
	match = {
		class = "net.lutris.Lutris|org-tlauncher-tlauncher-rmo-TLauncher|by-gdev-Main|steam_app_default|sekiro.exe",
		title = "Minecraft|Lutris|sekiro.exe",
	},
	workspace = 4,
})
hl.window_rule({
	name = "fullscreenGamescope",
	match = {
		class = "gamescope",
	},
	float = true,
	size = { "monitor_w + 2", "monitor_h + 2" },
	move = { -1, -1 },
	border_size = 0,
})

hl.window_rule({
	name = "screenchot",
	match = {
		class = "com.gabm.satty",
	},
	animation = "screenshotPop",
	float = true,
	size = { "monitor_w", "monitor_h" },
	move = { 0, 0 },
	pin = true,
	border_size = 0,
})

hl.window_rule({
	name = "clipboard",
	match = {
		class = "com.github.hluk.copyq",
	},
	float = true,
	size = { 700, 800 },
	move = { "monitor_w-702", "monitor_h - 802" },
	pin = true,
})
hl.window_rule({
	name = "volumecontrol",
	match = {
		class = "org.pulseaudio.pavucontrol",
	},
	float = true,
	size = { 534, 759 },
	move = { 16, 16 },
	pin = true,
})
hl.window_rule({
	name = "blueman",
	match = {
		class = "blueman-manager",
	},
	float = true,
	size = { 1147, 676 },
	move = { 8, 10 },
	pin = true,
})
