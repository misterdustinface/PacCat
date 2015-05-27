
local function gameRules()

    if GAME:getValueOf("LIVES") <= -1 then
        GAME:setValueOf("LOST_GAME", true)
        GAME:sendCommand("PAUSE")
    end
    
    if GAME:getNumberOfPactorsWithAttribute("IS_PICKUP") <= 0 then
        GAME:sendCommand("LEVEL++")
    end
    
end

GAME_RULES_TICK = gameRules