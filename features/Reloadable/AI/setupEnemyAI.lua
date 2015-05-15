local world = GAME:getWorld()

local function followPlayer1(myName)
    local player1Pos = { row = world:getRowOf("PLAYER1"),  col = world:getColOf("PLAYER1") }
    local myPos      = { row = world:getRowOf(myName),     col = world:getColOf(myName) }
    local me = world:getPactor(myName)
    
    if player1Pos.row < myPos.row     and world:isTraversableForPactor(myPos.row-1, myPos.col, myName) then
        me:performAction("UP")
    elseif player1Pos.row > myPos.row and world:isTraversableForPactor(myPos.row+1, myPos.col, myName) then
        me:performAction("DOWN")
    elseif player1Pos.col < myPos.col and world:isTraversableForPactor(myPos.row, myPos.col-1, myName) then
        me:performAction("LEFT")
    elseif player1Pos.col > myPos.col and world:isTraversableForPactor(myPos.row, myPos.col+1, myName) then
        me:performAction("RIGHT")
    end
end

local function enemyTick()
    followPlayer1("FRIENEMY")
    followPlayer1("FRIENEMY2")
    followPlayer1("FRIENEMY3")
    -- TODO
end

AI_TICK = enemyTick