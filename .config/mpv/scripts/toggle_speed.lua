local mp = require("mp")
local last_speed = 1.0

mp.add_key_binding("KP_MULTIPLY", "toggle-speed", function()
	local cur = mp.get_property_number("speed", 1.0)
	if cur ~= 2.0 then
		last_speed = cur
		mp.set_property_number("speed", 2.0)
		mp.osd_message("Speed: 2.0x")
	else
		mp.set_property_number("speed", last_speed)
		mp.osd_message("Speed: " .. last_speed .. "x")
	end
end)
mp.add_key_binding("`", "reset-speed-1x", function()
	local cur = mp.get_property_number("speed", 1.0)
	if cur ~= 1.0 then
		last_speed = cur
		mp.set_property_number("speed", 1.0)
		mp.osd_message("Speed: 1.0x")
	else
		mp.set_property_number("speed", last_speed)
		mp.osd_message("Speed: " .. last_speed .. "x")
	end
end)
