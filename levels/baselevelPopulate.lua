local populationTable = {
    { class = "Player", row = 24, col = 15, name = "PLAYER1",   traversable = { "FLOOR" } },
    { class = "Enemy",  row = 14, col = 15, name = "BLINKY", traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.75 },
    { class = "Enemy",  row = 15, col = 14, name = "INKY",   traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.5 },
    { class = "Enemy",  row = 15, col = 15, name = "PINKY",  traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.5 },
    { class = "Enemy",  row = 15, col = 16, name = "CLYDE",  traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.25 },
    { class = "Enemy",  row = 14, col = 14, name = "GUNKY",  traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.25 },
    { class = "Energizer", row = 24, col = 17, name = "ENERGIZER1", traversable = { "FLOOR" } },
}

local board = GAME:getTiledBoard()
local tilenames = GAME:getTileNames()

for row = 1, board.length do
    for col = 1, board[1].length do
        local tileEnum = board[row][col]
        local tileName = tilenames[tileEnum+1]
        
        if tileName == "FLOOR" then
            table.insert(populationTable, {
                class = "Pellet", row = row, col = col, name = "PELLET".."R:"..row.."C:"..col, traversable = { "FLOOR" }
            })
        end
    end
end

return populationTable