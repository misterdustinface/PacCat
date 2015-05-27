require("luasrc/tif")
local KEYS = require("AWTLib/AWTKeycodes")

local pressProcessDispatch = {
    [KEYS.UP]    = function() GAME:sendCommand("UP")    end,
    [KEYS.LEFT]  = function() GAME:sendCommand("LEFT")  end,
    [KEYS.DOWN]  = function() GAME:sendCommand("DOWN")  end,
    [KEYS.RIGHT] = function() GAME:sendCommand("RIGHT") end,
    [KEYS.P]     = function() GAME:sendCommand(tif(GAME:getValueOf("IS_PAUSED"), "PLAY", "PAUSE")) end,
    [KEYS.R]     = function() GAME:sendCommand("RELOAD") end,
    [KEYS.Q]     = function() GAME:sendCommand("QUIT")   end,
    [KEYS.ESC]   = function() GAME:sendCommand("QUIT")   end,
    [KEYS.ENTER] = function() GAME:sendCommand("RESTART") end,    
    [KEYS.F1]    = function() GAME:sendCommand("LEVEL++") end,
    [KEYS.F2]    = function() GAME:sendCommand("LIVES++") end,
    [KEYS.F3]    = function() GAME:sendCommand("LIVES--") end,
}

PRESS_PROCESS_DISPATCH = pressProcessDispatch