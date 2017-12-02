local Game = {}

local windowWidth, windowHeight, TILE_SIZE

local myMap = require("map")

function Game.Load(pWindowWidth, pWindowHeight, pTILE_SIZE)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTILE_SIZE
  
  myMap.Load(windowWidth, windowHeight, TILE_SIZE)
  
end

function Game.Update(dt, pMenuState)
  myMap.Update(dt)
  
  return pMenuState
end

function Game.Draw()
  myMap.Draw()
end


return Game