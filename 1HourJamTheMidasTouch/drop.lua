local Drop = {}
local windowWidth, windowHeight

Drop.listDrops = {}
local waterCount = 0
local coinCount = 0
local maxDrop, initDrop
local gameOver


function CreateDrop(pId, pWindowWidth, pWindowHeight)
  local item = {}
  
  item.x = math.random(pWindowWidth * 0.1, pWindowWidth * 0.9)
  item.y = math.random(- pWindowHeight * 0.1, 0)
  item.nature = "water"
  item.w = 16
  item.h = 32
  item.vy = math.random(3, 6)
  
  table.insert(Drop.listDrops, item)
end

function Drop.Load(pWindowWidth, pWindowHeight, pInitDrop, pNbDrop)
  windowWidth = pWindowWidth
  windowHeight = pWindowHeight
  maxDrop = pNbDrop
  initDrop = pInitDrop
  
  local i
  for i = 1, pInitDrop do
    CreateDrop(i, windowWidth, windowHeight)
  end
  
end

function Drop.Update(dt, pGameOver)
  gameOver = pGameOver
  local coef = 0.88
  coinCount = 0
  local i
  for i = #Drop.listDrops, 1, -1 do
    local d = Drop.listDrops[i]
    if d.nature == "gold" and d.y > windowHeight * coef then
    else
    d.y = d.y + d.vy
    end
    if d.nature == "water" then
      if d.y > windowHeight * 0.9 then
        table.remove(Drop.listDrops, i)
        waterCount = waterCount + 1
      end
    end
    
    if d.nature == "gold" then
      coinCount = coinCount + 1
      if d.y > windowHeight * coef then
        d.y = windowHeight * coef + 1
        d.h = 16
        d.w = 32
      end
    end
    
    
  end
  
  if #Drop.listDrops - coinCount < maxDrop then CreateDrop(#Drop.listDrops + 1, windowWidth, windowHeight) end
    
  if waterCount * 0.1 > windowHeight * 0.1 then gameOver = true end
  
  return gameOver
end

function Drop.Draw()
  local i
  for i = 1, #Drop.listDrops do
    local d = Drop.listDrops[i]
    if d.nature == "water" then
      love.graphics.setColor(0, 0, 255)
      love.graphics.rectangle("fill", d.x, d.y, d.w, d.h, 8, 8)
    end
    if d.nature == "gold" then
      love.graphics.setColor(255, 255, 0)
      love.graphics.rectangle("fill", d.x, d.y, d.w, d.h, 16, 16)
    end
  end
  
  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle("fill", 0, windowHeight - waterCount * 0.1, windowWidth, waterCount * 0.1)
  
  if waterCount * 0.1 > windowHeight * 0.1 then
    love.graphics.setColor(255, 255, 0)
    love.graphics.printf("you collected "..coinCount.." golden coins", 0, windowHeight/2, windowWidth, "center")
  end
  
end

return Drop