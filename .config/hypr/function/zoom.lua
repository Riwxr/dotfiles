local STEP = 0.5

local function zoom(delta)
	local current = hl.get_config("cursor.zoom_factor")
	current = math.max(1, math.min(3, current + delta))

	hl.config({
		cursor = {
			zoom_factor = current,
		},
	})
end

hl.bind("SHIFT + CTRL + mouse_down", function()
	zoom(STEP)
	zoom(STEP)
end)

hl.bind("SHIFT + CTRL + mouse_up", function()
	zoom(-STEP)
	zoom(-STEP)
end)
