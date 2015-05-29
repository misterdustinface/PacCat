require("PacDaddyGameWrapper/PactorCollisionFunction")
local Pactor = require("PacDaddyGameWrapper/Pactor")
local world = GAME:getWorld()

local public = {}

local function new()
    local player = Pactor:new()
    player:setAttribute("IS_PLAYER", true)
    player:setAttribute("TYPE", "PLAYER")
    
    local function onPactorCollision(otherPactorAttributes)

    end
    
    player:setOnCollisionFunction(PactorCollisionFunction(onPactorCollision))
    return player
end

public.new = new

return public