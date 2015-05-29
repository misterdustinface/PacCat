local poptable = dofile("levels/baselevelPopulate.lua")

local Player    = require("PacDaddyGameWrapper/Player")
local Enemy     = require("PacDaddyGameWrapper/Enemy")
local Pellet    = require("PacDaddyGameWrapper/Pellet")
local Energizer = require("PacDaddyGameWrapper/Energizer")

local classmap = {
  ["Player"]    = Player,
  ["Enemy"]     = Enemy,
  ["Pellet"]    = Pellet,
  ["Energizer"] = Energizer,
}

local function populate(poptable)
    local world = GAME:getWorld()
    for _, entity in ipairs(poptable) do
        local name  = entity.name
        local class = classmap[entity.class]
        local obj   = class:new()
        world:addPactor(name, obj)
        local row, col = entity.row, entity.col
        world:setPactorSpawn(name, row - 1, col - 1)
        world:respawnPactor(name)
        local travTilesTable = entity.traversable
        for _, tile in ipairs(travTilesTable) do
            world:setTileAsTraversableForPactor(tile, name)
        end
        
        local speed = entity.speed
        if speed then
            world:setPactorSpeed(name, speed)
        end
    end
end

populate(poptable)