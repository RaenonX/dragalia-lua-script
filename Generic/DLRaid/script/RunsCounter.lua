Logger = dofile(scriptPath() .. "script/Logger.lua")

local m = {}

m.counter_runs = 0

	m.counter_runs = m.counter_runs + 1
	Logger.writeLog(string.format("Battle #%d Started at %s\n", m.counter_runs, os.date("%c")))
end

m.count_once = count_once

return m