local public = {}

local game = APPLICATION

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
    this.inputProcessor:sendCommand(command)
end

local function getCommands(this)
    return this.inputProcessor:getCommands()
end

local function getValueOf(this, attribute)
    return this.attributeReader:getValueOf(attribute)
end

local function getAttributes(this)
    return this.attributeReader:getAttributes()
end

local function getTiledBoard(this)
    local ok, board = pcall(this.boardReader.getTiledBoard, this.boardReader)
    if ok then return board end
end

local function getTileNames(this)
    local ok, tilenames = pcall(this.boardReader.getTileNames, this.boardReader)
    if ok then return tilenames end
end

local function getInfoForAllPactorsWithAttribute(this, attribute)
    local ok, info = pcall(this.boardReader.getInfoForAllPactorsWithAttribute, this.boardReader, attribute)
    if ok then return info end
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
    return this:getModifiableWorld():getPactor(name)
end

public.boardReader                   = game:getBoardReader()
public.inputProcessor                = game:getInputProcessor()
public.attributeReader               = game:getGameAttributeReader()
public.addComponent                  = addComponentToGame
public.start                         = startGame
public.quit                          = quitGame
public.sendCommand                   = sendCommand
public.getCommands                   = getCommands
public.getValueOf                    = getValueOf
public.getAttributes                 = getAttributes
public.getTiledBoard                 = getTiledBoard
public.getTileNames                  = getTileNames
public.getInfoForAllPactorsWithAttribute = getInfoForAllPactorsWithAttribute

public.getModifiableWorld            = getModifiableWorld
public.getModifiableAttributes       = getModifiableAttributes
public.getModifiableInputProcessor   = getModifiableInputProcessor
public.getModifiableGameLoop         = getModifiableGameLoop
public.getModifiablePactorController = getModifiablePactorController
public.getModifiablePactor           = getModifiablePactor

return public