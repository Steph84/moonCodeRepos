local Game = {}

local windowWidth, windowHeight, TILE_SIZE
local level = 1
local lvlTrans = false

local myMap = require("map")
local myMachina = require("machina")
local myAnimation = require("lvlAnim")

function Game.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  myMap.Load(windowWidth, windowHeight, TILE_SIZE)
  myMachina.Load(windowWidth, windowHeight, TILE_SIZE)
  myAnimation.Load()
  
end

function Game.Update(dt)
  local oldLevel = level
  
  if lvlTrans == false then
    level = myMachina.Update(dt, level, myMap.listGrids[level])
  end
  
  -- animation transition level
  if oldLevel ~= level then
    lvlTrans = true
  end
  if lvlTrans == true then
    lvlTrans = myAnimation.Update(dt, myMachina.body, lvlTrans)
  end
  
  
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
end

return Game