local public = {}

local function new()
    local pactorController = luajava.newInstance("Engine.PactorController")
    return pactorController
end

public.new = new

return public