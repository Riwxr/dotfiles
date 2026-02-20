local utils = require("mp.utils")
local msg = require("mp.msg")

local logfile = os.getenv("HOME") .. "/.cache/mpv-history.log"

local function log_current_file()
	local path = mp.get_property("path")
	if not path then
		return
	end

	local title = mp.get_property("media-title") or "Unknown Title"
	local duration = mp.get_property_number("duration", 0)

	-- Format duration as HH:MM:SS
	local function format_time(sec)
		if not sec then
			return "00:00:00"
		end
		sec = math.floor(sec)
		local h = math.floor(sec / 3600)
		local m = math.floor((sec % 3600) / 60)
		local s = sec % 60
		return string.format("%02d:%02d:%02d", h, m, s)
	end

	local length = format_time(duration)

	-- Date from system
	local date = os.date("%Y-%m-%d %H:%M:%S")

	local line = string.format("[%s] | %s | %s | %s\n", date, title, path, length)

	local file = io.open(logfile, "a")
	if file then
		file:write(line)
		file:close()
	else
		msg.error("Could not open history log file")
	end
end

-- Log when playback starts
mp.register_event("file-loaded", log_current_file)

-- Optional: keybinding to manually log
mp.add_key_binding("Ctrl+h", "log-history", log_current_file)
