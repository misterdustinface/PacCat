local PactorController = require("PacDaddyGameWrapper/PactorController")

CONTROLLER1 = PactorController:new()
CONTROLLER2 = PactorController:new()

local player1 = GAME:getPactor("PLAYER1")
CONTROLLER1:setPactor(player1)