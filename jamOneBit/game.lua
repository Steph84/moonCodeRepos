local Game = {}

local myControl = require("control")

local castlePic, castlePicW
local Map = {}
Game.nbLines = 7
Game.nbColumns = 12
Game.increment = 0
local wallSignal = false
local tempCount = 0
local colNumber = 1

function CreateCase(pId)
  local item = {}
  
  item.id = pId
  item.elt = "empty"
  item.lvlElt = 0
  
  return item
end

function Game.Load(pWindowHeight)
  castlePic = love.graphics.newImage("pictures/castleMap.png")
  castlePicW = castlePic:getWidth()
  
  local nLine, nColumn
  local id = 0
  for nLine = 1, Game.nbLines do
    Map[nLine] = {}
    for nColumn = 1, Game.nbColumns do
      id = id + 1
      Map[nLine][nColumn] = CreateCase(id)
    end
  end
  
  myControl.Load(pWindowHeight)
  
end

function Game.Update(pDt)
  Game.increment, wallSignal = myControl.Update(pDt, Game.increment, wallSignal)
  
  if wallSignal == true then
    local nLine
    local id = 0
    for nLine = 1, Game.nbLines do
      --for nColumn = 1, Game.nbColumns do
        --local case = Map[nLine][nColumn]
      if Map[nLine][colNumber].elt == "empty" then
        tempCount = tempCount + 1
        Map[nLine][colNumber].elt = "wall"
        wallSignal = false
        
        if tempCount == 7 then
          colNumber = colNumber + 1
          tempCount = 0
        end
        
        break
      end
      
      
      
    end
  end
  
end

function Game.Draw()
  love.graphics.draw(castlePic, 0, 0)
  local x = castlePicW + 24
  local y = 35
  
  local caseSize = 64
  local caseGap = 16
  
  local nLine, nColumn
  for nLine = 1, Game.nbLines do
    for nColumn = 1, Game.nbColumns do
      local case = Map[nLine][nColumn]
      if case.elt == "empty" then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", x, y, caseSize, caseSize)
      end
      
      if case.elt == "wall" then
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("gunther", x + 32, y + 32)
      end
      
      love.graphics.setColor(255, 255, 255)
      love.graphics.print(case.lvlElt, x + 4, y + 4)
      
      x = x + caseGap + caseSize
    end
    x = castlePicW + 24
    y = y + caseGap + caseSize
  end
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(Game.increment, 150, 50)
  
  love.graphics.setColor(255, 255, 255)
  
  myControl.Draw()
  
end

return Game
