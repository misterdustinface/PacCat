require("PacDaddyGameWrapper/PactorCollisionFunction")
local Pactor = require("PacDaddyGameWrapper/Pactor")
local world = GAME:getWorld()

local public = {}

local function new()
    local self = Pactor:new()
    self:setAttribute("IS_PLAYER", true)
    self:setAttribute("TYPE", "PLAYER")
    
    local function onPactorCollision(otherPactorAttributes)

    end
    
    self:setOnCollisionFunction(PactorCollisionFunction(onPactorCollision))
    return self
end

public.new = new

return public