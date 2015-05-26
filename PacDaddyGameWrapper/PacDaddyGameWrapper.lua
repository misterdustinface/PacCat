local public = {}

local game = APPLICATION

local boardReader = game:getBoardReader()
local inputProcessor = game:getInputProcessor()
local attributeReader = game:getGameAttributeReader()

local function addComponentToGame(this, name, implementation)
    game:addComponent(name, implementation)
end

local function startGame(this)
    game:start()
end

local function quitGame(this)
    game:quit()
end

local function sendCommand(this, command)
    inputProcessor:sendCommand(command)
end

local function getCommands(this)
    return inputProcessor:getCommands()
end

local function getValueOf(this, attribute)
    return attributeReader:getValueOf(attribute)
end

local function setValueOf(this, attribute, value)
    attributeReader:setAttribute(attribute, value)
end

local function getAttributes(this)
    return attributeReader:getAttributes()
end

local function getTiledBoard(this)
    local ok, board = pcall(boardReader.getTiledBoard, boardReader)
    if ok then return board end
end

local function getTileNames(this)
    local ok, tilenames = pcall(boardReader.getTileNames, boardReader)
    if ok then return tilenames end
end

local function getInfoForAllPactorsWithAttribute(this, attribute)
    local ok, info = pcall(boardReader.getInfoForAllPactorsWithAttribute, boardReader, attribute)
    if ok then return info end
end

local function getNumberOfPactorsWithAttribute(this, attribute)
    local info = this:getInfoForAllPactorsWithAttribute(attribute)
    if info then return info.length end
end

local function getModifiableWorld(this)
    return game:getWritable("WORLD")
end

local function getModifiableAttributes(this)
    return game:getWritable("ATTRIBUTES")
end

local function getModifiableInputProcessor(this)
    return game:getWritable("INPUT_PROCESSOR")
end

local function getModifiableGameLoop(this)
    return game:getWritable("MAINLOOP")
end

local function getModifiablePactorController(this)
    return game:getWritable("PACTOR_CONTROLLER")
end

local function getModifiablePactor(this, name)
    local world = this:getWorld()
    local pactorExists, pactor = pcall(world.getPactor, world, name)
    if pactorExists then return pactor end
end

local function isTraversableForPactor(this, row, col, name)
    -- expecting 0 based indexing
    local world = this:getWorld()
    local ok, traversable = pcall(world.isTraversableForPactor, world, (row - 1), (col - 1), name)
    return (ok and traversable)
end

local function getPactorNames(this)
    local world = this:getWorld()
    return world:getPactorNames()
end

local function attemptToGetCoordinateOfPactor(this, name)
    local world = this:getWorld()
    local row = world:getRowOf(name) + 1
    local col = world:getColOf(name) + 1
    return { row = row, col = col }
end

local function getCoordinateOfPactor(this, name)
    local exists, coordinate = pcall(attemptToGetCoordinateOfPactor, this, name)
    if exists then return coordinate end
end

local function removePactor(this, name)
    local world = this:getWorld()
    world:removePactor(name)
end

public.addComponent = addComponentToGame
public.start = startGame
public.quit = quitGame
public.sendCommand = sendCommand
public.getCommands = getCommands
public.getValueOf = getValueOf
public.setValueOf = setValueOf
public.getAttributes = getAttributes
public.getTiledBoard = getTiledBoard
public.getTileNames = getTileNames
public.getInfoForAllPactorsWithAttribute = getInfoForAllPactorsWithAttribute
public.getNumberOfPactorsWithAttribute = getNumberOfPactorsWithAttribute
public.getWorld = getModifiableWorld
public.getAttributes = getModifiableAttributes
public.getInputProcessor = getModifiableInputProcessor
public.getGameLoop = getModifiableGameLoop
public.getPactorController = getModifiablePactorController
public.getPactor = getModifiablePactor
public.getPactorNames = getPactorNames
public.isTraversableForPactor = isTraversableForPactor
public.getCoordinateOfPactor = getCoordinateOfPactor
public.removePactor = removePactor

return public