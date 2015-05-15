local populationTable = {
    { class = "Player", row = 24, col = 15, name = "PLAYER1",   traversable = { "FLOOR" } },
    { class = "Enemy",  row = 15, col = 14, name = "FRIENEMY",  traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.5 },
    { class = "Enemy",  row = 15, col = 15, name = "FRIENEMY2", traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.3 },
    { class = "Enemy",  row = 15, col = 16, name = "FRIENEMY3", traversable = { "FLOOR", "ENEMY_SPAWN" }, speed = 0.8 },
}

local board = GAME:getTiledBoard()
local tilenames = GAME:getTileNames()

for row = 1, board.length do
    for col = 1, board[1].length do
        local tileEnum = board[row][col]
        local tileName = tilenames[tileEnum+1]
        
        if tileName == "FLOOR" then
            table.insert(populationTable, {
                class = "Pickup", row = row, col = col, name = "PICKUP".."R:"..row.."C:"..col, traversable = { "FLOOR" }
            })
        end
    end
end

return populationTable