-- function/singleInstance.lua

local M = {}

function M.Instance(app)
	local launching = false

	return function()
		for _, win in ipairs(hl.get_windows()) do
			if win.class == app.class then
				return hl.dispatch(hl.dsp.focus({ window = win }))
			end
		end
		if launching then
			hl.dispatch(hl.dsp.exec_cmd("notify-send 'locked'"))
			return
		end

		launching = true

		hl.dispatch(hl.dsp.exec_cmd(app.cmd))

		hl.timer(function()
			launching = false
		end, {
			timeout = 2000,
			type = "oneshot",
		})
	end
end

return M
