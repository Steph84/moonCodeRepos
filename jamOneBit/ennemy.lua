-- initialiser le random
math.randomseed(os.time())

local Ennemy = {}

Ennemy.listEnnemies = {}
local timeElapsed = 0
local ennemySignal = false
local enumLevel = { 1, 2, 4, 8 }

function CreteEnnemy(pId, pNbColumns)
  local item = {}
  
  item.coorLine = pId
  item.coorColumn = pNbColumns
  
  -- determine the level random
  local tempLvl = math.random(1, 4)
  item.level = enumLevel[tempLvl]
  
  item.speed = 1
  
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
    if #Ennemy.listEnnemies < 7 then
      local j
      for j = 1, pGame.nbLines do
        CreteEnnemy(j, pGame.nbColumns)
      end
    end
    
    timeElapsed = timeElapsed + ppDt
        
    if timeElapsed > 1 then
      local n
      for n = 1, #Ennemy.listEnnemies do
        local e = Ennemy.listEnnemies[n]
        e.coorColumn = e.coorColumn - e.speed
      end
      timeElapsed = 0
    end
    
  
  end
  
  
end


return Ennemy