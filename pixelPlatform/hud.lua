local Hud = {}

local windowWidth, windowHeight, TILE_SIZE

local myMap = require("map")
local myEnemy = require("enemy")

function Hud.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
end

function Hud.Draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(#myEnemy.listEnemies, 100, myMap.size.pixH + TILE_SIZE, windowWidth, "left")
end

return Hud