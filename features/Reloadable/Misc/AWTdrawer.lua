require("luasrc/tif")
local Color = luajava.bindClass("java.awt.Color")
local Image = luajava.bindClass("java.awt.image.BufferedImage")
local RenderingHints = luajava.bindClass("java.awt.RenderingHints")

local ImageA = luajava.newInstance("java.awt.image.BufferedImage", 1, 1, Image.TYPE_INT_RGB)
local ImageB = luajava.newInstance("java.awt.image.BufferedImage", 1, 1, Image.TYPE_INT_RGB)

local TILEWIDTH
local TILEHEIGHT

local borderHeight = 40
local borderWidth  = 40

local wallcolors = {
    [0] = Color.BLACK,
    Color.BLUE,
    Color.GREEN,
    Color.YELLOW,
    Color.ORANGE,
    Color.RED,
    Color.MAGENTA,
    Color.GRAY,
}

local wallcomplimentcolors = {
    [0] = Color.GRAY,
    Color.BLACK,
    Color.BLACK,
    Color.BLACK,
    Color.BLACK,
    Color.BLACK,
    Color.BLACK,
    Color.BLACK,
}

local function getWallColor()
    return wallcolors[(GAME:getValueOf("LEVEL") % (#wallcolors + 1))]
end

local function getWallColorCompliment()
    return wallcomplimentcolors[(GAME:getValueOf("LEVEL") % (#wallcomplimentcolors + 1))]
end

local ghostColors = {
    ["PINKY"]  = Color.PINK,
    ["BLINKY"] = Color.RED,
    ["INKY"]   = Color.CYAN,
    ["CLYDE"]  = Color.ORANGE,
}

local pactorColorMap = {
    ["PLAYER"]        = function(pactor) return Color.YELLOW end,
    ["ENEMY"]         = function(pactor)
                            local color
                            if pactor:getValueOf("IS_FRIGHTENED") then
                                color = Color.BLUE
                            else
                                color = ghostColors[pactor:getValueOf("NAME")] or Color.GREEN
                            end
                            return color
                        end,
    ["PELLET"]        = function(pactor) return Color.WHITE end,
    ["ENERGIZER"]     = function(pactor) return Color.WHITE end,
}

local tileColorMap = {
    ["WALL"]          = getWallColor, -- return Color.BLUE end,
    ["FLOOR"]         = getWallColorCompliment, --return Color.BLACK end,
    ["ENEMY_SPAWN"]   = getWallColorCompliment, --return Color.GRAY end,
}

local function getPactorColor(pactor)
    local type = pactor:getValueOf("TYPE")
    local color = pactorColorMap[type](pactor)
    if color == nil then
        color = Color.GRAY
    end
    return color
end

local function getTileColor(tilename)
    local color = tileColorMap[tilename]()
    if color == nil then
        color = Color.GRAY
    end
    return color
end

local drawOrder = {
  "PELLET",
  "ENERGIZER",
  "ENEMY",
  "PLAYER",
}

local drawermap = {
    ["PLAYER"]  = function(g, pactor, info) 
        local row, col = info:getValueOf("ROW"), info:getValueOf("COL")
        local direction = info:getValueOf("DIRECTION")
        local speed__pct = info:getValueOf("SPEED__PCT")
    
        g:fillOval((col) * TILEWIDTH, (row) * TILEHEIGHT, TILEWIDTH, TILEHEIGHT)
        if direction == "UP" then
            g:setColor(Color.ORANGE)
            g:drawRect((col) * TILEWIDTH + TILEWIDTH/2, (row) * TILEHEIGHT, 1, TILEHEIGHT/2)
        elseif direction == "DOWN" then
            g:setColor(Color.ORANGE)
            g:drawRect((col) * TILEWIDTH + TILEWIDTH/2, (row) * TILEHEIGHT + TILEHEIGHT/2, 1, TILEHEIGHT/2)
        elseif direction == "RIGHT" then
            g:setColor(Color.ORANGE)
            g:drawRect((col) * TILEWIDTH + TILEWIDTH/2, (row) * TILEHEIGHT + TILEHEIGHT/2, TILEWIDTH/2, 1)
        elseif direction == "LEFT" then
            g:setColor(Color.ORANGE)
            g:drawRect((col) * TILEWIDTH, (row) * TILEHEIGHT + TILEHEIGHT/2, TILEWIDTH/2, 1)
        end
        
    end,
    ["ENEMY"]   = function(g, pactor, info)
        local row, col = info:getValueOf("ROW"), info:getValueOf("COL")
        g:fillOval((col) * TILEWIDTH, (row) * TILEHEIGHT, TILEWIDTH, TILEHEIGHT)
        g:fillRect((col) * TILEWIDTH, (row) * TILEHEIGHT + (TILEHEIGHT/2), TILEWIDTH, (TILEHEIGHT/2))
    end,
    ["PELLET"]  = function(g, pactor, info) 
        local row, col = info:getValueOf("ROW"), info:getValueOf("COL")
        local pickupWidth, pickupHeight = TILEWIDTH/4, TILEHEIGHT/4
        g:fillOval((col) * TILEWIDTH + TILEWIDTH/2 - pickupWidth/2, (row) * TILEHEIGHT + TILEHEIGHT/2 - pickupHeight/2, pickupWidth, pickupHeight)
    end,
    ["ENERGIZER"] = function(g, pactor, info)
        local row, col = info:getValueOf("ROW"), info:getValueOf("COL")
        local pickupWidth, pickupHeight = TILEWIDTH/(1.75), TILEHEIGHT/(1.75)
        g:fillOval((col) * TILEWIDTH + TILEWIDTH/2 - pickupWidth/2, (row) * TILEHEIGHT + TILEHEIGHT/2 - pickupHeight/2, pickupWidth, pickupHeight)
    end
}

local function getPactorDrawer(type)
    local drawer = drawermap[type]
    return drawer
end

local function drawTile(g, row, col, tilename)
    local tileColor = getTileColor(tilename)   
    g:setColor(tileColor)
    g:fillRect((col-1) * TILEWIDTH, (row-1) * TILEHEIGHT, TILEWIDTH+1, TILEHEIGHT+1)
end

local function drawPactor(g, pactor)
    local type = pactor:getValueOf("TYPE")
    local pactorDrawer = getPactorDrawer(type)    
    local name = pactor:getValueOf("NAME")
    local info = GAME:getWorldInfoForPactor(name)
    if pactorDrawer and pactor and info then
        local pactorColor = getPactorColor(pactor)
        g:setColor(pactorColor)
        pactorDrawer(g, pactor, info)
    end
end

local function drawBoard(g, board)
    local tilenames = GAME:getTileNames()
    local boardWidth = DISPLAY:getWidth() - 2*borderWidth
    local boardHeight = DISPLAY:getHeight() - 2*borderHeight
    TILEWIDTH  = boardWidth / board[1].length
    TILEHEIGHT = boardHeight / board.length
    
    for row = 1, board.length do
        for col = 1, board[1].length do
            local tileEnum = board[row][col]
            local tileName = tilenames[tileEnum+1]
            drawTile(g, row, col, tileName)
        end
    end
end

local function getBucket(buckets, name)
    if not buckets[name] then 
        buckets[name] = {} 
    end
    local bucket = buckets[name]
    return bucket
end

local function getSortedPactors(pactors)
    local sortOrder = drawOrder
    local typeBuckets = {}
    local sortedPactors = {}

    for _, pactor in ipairs(pactors) do
        local type = pactor:getValueOf("TYPE")
        local bucket = getBucket(typeBuckets, type)
        table.insert(bucket, pactor)
    end
    
    for _, type in ipairs(sortOrder) do
        local bucket = getBucket(typeBuckets, type)
        for _, pactor in ipairs(bucket) do
            table.insert(sortedPactors, pactor)
        end
    end
    
    return sortedPactors
end

local function drawPactors(g)
    local pactors = GAME:getAllPactors()
    pactors = getSortedPactors(pactors)
    
    g:setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
        
    for _, pactor in ipairs(pactors) do
        drawPactor(g, pactor)
    end
    
    g:setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_OFF)
end

local function drawInfo(g)
    local upsStr = tif(GAME:getValueOf("IS_PAUSED"), "PAUSED", "UPS: " .. GAME:getValueOf("GAMESPEED__UPS"))
    local fpsStr = "FPS: " .. DISPLAY:getFPS()
    
    g:setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
    g:setColor(Color.WHITE)
    g:drawString(upsStr, 20, 20)
    g:drawString(fpsStr, 80, 20)
    g:drawString("LEVEL " .. GAME:getValueOf("LEVEL"), 140, 20)
    g:drawString("LIVES " .. GAME:getValueOf("LIVES"), 200, 20)
    g:drawString("SCORE " .. GAME:getValueOf("SCORE"), 260, 20)
    g:setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_OFF)
end

local function swapImageBuffers()
    ImageA, ImageB = ImageB, ImageA
    ImageA = luajava.newInstance("java.awt.image.BufferedImage", DISPLAY:getWidth(), DISPLAY:getHeight(), Image.TYPE_INT_RGB)
end

local function getDrawingImage()
    return ImageA 
end

local function getRenderingImage()
    return ImageB
end

local function drawGameplay(g)
    g:drawImage(getRenderingImage(), borderWidth, borderHeight, nil)
    drawInfo(g)
    swapImageBuffers()

    local g = getDrawingImage():getGraphics()
    local board = GAME:getTiledBoard()
    if board then drawBoard(g, board) end
    drawPactors(g)
end

local function drawLoseScreen(g)
    g:setColor(Color.WHITE)
    g:drawString("LEVEL " .. GAME:getValueOf("LEVEL"), 40, 60)
    g:drawString("SCORE " .. GAME:getValueOf("SCORE"), 40, 80)
    g:drawString("[PRESS ENTER TO RESTART]",           40, 100)
end

local function clearScreen()
    local g = DISPLAY:getGraphics()
    g:setColor(Color.BLACK)
    g:fillRect(0, 0, DISPLAY:getWidth(), DISPLAY:getHeight())
end

local function drawGame()
    clearScreen()
    local g = DISPLAY:getGraphics()
    
    if GAME:getValueOf("LOST_GAME") then
        drawLoseScreen(g)
    else
        drawGameplay(g)
    end
end

DRAWGAME = drawGame