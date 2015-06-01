local public = {}

local function new()
    local debounceTimer = luajava.newInstance("timers.DebounceTimer")
    return debounceTimer
end

public.new = new

return public