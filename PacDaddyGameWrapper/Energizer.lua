require("PacDaddyGameWrapper/PactorCollisionFunction")
require("PacDaddyGameWrapper/PactorCommon")
local Pellet = require("PacDaddyGameWrapper/Pellet")

local public = {}

local function new()
    local pellet = Pellet:new()
    pellet:setAttribute("IS_ENERGIZER", true)
    pellet:setAttribute("TYPE", "ENERGIZER")
    pellet:setAttribute("VALUE", 50)

    local function onPactorCollision(otherPactorAttributes)
        if otherPactorAttributes:getValueOf("IS_PLAYER") then
            local player = otherPactorAttributes
            DESTROY_AND_CONSUME_PACTOR(pellet)
            PLAYER_ENERGIZE(player)
        end
    end
    
    pellet:setOnCollisionFunction(PactorCollisionFunction(onPactorCollision))
    return pellet
end

public.new = new

return public