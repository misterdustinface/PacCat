require("luasrc/tif")
local Color = luajava.bindClass("java.awt.Color")

local TILEWIDTH
local TILEHEIGHT

local borderHeight = 40
local borderWidth  = 40

local colormap = {
    ["PLAYER"]        = Color.YELLOW,
    ["ENEMY"]         = Color.RED,
    ["WALL"]          = Color.BLUE,
    ["FLOOR"]         = Color.BLACK,
    ["ENEMY_SPAWN"]   = Color.GRAY,
    ["PICKUP"]        = Color.WHITE,
}

local function getColor(tilename)
    local color = colormap[tilename]
    if color == nil then
        color = Color.GRAY
    end
    return color
end

local drawermap = {
    ["PLAYER"]  = function(g, info) 
        local row, col = info:getValueOf("ROW"), info:getValueOf("COL")
        local direction = info:getValueOf("DIRECTION")
        local speed__pct = info:getValueOf("SPEED__PCT")
    
        g:fillOval((col) * TILEWIDTH + borderWidth, (row) * TILEHEIGHT + borderHeight, TILEWIDTH, TILEHEIGHT)
        if direction == "UP" then
            g:setColor(Color.ORANGE)
            g:drawRect((col) * TILEWIDTH + borderWidth + TILEWIDTH/2, (row) * TILEHEIGHT + borderHeight, 1, TILEHEIGHT/2)
        elseif direction == "DOWN" then
            g:setColor(Color.ORANGE)
            g:drawRect((col) * TILEWIDTH + borderWidth + TILEWIDTH/2, (row) * TILEHEIGHT + borderHeight + TILEHEIGHT/2, 1, TILEHEIGHT/2)
        elseif direction == "RIGHT" then
            g:setColor(Color.ORANGE)
            g:drawRect((col) * TILEWIDTH + borderWidth + TILEWIDTH/2, (row) * TILEHEIGHT + borderHeight + TILEHEIGHT/2, TILEWIDTH/2, 1)
        elseif direction == "LEFT" then
            g:setColor(Color.ORANGE)
            g:drawRect((col) * TILEWIDTH + borderWidth, (row) * TILEHEIGHT + borderHeight + TILEHEIGHT/2, TILEWIDTH/2, 1)
        end
        
    end,
    ["ENEMY"]   = function(g, info)
        local row, col = info:getValueOf("ROW"), info:getValueOf("COL")
        g:fillOval((col) * TILEWIDTH + borderWidth, (row) * TILEHEIGHT + borderHeight, TILEWIDTH, TILEHEIGHT) 
    end,
    ["PICKUP"]  = function(g, info) 
        local row, col = info:getValueOf("ROW"), info:getValueOf("COL")
        local pickupWidth, pickupHeight = TILEWIDTH/4, TILEHEIGHT/4
        g:fillOval((col) * TILEWIDTH + borderWidth + TILEWIDTH/2 - pickupWidth/2, (row) * TILEHEIGHT + borderHeight + TILEHEIGHT/2 - pickupHeight/2, pickupWidth, pickupHeight)
    end,
}

local function getPactorDrawer(type)
    local drawer = drawermap[type]
    return drawer
end

local function drawTile(row, col, tilename)
    local g = DISPLAY:getGraphics()
    local tileColor = getColor(tilename)   
    g:setColor(tileColor)
    g:fillRect((col-1) * TILEWIDTH + borderWidth, (row-1) * TILEHEIGHT + borderHeight, TILEWIDTH, TILEHEIGHT)
end

local function drawPactor(type, info)
    local g = DISPLAY:getGraphics()
    local pactorColor = getColor(type)
    local pactorDrawer = getPactorDrawer(type)    
    g:setColor(pactorColor)
    pactorDrawer(g, info)
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
    
    local pickups = GAME:getInfoForAllPactorsWithAttribute("IS_PICKUP")
    local enemies = GAME:getInfoForAllPactorsWithAttribute("IS_ENEMY")
    local players = GAME:getInfoForAllPactorsWithAttribute("IS_PLAYER")
    
    for x = 1, pickups.length do
        drawPactor("PICKUP", pickups[x])
    end
    for x = 1, enemies.length do
        drawPactor("ENEMY", enemies[x])
    end
    for x = 1, players.length do
        drawPactor("PLAYER", players[x])
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