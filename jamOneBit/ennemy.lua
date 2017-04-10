-- initialiser le random
math.randomseed(os.time())
local Ennemy = {}

Ennemy.listEnnemies = {}
local timeElapsed = 0
local ennemySignal = false

function CreteEnnemy(pId, pNbColumns)
  local item = {}
  
  item.coorLine = pId
  item.coorColumn = pNbColumns
  item.level = 1
  item.speed = item.level
  
  table.insert(Ennemy.listEnnemies, item)
end

function Ennemy.Update(ppDt, pGame)
  
  -- if there is a minimum of the first line of wall, ennemy AI activates
  if ennemySignal == false then
    local tempCount = 0
    local colNumber = 1
    local nLine
    local id = 0
    
    for nLine = 1, pGame.nbLines do
      if pGame.Map[nLine][colNumber].elt == "wall" then tempCount = tempCount + 1 end
    end
    
    if tempCount > 6 then ennemySignal = true end
  end
  
  if ennemySignal == true then
    local j
    for j = 1, pGame.nbLines do
      CreteEnnemy(j, pGame.nbColumns)
    end
  
  
  
  
  
  end
  
  
end


return Ennemy