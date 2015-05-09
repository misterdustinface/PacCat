local public = {}

local function new()
    local pactor = luajava.newInstance("Engine.Pactor")
    return pactor
end

public.new = new

return public

