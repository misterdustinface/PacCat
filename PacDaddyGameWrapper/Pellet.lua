require("PacDaddyGameWrapper/PactorCollisionFunction")
require("PacDaddyGameWrapper/PactorCommon")
local Pactor = require("PacDaddyGameWrapper/Pactor")

local public = {}

local function new()
    local pickup = Pactor:new()
    pickup:setAttribute("IS_PICKUP", true)
    pickup:setAttribute("TYPE", "PELLET")
    pickup:setAttribute("VALUE", 1)
    
    local function onPactorCollision(otherPactorAttributes)
        if otherPactorAttributes:getValueOf("IS_PLAYER") then
            DESTROY_AND_CONSUME_PACTOR(pickup)
        end
    end
    
    pickup:setOnCollisionFunction(PactorCollisionFunction(onPactorCollision))
    return pickup
end

public.new = new

return public