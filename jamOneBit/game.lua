local Game = {}

local myControl = require("control")

local castlePic, castlePicW
local field = {}
field.map = {}
field.nbLines = 7
field.nbColumns = 12
Game.increment = 20

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
  for nLine = 1, field.nbLines do
    field.map[nLine] = {}
    for nColumn = 1, field.nbColumns do
      id = id + 1
      field.map[nLine][nColumn] = CreateCase(id)
    end
  end
  
  myControl.Load()
  
end

function Game.Update(pDt, pWindowHeight)
  myControl.Update(pDt, Game.increment, pWindowHeight)
end

function Game.Draw()
  love.graphics.draw(castlePic, 0, 0)
  local x = castlePicW + 24
  local y = 35
  
  local caseSize = 64
  local caseGap = 16
  
  local nLine, nColumn
  for nLine = 1, field.nbLines do
    for nColumn = 1, field.nbColumns do
      local case = field.map[nLine][nColumn]
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("fill", x, y, caseSize, caseSize)
      
      love.graphics.setColor(255, 255, 255)
      love.graphics.print(case.lvlElt, x + 4, y + 4)
      
      x = x + caseGap + caseSize
    end
    x = castlePicW + 24
    y = y + caseGap + caseSize
  end
  
  love.graphics.setColor(255, 255, 255)
  
  myControl.Draw()
  
end

return Game