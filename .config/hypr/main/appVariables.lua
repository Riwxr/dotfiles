-- main/appVariables.lua
return {
	terminal1 = "foot",
	terminal2 = "kitty",
	terminal3 = "alacritty",
	fileManager = "thunar",
	clipboard1 = "copyq show && hyprctl dispatch movecursor 1749 900",
	clipboard2 = "walker -m clipboard",
	menu1 = "walker -H",
	menu2 = "~/scripts/rofi_toggle.sh",
	menu3 = "foot --app-id foot-otter otter-launcher",
	browser1 = {
		class = "zen",
		cmd = "zen-browser",
	},
	browser2 = {
		class = "one.ablaze.floorp",
		cmd = "floorp",
	},
	browser3 = {
		class = "firefox",
		cmd = "firefox",
	},
	browser4 = {
		cmd = "brave",
		class = "brave-browser",
	},
	lutris = {
		class = "net.lutris.Lutris",
		cmd = "lutris",
	},
	blueman = {
		class = "blueman-manager",
		cmd = "blueman-manager",
	},
	zapzap = {
		class = "com.rtosta.zapzap",
		cmd = "zapzap",
	},
	fdm = {
		class = "fdm",
		cmd = "fdm",
	},
	pavucontrol = {
		class = "org.pulseaudio.pavucontrol",
		cmd = "pavucontrol",
	},
}
