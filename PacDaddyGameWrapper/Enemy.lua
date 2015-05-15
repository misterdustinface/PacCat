require("PacDaddyGameWrapper/PactorCollisionFunction")
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
        -- TODO
    end
    
    enemy:setOnCollisionFunction(PactorCollisionFunction(onPactorCollision))
    return enemy
end

public.new = new

return public