States = dofile(scriptPath() .. "script/State.lua")
Configs = dofile(scriptPath() .. "script/Configs.lua")
Counter = dofile(scriptPath() .. "script/RunsCounter.lua")

local m = {}

begin_t = Timer()

-- Update Stop Message

	setStopMessage(string.format("Elapsed Time: %.3f s (%d runs)\nState: %s\nPrevious State: %s", 
								 begin_t:check(), Counter.counter_runs, States.current_state, States.previous_state))
end

-- Terminate

	vibrate(0.5)
	updateStopMessage()
	scriptExit(message)
end

-- Generate Toast

last_toast = Timer()
	updateStopMessage()
	if Configs.ToastEnable and last_toast:check() > Configs.ToastCooldownSeconds then
		toast(string.format("%.3f s @ %s", begin_t:check(), States.current_state))
		last_toast:set()
	end
end

-- Infinite State Check Preventer

unknown_state_count = 0
	if States.current_state == UNKNOWN then
		unknown_state_count = unknown_state_count + 1
		
		if unknown_state_count >= Configs.MaxStateChecksOnUnknown then
			terminate(string.format("State determination failed. (%s)", States.current_state))
		end
	else
		unknown_state_count = 0
	end
end

-- Loading State De-Stucker

loading_timer = nil
local function activate_loading_destucker()
	if loading_timer == nil then
		loading_timer = Timer()
	end
end

local function loading_stucker_overtime()
	if loading_timer ~= nil and loading_timer:check() > Configs.MaxLoadingStuckSeconds then
		States.update_state(States.UNKNOWN)
		loading_timer = nil
		return true
	else
		return false
	end
end

local function deactivate_loading_destucker()
	loading_timer = nil
end

m.updateStopMessage = updateStopMessage
m.terminate = terminate
m.generate_toast = generate_toast
m.count_analyze_state = count_analyze_state
m.activate_loading_destucker = activate_loading_destucker
m.loading_stucker_overtime = loading_stucker_overtime
m.deactivate_loading_destucker = deactivate_loading_destucker

return m