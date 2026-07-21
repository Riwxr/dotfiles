-- function/selectiveClientKill.lua

local N = {}
local nl = "\n"
local app = {
	-- foot = true,
	zen = true,
	firefox = true,
	["brave-browser"] = true,
	["one.ablaze.floorp"] = true,
}

function N.Client()
	return function()
		if hl.get_active_window() then
			local class = hl.get_active_window().class
		else
			return
		end

		if app[class] then
			hl.dispatch(
				hl.dsp.exec_cmd("notify-send ' Watchdog - " .. hl.get_active_window().class .. nl .. "' 'Nope'")
			)
		else
			hl.dispatch(hl.dsp.window.close())
		end
	end
end

return N
