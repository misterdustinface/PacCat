
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