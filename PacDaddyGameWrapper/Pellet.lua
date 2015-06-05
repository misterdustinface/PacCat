require("PacDaddyGameWrapper/PactorCollisionFunction")
require("PacDaddyGameWrapper/PactorCommon")
local Pactor = require("PacDaddyGameWrapper/Pactor")

local public = {}

local function new()
    local self = Pactor:new()
    self:setAttribute("IS_PICKUP", true)
    self:setAttribute("TYPE", "PELLET")
    self:setAttribute("VALUE", 10)
    self:setAttribute("SPEED__PCT", 0.0)
    
    local function onPactorCollision(otherPactorAttributes)
        if otherPactorAttributes:getValueOf("IS_PLAYER") then
            DESTROY_AND_CONSUME_PACTOR(self)
        end
    end
    
    self:setOnCollisionFunction(PactorCollisionFunction(onPactorCollision))
    return self
end

public.new = new

return public