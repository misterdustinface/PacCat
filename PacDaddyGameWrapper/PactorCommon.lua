
function CONSUME_PACTOR(pickup)
    local gameAttributes = GAME:getAttributes()
    gameAttributes:setAttribute("SCORE", gameAttributes:getValueOf("SCORE") + pickup:getValueOf("VALUE"))
    pickup:setAttribute("VALUE", 0)
    local myName = pickup:getValueOf("NAME")
    GAME:removePactor(myName)
end