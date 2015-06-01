local world = GAME:getWorld()
local GravityMap = require("features/Reloadable/AI/GravityMap")

local primaryDirection = { }
local secondaryDirection = { }

local gravityMap = GravityMap:new()

local function degenerate(weight, depth)
    return weight / (depth+1)
end

local function tickGravityMap()
    gravityMap:setWeights({ PLAYER = 9000 })
    gravityMap:setDegeneracyFunction( degenerate )
    gravityMap:generate()
    --gravityMap:print()
end

local function tickPactorAI(myName)
    primaryDirection[myName] = gravityMap:bestMove(myName)
    secondaryDirection[myName] = gravityMap:bestSecondaryMove(myName)
end

local function forcePactorPerform(name)
    local pactor = world:getPactor(name)
    
    if not primaryDirection[name] then
        primaryDirection[name] = "NONE"
    end
    if not secondaryDirection[name] then
        secondaryDirection[name] = "NONE"
    end
    
    if pactor then    
        if pactor:getValueOf("DIRECTION") == "NONE" then
            pactor:performAction(primaryDirection[name])
        else
            pactor:performAction(primaryDirection[name])
            --pactor:performAction(secondaryDirection[name])
        end  
    end
end

local function enemyTick()
    tickGravityMap()
    local enemiesInfo = GAME:getInfoForAllPactorsWithAttribute("IS_ENEMY")
    for i = 1, enemiesInfo.length do
        local pactor = GAME:getPactor(enemiesInfo[i]:getValueOf("NAME"))
        tickPactorAI(pactor:getValueOf("NAME"))
    end
    for i = 1, enemiesInfo.length do
        local pactor = GAME:getPactor(enemiesInfo[i]:getValueOf("NAME"))
        forcePactorPerform(pactor:getValueOf("NAME"))
    end
end

AI_TICK = enemyTick