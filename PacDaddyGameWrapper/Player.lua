require("PacDaddyGameWrapper/PactorCollisionFunction")
local Pactor = require("PacDaddyGameWrapper/Pactor")
local world = GAME:getWorld()

local public = {}

local function new()
    local player = Pactor:new()
    player:setAttribute("IS_PLAYER", true)
    player:setAttribute("TYPE", "PLAYER")
    
    local function onPactorCollision(otherPactorAttributes)
        if otherPactorAttributes:getValueOf("TYPE") == "ENEMY" then
            world:respawnAllPactors()
            local gameAttributes = GAME:getAttributes()
            gameAttributes:setAttribute("LIVES", gameAttributes:getValueOf("LIVES") - 1)
        end
    end
    
    player:setOnCollisionFunction(PactorCollisionFunction(onPactorCollision))
    return player
end

public.new = new

return public