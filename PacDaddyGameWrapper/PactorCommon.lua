
function CONSUME_PACTOR(pickup)
    local gameAttributes = GAME:getAttributes()
    gameAttributes:setAttribute("SCORE", gameAttributes:getValueOf("SCORE") + pickup:getValueOf("VALUE"))
    pickup:setAttribute("VALUE", 0)
end

function DESTROY_AND_CONSUME_PACTOR(pactor)
    CONSUME_PACTOR(pactor)
    GAME:removePactor(pactor:getValueOf("NAME"))
end

function REVIVE_PACTOR(pactor)
    GAME:respawnPactor(pactor:getValueOf("NAME"))
end

function ENERGIZE_PLAYER()
    GAME:getValueOf("ENERGIZED_TIMER"):reset()
    FRIGHTEN_ALL_ENEMIES()
end

function FRIGHTEN(pactor)
    pactor:setAttribute("IS_FRIGHTENED", true)
end

function FRIGHTEN_ALL_ENEMIES()
    local enemiesInfo = GAME:getInfoForAllPactorsWithAttribute("IS_ENEMY")
    for i = 1, enemiesInfo.length do
        local pactor = GAME:getPactor(enemiesInfo[i]:getValueOf("NAME"))
        FRIGHTEN(pactor)
    end
end

function CALM(pactor)
    pactor:setAttribute("IS_FRIGHTENED", false)
end

function CALM_ALL_ENEMIES()
    local enemiesInfo = GAME:getInfoForAllPactorsWithAttribute("IS_ENEMY")
    for i = 1, enemiesInfo.length do
        local pactor = GAME:getPactor(enemiesInfo[i]:getValueOf("NAME"))
        CALM(pactor)
    end
end