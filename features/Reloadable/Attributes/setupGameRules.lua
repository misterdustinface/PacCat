
local function gameRules()

    if GAME:getValueOf("LIVES") == -1 then
        GAME:setValueOf("LOST_GAME", true)
        print("Lost Game. Score: " .. GAME:getValueOf("SCORE"))
        GAME:sendCommand("RELOAD")
    end
    
    if GAME:getNumberOfPactorsWithAttribute("IS_PICKUP") == 0 then
        local score = GAME:getValueOf("SCORE")
        local lives = GAME:getValueOf("LIVES")
        local level = GAME:getValueOf("LEVEL") + 1
        print("Level: " .. level)
        GAME:sendCommand("RELOAD")
        GAME:setValueOf("SCORE", score)
        GAME:setValueOf("LIVES", lives)
        GAME:setValueOf("LEVEL", level)
    end
    
end

GAME_RULES_TICK = gameRules