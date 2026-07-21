-- main/keybindsApps.lua
local x = require("main.appVariables")
local single = require("function.singleInstance")
local kill = require("function.selectiveClientKill")
-- SUPER SHIFT CTRL ALT --for autocomplete of modfierkeys

--terminals
hl.bind("SUPER + Q", hl.dsp.exec_cmd(x.terminal1))
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd(x.terminal2))
hl.bind("SUPER + ALT + Q", hl.dsp.exec_cmd(x.terminal3))
--browsers
hl.bind("SUPER + B", single.Instance(x.browser1))
hl.bind("SUPER + SHIFT + B", single.Instance(x.browser2))
hl.bind("SUPER + ALT + B", single.Instance(x.browser3))
hl.bind("SUPER + CTRL + B", single.Instance(x.browser4))
--apps-single
hl.bind("SUPER + G", single.Instance(x.lutris))
hl.bind("SUPER + SHIFT + D", single.Instance(x.fdm))
hl.bind("SUPER + SHIFT + W", single.Instance(x.zapzap))
hl.bind("SUPER + SHIFT + A", single.Instance(x.blueman))
hl.bind("SUPER + SHIFT + N", single.Instance(x.pavucontrol))
--apps
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
--menus
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(x.menu1))
hl.bind("SUPER + ALT + SPACE", hl.dsp.exec_cmd(x.menu2))
hl.bind("SUPER + SHIFT + SPACE", hl.dsp.exec_cmd(x.menu3))
--clipboards
hl.bind("SUPER + V", hl.dsp.exec_cmd(x.clipboard1))
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd(x.clipboard2))
--killClient
hl.bind("SUPER + SHIFT + C", hl.dsp.window.close())
hl.bind("SUPER + C", kill.Client())
--filemanager
hl.bind("SUPER + S", hl.dsp.exec_cmd(x.fileManager))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("foot yazi"))
--scripts
hl.bind("SUPER + R", hl.dsp.exec_cmd("wtype e"))
hl.bind("SHIFT + KP_Multiply", hl.dsp.exec_cmd("toggle-laptop-kbd.sh"))
hl.bind("SUPER + P", hl.dsp.exec_cmd("~/scripts/rotatescreen.sh"))
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("~/scripts/ocr.sh"))
hl.bind("SUPER + K", hl.dsp.exec_cmd("~/scripts/squeekboard.sh"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("~/scripts/tts-edge.sh"))
hl.bind("SUPER + X", hl.dsp.exec_cmd("foot nvim"))
hl.bind("ALT + GRAVE", hl.dsp.exec_cmd("pkill rofi & ~/.config/rofi/powermenu/powermenu.sh"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("~/scripts/rofi-wifi-menu/rofi-wifi-menu.sh"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("~/scripts/toss.sh"))
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(
	"SHIFT + PRINT",
	hl.dsp.exec_cmd(
		"grim -s 4 -t ppm - | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d_%H%M%S').png"
	)
)
hl.bind("PRINT", hl.dsp.exec_cmd("flameshot gui"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("~/scripts/define.sh"))
-- hl.bind("SUPER + ", hl.dsp.exec_cmd(""))
