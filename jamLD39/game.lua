local Game = {}

local windowWidth, windowHeight, TILE_SIZE
local level = 1
local lvlTrans = false

local beamPic, haloPic

local myMap = require("map")
local myMachina = require("machina")

function Game.Load(pWindowWidth, pWindowHeight, pTileSize)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  TILE_SIZE = pTileSize
  
  myMap.Load(windowWidth, windowHeight, TILE_SIZE)
  myMachina.Load(windowWidth, windowHeight, TILE_SIZE)
  
  beamPic = love.graphics.newImage("pictures/animationLD39_02.png")
  haloPic = love.graphics.newImage("pictures/animationLD39_01.png")
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
  
end

function Game.Draw()
  if lvlTrans == false then
    myMap.Draw(level)
  end
  if lvlTrans == true then
    myMap.Draw(level - 1)
    love.graphics.draw(haloPic,
                       myMap.listGrids[level-1][myMachina.body.lin][myMachina.body.col].x,
                       myMap.listGrids[level-1][myMachina.body.lin][myMachina.body.col].y,
                       0, 1, 1)
    --love.graphics.draw(beamPic, myMachina.x, myMachina.y, 0, 1, 1)
  end
  myMachina.Draw()
end

return Game