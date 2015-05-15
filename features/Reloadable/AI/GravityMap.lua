local public = {}
local Queue = require("luasrc/Queue")

local setWeights
local setDegeneracyFunction
local generate
local getGeneratedMap
local printMap

local resetMap
local applyGravityFieldToMap
local applyGravityIfEligible
local applyGravity
local canBodyAffectTile
local getGravityFieldLimitFunction
local clearActors
local enqueueActor
local dequeueActor
local hasActors
local clearVisited
local setVisited
local wasVisited
local setCurrentBody
local getCurrentBody
local degenerateGravityWeight
local addWeightToMap

local wrapRow
local wrapCol
local getBodyWeight
local isTraversableForPactor
local getWeight
local selectDirectionIfBestMove
local bestDirectionForPactorGivenCoordinate
local bestMove
local bestSecondaryMove

function wrapCol(gravMap, col)  
  if col < 1 then
    col = gravMap.worldBoard[1].length
  elseif col > gravMap.worldBoard[1].length then
    col = 1
  end
  return col
end

function wrapRow(gravMap, row)
  if row < 1 then
    row = gravMap.worldBoard.length
  elseif row > gravMap.worldBoard.length then
    row = 1
  end
  return row
end

function getBodyWeight(gravMap, body)
    local bodyWeight
    local pactor = GAME:getPactor(body)
    if pactor then
        local typeExists, bodyType = pcall(pactor.getValueOf, pactor, "TYPE")
        if typeExists and bodyType then
            bodyWeight = gravMap.weights[bodyType]
        end
    end
    return bodyWeight
end

function generate(gravMap)
    resetMap(gravMap)
    local pactorNames = GAME:getPactorNames()
    
    for i = 1, pactorNames.length do
        local body = pactorNames[i]
        local bodyWeight = getBodyWeight(gravMap, body)
        if bodyWeight then
            setCurrentBody(gravMap, body)
            local coor = GAME:getCoordinateOfPactor(body)
            coor.weight = bodyWeight
            applyGravityFieldToMap(gravMap, coor)
        end
    end
    
    return getGeneratedMap(gravMap)
end

function getGravityFieldLimitFunction(startWeight)
    local startedWithPositiveWeight = startWeight > 0
    if startedWithPositiveWeight then
        return (function(newWeight) return newWeight <= 0 end)
    else
        return (function(newWeight) return newWeight >= 0 end)
    end
end

function applyGravityFieldToMap(gravMap, coor)
    local hasHitFieldLimit = getGravityFieldLimitFunction(coor.weight)
    clearActors(gravMap)
    clearVisited(gravMap)
    coor.depth = 0
    applyGravity(gravMap, coor)
    while hasActors(gravMap) do
        local current = dequeueActor(gravMap)
        applyGravityIfEligible(gravMap, current, hasHitFieldLimit)
    end
end

function resetMap(gravMap)
    local board = GAME:getTiledBoard()
    local rows = board.length
    local cols = board[1].length

    gravMap.worldBoard = board
    gravMap.map = {}
    
    for row = 1, rows do
        gravMap.map[row] = {}
        for col = 1, cols do
            gravMap.map[row][col] = 0
        end
    end
end

function applyGravityIfEligible(gravMap, coor, hasHitFieldLimit)
    if not wasVisited(gravMap, coor) and not hasHitFieldLimit(coor.weight) then
        applyGravity(gravMap, coor)
    end
end

function applyGravity(gravMap, coor)
    setVisited(gravMap, coor)
    if canBodyAffectTile(getCurrentBody(gravMap), coor) then
        addWeightToMap(gravMap, coor)
        local depth = coor.depth + 1
        local weight = degenerateGravityWeight(gravMap, coor.weight, depth)
        local row = coor.row
        local col = coor.col
        enqueueActor(gravMap, { row = wrapRow(gravMap, row + 1), col = col, weight = weight, depth = depth })
        enqueueActor(gravMap, { row = wrapRow(gravMap, row - 1), col = col, weight = weight, depth = depth })
        enqueueActor(gravMap, { row = row, col = wrapCol(gravMap, col + 1), weight = weight, depth = depth })
        enqueueActor(gravMap, { row = row, col = wrapCol(gravMap, col - 1), weight = weight, depth = depth })
    end
end

function canBodyAffectTile(body, coor)
    return GAME:isTraversableForPactor(coor.row, coor.col, body)
end

function setWeights(gravMap, weights)
    gravMap.weights = weights
end
function setDegeneracyFunction(gravMap, degeneracyFunction)
    gravMap.degeneracyFunction = degeneracyFunction
end
function getGeneratedMap(gravMap)
    return gravMap.map
end
function clearActors(gravMap)
    gravMap._actors:clear()
end
function enqueueActor(gravMap, actor)
    gravMap._actors:enqueue(actor)
end
function dequeueActor(gravMap)
    return gravMap._actors:dequeue()
end
function hasActors(gravMap)
    return not gravMap._actors:isEmpty()    
end
function clearVisited(gravMap)
    gravMap.visited = {}
end
function setVisited(gravMap, coor)
    gravMap.visited[coor.row .. "," .. coor.col] = true
end
function wasVisited(gravMap, coor)
    return gravMap.visited[coor.row .. "," .. coor.col]
end
function setCurrentBody(gravMap, body)
    gravMap.currentPactor = body
end
function getCurrentBody(gravMap)
    return gravMap.currentPactor
end
function degenerateGravityWeight(gravMap, weight, depth)
    return gravMap.degeneracyFunction(weight, depth)
end
function addWeightToMap(gravMap, coor)
    local row = wrapRow(gravMap, coor.row)
    local col = wrapCol(gravMap, coor.col)
    local weight = coor.weight
    gravMap.map[row][col] = gravMap.map[row][col] + weight
end

function printMap(gravMap)
    local map = gravMap:getGeneratedMap()
    for rowNum, rowTable in ipairs(map) do
        local t = {}
        for colNum, value in ipairs(rowTable) do
            if value > 0 then
                table.insert(t, string.format("[+%4.1d]", value))
            elseif value < 0 then
                table.insert(t, string.format("[-%4.1d]", -value))
            elseif value == 0 then
                table.insert(t, " ")
            end
        end
        print("[R: " .. rowNum .. "]", table.unpack(t))
    end
    print()
end

function isTraversableForPactor(gravMap, row, col, pactor)
    return canBodyAffectTile(pactor, {row = wrapRow(gravMap, row), col = wrapCol(gravMap, col) })
end

function getWeight(gravMap, row, col)
    return gravMap.map[wrapRow(gravMap, row)][wrapCol(gravMap, col)]
end

function selectDirectionIfBestMove(gravMap, pactorName, coordinate, direction, bestMove)
    if isTraversableForPactor(gravMap, coordinate.row, coordinate.col, pactorName) then
        local weight = getWeight(gravMap, coordinate.row, coordinate.col)
        if weight > bestMove.weight then
            bestMove.weight    = weight
            bestMove.direction = direction
        end
    end
end

function bestDirectionForPactorGivenCoordinate(gravMap, pactorName, coordinate)
    local bestMove = { direction = "NONE", weight = -(math.huge) }

    if coordinate then
        selectDirectionIfBestMove(gravMap, pactorName, { row = coordinate.row - 1, col = coordinate.col }, "UP",    bestMove)
        selectDirectionIfBestMove(gravMap, pactorName, { row = coordinate.row + 1, col = coordinate.col }, "DOWN",  bestMove)
        selectDirectionIfBestMove(gravMap, pactorName, { row = coordinate.row, col = coordinate.col - 1 }, "LEFT",  bestMove)
        selectDirectionIfBestMove(gravMap, pactorName, { row = coordinate.row, col = coordinate.col + 1 }, "RIGHT", bestMove)
    end
    
    return bestMove.direction
end

function bestMove(gravMap, pactorName)
    local coordinate = GAME:getCoordinateOfPactor(pactorName)
    return bestDirectionForPactorGivenCoordinate(gravMap, pactorName, coordinate)
end

local coordinateModifiers = {
    UP    = function(gravMap, coordinate) coordinate.row = wrapRow(gravMap, coordinate.row - 1) end,
    DOWN  = function(gravMap, coordinate) coordinate.row = wrapRow(gravMap, coordinate.row + 1) end,
    LEFT  = function(gravMap, coordinate) coordinate.col = wrapCol(gravMap, coordinate.col - 1) end,
    RIGHT = function(gravMap, coordinate) coordinate.col = wrapCol(gravMap, coordinate.col + 1) end,
}

function bestSecondaryMove(gravMap, pactorName)
    local coordinate = GAME:getCoordinateOfPactor(pactorName)

    local direction = bestMove(gravMap, pactorName)
    local coordinateModifier = coordinateModifiers[direction]
    if type(coordinateModifier) == 'function' then
        coordinateModifier(gravMap, coordinate)
    end
    
    return bestDirectionForPactorGivenCoordinate(gravMap, pactorName, coordinate)
end

public.new = function(this)
    return {
        setWeights = setWeights,
        setDegeneracyFunction = setDegeneracyFunction,
        generate = generate,
        getGeneratedMap = getGeneratedMap,
        bestMove = bestMove,
        bestSecondaryMove = bestSecondaryMove,
        print = printMap,
        _actors = Queue:new(),
    }
end

return public