require("luasrc/VoidFunctionPointer")

local inputProcessor   = GAME:getInputProcessor()
local gameAttributes   = GAME:getAttributes()
local mainLoop         = GAME:getGameLoop()

local function getGameSpeed__ups()
    return gameAttributes:getValueOf("GAMESPEED__UPS")
end

local function shiftGameSpeed__ups(shiftamount__ups)
    gameAttributes:setAttribute("GAMESPEED__UPS", getGameSpeed__ups() + shiftamount__ups)
end

local function pause()
    gameAttributes:setAttribute("IS_PAUSED", true)
    mainLoop:setUpdatesPerSecond(0)
end

local function play()
    gameAttributes:setAttribute("IS_PAUSED", false)
    mainLoop:setUpdatesPerSecond(getGameSpeed__ups())
end

local function increaseGameSpeed()
    shiftGameSpeed__ups(10)
    mainLoop:setUpdatesPerSecond(getGameSpeed__ups())
end

local function decreaseGameSpeed()
    shiftGameSpeed__ups(-10)
    mainLoop:setUpdatesPerSecond(getGameSpeed__ups())
end

local function addLife()
    GAME:setValueOf("LIVES", GAME:getValueOf("LIVES") + 1)
end

local function removeLife()
    GAME:setValueOf("LIVES", GAME:getValueOf("LIVES") - 1)
end

local function nextLevel()
    local score = GAME:getValueOf("SCORE")
    local lives = GAME:getValueOf("LIVES")
    local level = GAME:getValueOf("LEVEL") + 1
    GAME:sendCommand("RELOAD")
    GAME:setValueOf("SCORE", score)
    GAME:setValueOf("LIVES", lives)
    GAME:setValueOf("LEVEL", level)
end

local function restartGame()
    if GAME:getValueOf("LOST_GAME") then
        GAME:sendCommand("RELOAD")
    end
end

local function reloadFeatures()
    GAME:sendCommand("PAUSE")
    loadFeatures("features/Reloadable")
    GAME:sendCommand("PLAY")
end

local function quitGame()
    GAME:quit()
end

inputProcessor:addCommand("UP",          CONTROLLER1:wrapCommand("UP")) 
inputProcessor:addCommand("DOWN",        CONTROLLER1:wrapCommand("DOWN"))
inputProcessor:addCommand("LEFT",        CONTROLLER1:wrapCommand("LEFT")) 
inputProcessor:addCommand("RIGHT",       CONTROLLER1:wrapCommand("RIGHT")) 
inputProcessor:addCommand("PAUSE",       VoidFunctionPointer(pause))
inputProcessor:addCommand("PLAY",        VoidFunctionPointer(play))
inputProcessor:addCommand("GAMESPEED++", VoidFunctionPointer(increaseGameSpeed)) 
inputProcessor:addCommand("GAMESPEED--", VoidFunctionPointer(decreaseGameSpeed))
inputProcessor:addCommand("RELOAD",      VoidFunctionPointer(reloadFeatures))
inputProcessor:addCommand("QUIT",        VoidFunctionPointer(quitGame))
inputProcessor:addCommand("LEVEL++",     VoidFunctionPointer(nextLevel))
inputProcessor:addCommand("LIVES++",     VoidFunctionPointer(addLife))
inputProcessor:addCommand("LIVES--",     VoidFunctionPointer(removeLife))
inputProcessor:addCommand("RESTART",     VoidFunctionPointer(restartGame))