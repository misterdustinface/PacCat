require("PacDaddyGameWrapper/PactorCollisionFunction")
require("PacDaddyGameWrapper/PactorCommon")
local Pellet = require("PacDaddyGameWrapper/Pellet")

local public = {}

local function new()
    local self = Pellet:new()
    self:setAttribute("IS_ENERGIZER", true)
    self:setAttribute("TYPE", "ENERGIZER")
    self:setAttribute("VALUE", 50)
    self:setAttribute("SPEED__PCT", 0.0)

    local function onPactorCollision(otherPactorAttributes)
        if otherPactorAttributes:getValueOf("IS_PLAYER") then
            DESTROY_AND_CONSUME_PACTOR(self)
            ENERGIZE_PLAYER()
        end
    end
    
    self:setOnCollisionFunction(PactorCollisionFunction(onPactorCollision))
    return self
end

public.new = new

return public