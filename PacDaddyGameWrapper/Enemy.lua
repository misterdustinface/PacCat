require("PacDaddyGameWrapper/PactorCollisionFunction")
require("PacDaddyGameWrapper/PactorCommon")
local Pactor = require("PacDaddyGameWrapper/Pactor")

local public = {}

local enemies = {}

local ENEMY_VALUE = 200

local function SET_ENEMY_VALUE_TO_DEFAULT()
    ENEMY_VALUE = 200
end

local function INCREASE_ENEMY_VALUE()
    ENEMY_VALUE = ENEMY_VALUE * 2
end

local function new()
    local enemy = Pactor:new()
    enemy:setAttribute("IS_ENEMY", true)
    enemy:setAttribute("TYPE", "ENEMY")
    enemy:setAttribute("VALUE", ENEMY_VALUE)
    
    local oppositeDirectionTable = {
      ["UP"] = "DOWN",
      ["DOWN"] = "UP",
      ["LEFT"] = "RIGHT",
      ["RIGHT"] = "LEFT",
      ["NONE"] = "NONE",
    }
    
    local function onPactorCollision(otherPactorAttributes)
    
        if otherPactorAttributes:getValueOf("IS_PLAYER") then
        
            if enemy:getValueOf("IS_FRIGHTENED") then
                enemy:setAttribute("VALUE", ENEMY_VALUE)
                CONSUME_PACTOR(enemy)
                CALM(enemy)
                REVIVE_PACTOR(enemy)
                INCREASE_ENEMY_VALUE()
            else
                GAME:sendCommand("PAUSE")
                GAME:sendCommand("LIVES--")
                GAME:respawnAllPactors()
                GAME:sendCommand("PLAY")
            end
        
        end

    end
    
    enemy:setOnCollisionFunction(PactorCollisionFunction(onPactorCollision))
    
    table.insert(enemies, enemy)
    
    return enemy
end

public.new = new

return public