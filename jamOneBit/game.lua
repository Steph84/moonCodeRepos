local Game = {}

local myControl = require("control")
local myEnnemy = require("ennemy")

local castlePic, castlePicW, wallPic
Game.Map = {}
Game.nbLines = 7
Game.nbColumns = 12
Game.increment = 1000
local wallSignal = false
local wallLevel = 0
local tempCount = 0
local colNumber = 1
local gameOver = false

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
  
  wallPic = love.graphics.newImage("pictures/wallPic.png")
  
  local nLine, nColumn
  local id = 0
  for nLine = 1, Game.nbLines do
    Game.Map[nLine] = {}
    for nColumn = 1, Game.nbColumns do
      id = id + 1
      Game.Map[nLine][nColumn] = CreateCase(id)
    end
  end
  
  myControl.Load(pWindowHeight)
  
end

function Game.Update(pDt)
  
  local signal = "game"
  
  if gameOver == false then
  
    Game.increment, wallSignal, wallLevel = myControl.Update(pDt, Game.increment, wallSignal, wallLevel)
    
    myEnnemy.Update(pDt, Game)
    
    if wallSignal == true then
      local nLine
      local id = 0
      for nLine = 1, Game.nbLines do
        --for nColumn = 1, Game.nbColumns do
          --local case = Map[nLine][nColumn]
        if Game.Map[nLine][colNumber].elt == "empty" then
          tempCount = tempCount + 1
          Game.Map[nLine][colNumber].elt = "wall"
          Game.Map[nLine][colNumber].lvlElt = wallLevel
          wallSignal = false
          
          if tempCount == Game.nbLines then
            colNumber = colNumber + 1
            tempCount = 0
          end
          
          break
        end
      end
    end
    
    local nLine2, nColumn2
    for nLine2 = 1, Game.nbLines do
      for nColumn2 = 1, Game.nbColumns do
        local k
        for k = #myEnnemy.listEnnemies, 1, -1 do
          local case = Game.Map[nLine2][nColumn2]
          local e = myEnnemy.listEnnemies[k]
          
          if Game.Map[e.coorLine][1].elt == "ennemy" then gameOver = true end
          
          if Game.Map[e.coorLine][e.coorColumn].elt == "empty" then
            Game.Map[e.coorLine][e.coorColumn].elt = "ennemy"
            Game.Map[e.coorLine][e.coorColumn].lvlElt = e.level
            
            if e.coorColumn < Game.nbColumns then
              Game.Map[e.coorLine][e.coorColumn + e.speed].elt = "empty"
              Game.Map[e.coorLine][e.coorColumn + e.speed].lvlElt = 0
            end
            
          end
          
          if Game.Map[e.coorLine][e.coorColumn].elt == "wall" then
            
            -- if wall worst than ennemy
            if Game.Map[e.coorLine][e.coorColumn].lvlElt < e.level then
              Game.Map[e.coorLine][e.coorColumn].elt = "ennemy"
              Game.Map[e.coorLine][e.coorColumn].lvlElt = e.level - 1
              
              if e.coorColumn < Game.nbColumns then
                Game.Map[e.coorLine][e.coorColumn + e.speed].elt = "empty"
                Game.Map[e.coorLine][e.coorColumn + e.speed].lvlElt = 0
              end
              
            -- if wall better than ennemy
            elseif Game.Map[e.coorLine][e.coorColumn].lvlElt > e.level then
              Game.Map[e.coorLine][e.coorColumn].lvlElt = Game.Map[e.coorLine][e.coorColumn].lvlElt - 1
              
              if e.coorColumn < Game.nbColumns then
                Game.Map[e.coorLine][e.coorColumn + e.speed].elt = "empty"
                Game.Map[e.coorLine][e.coorColumn + e.speed].lvlElt = 0
              end
              table.remove(myEnnemy.listEnnemies, k)
              
            -- if wall and ennemy are equals
            elseif Game.Map[e.coorLine][e.coorColumn].lvlElt == e.level then
              Game.Map[e.coorLine][e.coorColumn].elt = "empty"
              Game.Map[e.coorLine][e.coorColumn].lvlElt = 0
              
              if e.coorColumn < Game.nbColumns then
                Game.Map[e.coorLine][e.coorColumn + e.speed].elt = "empty"
                Game.Map[e.coorLine][e.coorColumn + e.speed].lvlElt = 0
              end
              table.remove(myEnnemy.listEnnemies, k)
            end
            
            if Game.Map[e.coorLine][e.coorColumn].lvlElt == 0 then
              Game.Map[e.coorLine][e.coorColumn].elt = "empty"
            end
            
            
          end
          
        end
      end
    end
  end
  
  if gameOver == true then
    signal = "gameOver"
  end
  return signal
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
      local case = Game.Map[nLine][nColumn]
      
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("fill", x, y, caseSize, caseSize)
      
      if case.elt == "wall" then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(wallPic, x, y)
      end
      
      if case.elt == "ennemy" then
        love.graphics.setColor(255, 255, 255)
        love.graphics.circle("fill", x + caseSize/2, y + caseSize/2, 10)
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
