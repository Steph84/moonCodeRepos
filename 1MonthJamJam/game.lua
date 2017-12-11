local Game = {}

local windowWidth, windowHeight, TILE_SIZE
Game.Statistics = {}

local myMap = require("map")
local myHud = require("hud")
local myPlayer = require("player")
local myComboBox = require("comboBox")

function Game.Load(pWindowWidth, pWindowHeight, pTILE_SIZE, pFontSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTILE_SIZE
  
  myMap.Load(windowWidth, windowHeight, TILE_SIZE, myPlayer)
  myHud.Load(windowWidth, windowHeight, TILE_SIZE, pFontSize)
  myPlayer.Load(windowWidth, windowHeight, myMap)
  myComboBox.Load(myMap, myPlayer)
  
end

function Game.Update(dt, pMenuState)
  myMap.Update(dt)
  myHud.Update(dt)
  myPlayer.Update(dt)
  myComboBox.Update(dt, myPlayer.position)
  
  return pMenuState
end

function Game.Draw()
  myMap.Draw()
  myHud.Draw()
  myPlayer.Draw()
  myComboBox.Draw()
  
end

return Game