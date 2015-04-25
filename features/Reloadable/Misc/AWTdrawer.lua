require("luasrc/tif")
local Color = luajava.bindClass("java.awt.Color")

local TILEWIDTH
local TILEHEIGHT

local borderHeight = 40
local borderWidth  = 40

local colormap = {
    ["PLAYER"] = Color.YELLOW,
    ["WALL"]   = Color.BLUE,
    ["FLOOR"]  = Color.BLACK,
    ["ENEMY"]  = Color.RED,
    ["PICKUP"] = Color.WHITE,
}

local function getTileColor(tilename)
    local color = colormap[tilename]
    if color == nil then
        color = Color.GRAY
    end
    return color
end

local drawermap = {
    ["FLOOR"]   = function(g, row, col) g:fillRect((col-1) * TILEWIDTH + borderWidth, (row-1) * TILEHEIGHT + borderHeight, TILEWIDTH, TILEHEIGHT) end,
    ["WALL"]    = function(g, row, col) g:fillRect((col-1) * TILEWIDTH + borderWidth, (row-1) * TILEHEIGHT + borderHeight, TILEWIDTH, TILEHEIGHT) end,
    ["PLAYER"]  = function(g, row, col) 
        local ok, tileAttributes = pcall(GAME.getAttributeReaderAtTile, GAME, row-1, col-1)
        local direction
        local speed__pct
        if ok then 
            direction  = tileAttributes:getValueOf("DIRECTION") 
            speed__pct = tileAttributes:getValueOf("SPEED__PCT")    
        end
    
        g:fillOval((col-1) * TILEWIDTH + borderWidth, (row-1) * TILEHEIGHT + borderHeight, TILEWIDTH, TILEHEIGHT)
        if direction == "UP" then
            g:setColor(Color.ORANGE)
            g:drawRect((col-1) * TILEWIDTH + borderWidth + TILEWIDTH/2, (row-1) * TILEHEIGHT + borderHeight, 1, TILEHEIGHT/2)
        elseif direction == "DOWN" then
            g:setColor(Color.ORANGE)
            g:drawRect((col-1) * TILEWIDTH + borderWidth + TILEWIDTH/2, (row-1) * TILEHEIGHT + borderHeight + TILEHEIGHT/2, 1, TILEHEIGHT/2)
        elseif direction == "RIGHT" then
            g:setColor(Color.ORANGE)
            g:drawRect((col-1) * TILEWIDTH + borderWidth + TILEWIDTH/2, (row-1) * TILEHEIGHT + borderHeight + TILEHEIGHT/2, TILEWIDTH/2, 1)
        elseif direction == "LEFT" then
            g:setColor(Color.ORANGE)
            g:drawRect((col-1) * TILEWIDTH + borderWidth, (row-1) * TILEHEIGHT + borderHeight + TILEHEIGHT/2, TILEWIDTH/2, 1)
        end
        
    end,
    ["ENEMY"]   = function(g, row, col) 
        g:fillOval((col-1) * TILEWIDTH + borderWidth, (row-1) * TILEHEIGHT + borderHeight, TILEWIDTH, TILEHEIGHT) 
    end,
    ["PICKUP"]  = function(g, row, col) 
        local pickupWidth, pickupHeight = TILEWIDTH/4, TILEHEIGHT/4
        g:fillOval((col-1) * TILEWIDTH + borderWidth + TILEWIDTH/2 - pickupWidth/2, (row-1) * TILEHEIGHT + borderHeight + TILEHEIGHT/2 - pickupHeight/2, pickupWidth, pickupHeight)
    end,
}

local function getShapeDrawer(tilename)
    local drawer = drawermap[tilename]
    if drawer == nil then
        drawer = drawermap["FLOOR"]
    end
    return drawer
end

local function drawTile(row, col, tilename)
    local g = DISPLAY:getGraphics()
    local tileColor = getTileColor(tilename)
    local tileDrawer = getShapeDrawer(tilename)    
    g:setColor(tileColor)
    tileDrawer(g, row, col)
end

local function drawBoard(board)
    local tilenames = GAME:getTileNames()
    local boardWidth = DISPLAY:getWidth() - 2*borderWidth
    local boardHeight = DISPLAY:getHeight() - 2*borderHeight
    TILEWIDTH  = boardWidth / board[1].length
    TILEHEIGHT = boardHeight / board.length
    
    for row = 1, board.length do
        for col = 1, board[1].length do
            local tileEnum = board[row][col]
            local tileName = tilenames[tileEnum+1]
            drawTile(row, col, tileName)
        end
    end
end

local function drawInfo()
    local g = DISPLAY:getGraphics()
    
    local upsStr = tif(GAME:getValueOf("IS_PAUSED"), "PAUSED", "UPS: " .. GAME:getValueOf("GAMESPEED__UPS"))
    local fpsStr = "FPS: " .. DISPLAY:getFPS()
    
    g:setColor(Color.WHITE)
    g:drawString(upsStr, 20, 20)
    g:drawString(fpsStr, 80, 20)
    g:drawString("LIVES " .. GAME:getValueOf("LIVES"), 140, 20)
    g:drawString("SCORE " .. GAME:getValueOf("SCORE"), 200, 20)
end

local function clearScreen()
    local g = DISPLAY:getGraphics()
    g:setColor(Color.BLACK)
    g:fillRect(0, 0, DISPLAY:getWidth(), DISPLAY:getHeight())
end

local function drawGame()
    clearScreen()
    local okAccess, board = pcall(GAME.getTiledBoard, GAME)
    if okAccess then drawBoard(board) end
    drawInfo()
end

DRAWGAME = drawGame