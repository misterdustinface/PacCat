require("PacDaddyGameWrapper/PactorCollisionFunction")
require("PacDaddyGameWrapper/PactorCommon")
local Pactor = require("PacDaddyGameWrapper/Pactor")

local public = {}

local function new()
    local enemy = Pactor:new()
    enemy:setAttribute("IS_ENEMY", true)
    enemy:setAttribute("TYPE", "ENEMY")
    enemy:setAttribute("VALUE", 200)
    
    local oppositeDirectionTable = {
      ["UP"] = "DOWN",
      ["DOWN"] = "UP",
      ["LEFT"] = "RIGHT",
      ["RIGHT"] = "LEFT",
      ["NONE"] = "NONE",
    }
    
    local function onPactorCollision(otherPactorAttributes)
    
        if otherPactorAttributes:getValueOf("IS_PLAYER") then
        
            if enemy:getValueOf("IS_PICKUP") then
                CONSUME_PACTOR(enemy)
            else
                GAME:sendCommand("PAUSE")
                GAME:sendCommand("LIVES--")
                GAME:respawnAllPactors()
                GAME:sendCommand("PLAY")
            end
        
        end

    end
    
    enemy:setOnCollisionFunction(PactorCollisionFunction(onPactorCollision))
    return enemy
end

public.new = new

return public