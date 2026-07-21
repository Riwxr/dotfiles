local utils = require("mp.utils")

mp.register_event("playback-restart", function()
	utils.subprocess({ args = { "playerctl", "-a", "pause" } })
end)
