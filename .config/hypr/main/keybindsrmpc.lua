-- main/keybindsGeneral.lua

hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + J", hl.dsp.layout("togglesplit")) -- dwindle only
-- Move focus with mainMod + arrow keys
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness

local volDown = hl.dsp.exec_cmd("swayosd-client --output-volume lower")
local volUp = hl.dsp.exec_cmd("swayosd-client --output-volume raise")
local lightUp = hl.dsp.exec_cmd("swayosd-client --brightness raise")
local lightDown = hl.dsp.exec_cmd("swayosd-client --brightness lower")
local mute = hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle")
local micMute = hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle")

hl.bind("XF86AudioRaiseVolume", volUp, { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", volDown, { locked = true, repeating = true })

hl.bind("SUPER + XF86MonBrightnessUp", volUp, { locked = true, repeating = true })
hl.bind("SUPER + XF86MonBrightnessDown", volDown, { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp", lightUp, { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", lightDown, { locked = true, repeating = true })

hl.bind("XF86AudioMute", mute, { locked = true, repeating = true })
hl.bind("SHIFT + XF86AudioMute", micMute, { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
