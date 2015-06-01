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
    local self = Pactor:new()
    self:setAttribute("IS_ENEMY", true)
    self:setAttribute("TYPE", "ENEMY")
    self:setAttribute("VALUE", ENEMY_VALUE)
    
    local oppositeDirectionTable = {
      ["UP"] = "DOWN",
      ["DOWN"] = "UP",
      ["LEFT"] = "RIGHT",
      ["RIGHT"] = "LEFT",
      ["NONE"] = "NONE",
    }
    
    local function onPactorCollision(otherPactorAttributes)
    
        if otherPactorAttributes:getValueOf("IS_PLAYER") then
        
            if self:getValueOf("IS_FRIGHTENED") then
                self:setAttribute("VALUE", ENEMY_VALUE)
                CONSUME_PACTOR(self)
                CALM(self)
                REVIVE_PACTOR(self)
                INCREASE_ENEMY_VALUE()
            else
                GAME:sendCommand("PAUSE")
                GAME:sendCommand("LIVES--")
                GAME:respawnAllPactors()
                GAME:sendCommand("PLAY")
            end
        
        end

    end
    
    self:setOnCollisionFunction(PactorCollisionFunction(onPactorCollision))
    
    table.insert(enemies, self)
    
    return self
end

public.new = new

return public