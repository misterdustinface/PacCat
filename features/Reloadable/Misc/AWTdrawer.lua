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
    ["ENEMY"]   = function(g, info)
        local row, col = info:getValueOf("ROW"), info:getValueOf("COL")
        g:fillOval((col) * TILEWIDTH, (row) * TILEHEIGHT, TILEWIDTH, TILEHEIGHT) 
    end,
    ["PICKUP"]  = function(g, info) 
        local row, col = info:getValueOf("ROW"), info:getValueOf("COL")
        local pickupWidth, pickupHeight = TILEWIDTH/4, TILEHEIGHT/4
        g:fillOval((col) * TILEWIDTH + TILEWIDTH/2 - pickupWidth/2, (row) * TILEHEIGHT + TILEHEIGHT/2 - pickupHeight/2, pickupWidth, pickupHeight)
    end,
}

local function getPactorDrawer(type)
    local drawer = drawermap[type]
    return drawer
end

local function drawTile(g, row, col, tilename)
    local tileColor = getColor(tilename)   
    g:setColor(tileColor)
    g:fillRect((col-1) * TILEWIDTH, (row-1) * TILEHEIGHT, TILEWIDTH, TILEHEIGHT)
end

local function drawPactor(g, type, info)
    local pactorColor = getColor(type)
    local pactorDrawer = getPactorDrawer(type)    
    g:setColor(pactorColor)
    pactorDrawer(g, info)
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
    
    local pickups = GAME:getInfoForAllPactorsWithAttribute("IS_PICKUP")
    local enemies = GAME:getInfoForAllPactorsWithAttribute("IS_ENEMY")
    local players = GAME:getInfoForAllPactorsWithAttribute("IS_PLAYER")
    
    if pickups then
      for x = 1, pickups.length do
          drawPactor(g, "PICKUP", pickups[x])
      end
    end
    if enemies then
      for x = 1, enemies.length do
          drawPactor(g, "ENEMY", enemies[x])
      end
    end
    if players then
      for x = 1, players.length do
          drawPactor(g, "PLAYER", players[x])
      end
    end
    
end

local function drawInfo(g)
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

local function swapImageBuffers()
    ImageA, ImageB = ImageB, ImageA
    ImageA = luajava.newInstance("java.awt.image.BufferedImage", DISPLAY:getWidth(), DISPLAY:getHeight(), Image.TYPE_INT_RGB)
end

local function drawGame()
    clearScreen()
    local g = ImageA:getGraphics()
    g:setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
    local board = GAME:getTiledBoard()
    if board then drawBoard(g, board) end
        
    g = DISPLAY:getGraphics()
    g:setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
    g:drawImage(ImageB, borderWidth, borderHeight, nil)
    drawInfo(g)
    
    swapImageBuffers()
end

DRAWGAME = drawGame