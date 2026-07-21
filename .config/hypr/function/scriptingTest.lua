-- function/scriptingTest.lua

hl.on("window.open", function(w)
	if w.class:match("foot") then
		-- hl.dispatch(hl.dsp.exec_cmd("notify-send 'it works'"))
	end
end)
