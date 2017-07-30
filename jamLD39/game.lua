local Game = {}

local windowWidth, windowHeight, TILE_SIZE
local level = 1
local lvlTrans = false

local myMap = require("map")
local myMachina = require("machina")
local myAnimation = require("lvlAnim")
local myHud = require("hud")

function Game.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  myMap.Load(windowWidth, windowHeight, TILE_SIZE)
  myMachina.Load(windowWidth, windowHeight, TILE_SIZE)
  myAnimation.Load()
  myHud.Load(windowWidth, windowHeight, TILE_SIZE)
  
end

function Game.Update(dt, pMenuState)
  local oldLevel = level
  
  if lvlTrans == false then
    level, pMenuState = myMachina.Update(dt, level, myMap.listGrids[level], pMenuState)
  end
  
  -- animation transition level
  if oldLevel ~= level then
    lvlTrans = true
  end
  if lvlTrans == true then
    lvlTrans = myAnimation.Update(dt, myMachina.body, lvlTrans)
  end
  
  myMap.Update(dt, level)
  myHud.Update(dt, myMachina, myMap)
  
  return pMenuState
end

function Game.Draw()
  if lvlTrans == false then
    myMap.Draw(level)
  end
  if lvlTrans == true then
    myMap.Draw(level - 1)
    myAnimation.Draw(myMachina.body)
  end
  myMachina.Draw()
  myHud.Draw(level)
end

return Game