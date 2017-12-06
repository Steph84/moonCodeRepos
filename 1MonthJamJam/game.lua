local Game = {}

local windowWidth, windowHeight, TILE_SIZE
Game.Statistics = {}

local myMap = require("map")
local myHud = require("hud")

function Game.Load(pWindowWidth, pWindowHeight, pTILE_SIZE, pFontSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTILE_SIZE
  
  --myMap.Load(windowWidth, windowHeight, TILE_SIZE)
  myHud.Load(windowWidth, windowHeight, TILE_SIZE, pFontSize)
  
end

function Game.Update(dt, pMenuState)
  --myMap.Update(dt)
  myHud.Update(dt)
  
  return pMenuState
end

function Game.Draw()
  --myMap.Draw()
  myHud.Draw()
  
end

return Game