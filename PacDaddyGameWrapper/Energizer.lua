require("PacDaddyGameWrapper/PactorCollisionFunction")
require("PacDaddyGameWrapper/PactorCommon")
local Pactor = require("PacDaddyGameWrapper/Pactor")

local public = {}

local function new()
    local pickup = Pactor:new()
    pickup:setAttribute("IS_PICKUP",    true)
    pickup:setAttribute("IS_ENERGIZER", true)
    pickup:setAttribute("TYPE", "ENERGIZER")
    pickup:setAttribute("VALUE", 50)

    local function onPactorCollision(otherPactorAttributes)
        if otherPactorAttributes:getValueOf("IS_PLAYER") then
            CONSUME_PACTOR(pickup)
            otherPactorAttributes:setAttribute("IS_ENERGIZED", true)
        end
    end
    
    pickup:setOnCollisionFunction(PactorCollisionFunction(onPactorCollision))
    return pickup
end

public.new = new

return public