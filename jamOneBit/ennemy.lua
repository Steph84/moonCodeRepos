local Ennemy = {}

local listEnnemies = {}
local timeElapsed = 0
local ennemySignal = false

function CreteEnnemy()
  local item = {}
  
  --item.coorLine = 
  --item.coorColumn = 
  --item.level = 
  --item.speed = 
  
  table.insert(listEnnemies, item)
end

function Ennemy.Update(ppDt, pMap, pNbLines)
  
  -- if there is a minimum of the first line of wall, ennemy AI activates
  if ennemySignal == false then
    local tempCount = 0
    local colNumber = 1
    local nLine
    local id = 0
    
    for nLine = 1, pNbLines do
      if pMap[nLine][colNumber].elt == "wall" then tempCount = tempCount + 1 end
    end
    
    if tempCount > 6 then ennemySignal = true end
  end
  
  if ennemySignal == true then print("avast!") end
  
  
end


return Ennemy