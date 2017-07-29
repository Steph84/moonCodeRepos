local Game = {}

local windowWidth, windowHeight, TILE_SIZE

local myMap = require("map")
local myMachina = require("machina")

function Game.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  myMap.Load(windowWidth, windowHeight, TILE_SIZE)
  
end

function Game.Update(dt)
  
end

function Game.Draw()
  myMap.Draw(1)
end

return Game