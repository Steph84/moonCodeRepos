local Game = {}

local windowWidth, windowHeight, TILE_SIZE
Game.Statistics = {}

local myMap = require("map")
local myHud = require("hud")
local myPlayer = require("player")

function Game.Load(pWindowWidth, pWindowHeight, pTILE_SIZE, pFontSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTILE_SIZE
  
  myMap.Load(windowWidth, windowHeight, TILE_SIZE, myPlayer)
  myHud.Load(windowWidth, windowHeight, TILE_SIZE, pFontSize)
  myPlayer.Load(windowWidth, windowHeight, TILE_SIZE, myMap.Size)
  
end

function Game.Update(dt, pMenuState)
  myHud.Update(dt)
  myPlayer.Update(dt)
  myMap.Update(dt, myPlayer.Position)
  
  return pMenuState
end

function Game.Draw()
  myMap.Draw()
  myHud.Draw()
  myPlayer.Draw()
  
end

return Game