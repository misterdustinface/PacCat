
local function gameRules()

    if GAME:getValueOf("LIVES") <= -1 then
        GAME:setValueOf("LOST_GAME", true)
        GAME:sendCommand("PAUSE")
    end
    
    if GAME:getNumberOfPactorsWithAttribute("IS_PICKUP") <= 0 then
        GAME:sendCommand("LEVEL++")
    end
    
    local score = GAME:getValueOf("SCORE")
    if (score % 10000) == 0 and score ~= lastExtraLifeScorethen and score ~= 0 then
        lastExtraLifeScore = GAME:getValueOf("SCORE")
        GAME:sendCommand("LIVES++")
    end
    
    if GAME:getValueOf("ENERGIZED_TIMER"):isDebounceComplete() then
        CALM_ALL_ENEMIES()
    end
    
end

GAME_RULES_TICK = gameRules