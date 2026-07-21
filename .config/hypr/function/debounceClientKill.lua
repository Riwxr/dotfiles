-- function/debounceClientKill.lua

local class_list = {
	["org.pulseaudio.pavucontrol"] = true,
	["blueman-manager"] = true,
}

local kill_timers = {}
local last_active = nil

local function start_kill_timer(win)
	local address = win.address

	if kill_timers[address] then
		kill_timers[address]:set_enabled(false)
	end

	kill_timers[address] = hl.timer(function()
		kill_timers[address] = nil

		local ok, err = pcall(function()
			hl.dispatch(hl.dsp.window.close({
				window = "address:" .. address,
			}))
		end)

		if not ok then
			-- window's already gone, nothing to do
		end
	end, {
		timeout = 900,
		type = "oneshot",
	})
end

hl.on("window.active", function(active)
	if not active then
		return
	end

	if last_active and class_list[last_active.class] then
		start_kill_timer(last_active)
	end

	if class_list[active.class] then
		local address = active.address

		if kill_timers[address] then
			kill_timers[address]:set_enabled(false)
			kill_timers[address] = nil
		end
	end

	last_active = active
end)
